//
//  EventDataSOurce.m
//  SF iOS
//
//  Created by Amit Jain on 7/29/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import "EventDataSource.h"
#import "Event.h"
#import "NSDate+Utilities.h"
#import "NSError+Constructor.h"
#import "NSNotification+ApplicationEventNotifications.h"
#import "FeedFetchService.h"
#import "Group.h"
#import <Realm/Realm.h>

@interface EventDataSource ()

@property (nonatomic) FeedFetchService *service;
@property (nonatomic) RLMNotificationToken *notificationToken;
@property (nonatomic) NSString *groupID;

- (RLMResults<Event *> *)filterEventsWithSearchTerm:(NSString *)searchTerm;
@end

@implementation EventDataSource
- (id)initWithGroup:(Group *)group {
    if (self = [super init]) {
        self.searchQuery = @"";
        self.group = group;
        self.groupID = group.groupID;
        self.service = [[FeedFetchService alloc] initWithGroupID:self.groupID];
        [self observeAppActivationEvents];
        __weak typeof(self) welf = self;
        self.notificationToken = [self.events
                                  addNotificationBlock:^(RLMResults<Event *> *results, RLMCollectionChange *changes, NSError *error) {

                                      if (error) {
                                          [welf.delegate didFailToUpdateDataSource:welf
                                                                         withError:error];
                                          return;
                                      }
                                      // Initial run of the query will pass nil for the change information
                                      if (!changes) {
                                          return;
                                      }

                                      NSArray *inserts = [changes insertionsInSection:0];
                                      NSArray *deletions = [changes deletionsInSection:0];
                                      NSArray *updates = [changes modificationsInSection:0];

                                      [welf.delegate didChangeDataSource:welf
                                                          withInsertions:inserts
                                                                 updates:updates
                                                               deletions:deletions];
                                  }];
    }
    return self;
}

- (void)dealloc {
    [self.notificationToken invalidate];
}

- (NSString *)groupName {
    return self.group.name;
}

/// Events array
/// The getter will return predicated if the _searchQuery is set
///
/// - returns: RLMResults<Event *> * Events array
- (RLMResults<Event *> *)events {
    if (self.searchQuery.length > 0) {
        return [self filterEventsWithSearchTerm:self.searchQuery];
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"groupID = %@", self.groupID];
    return [[[Event allObjects] objectsWithPredicate:predicate] sortedResultsUsingKeyPath:@"date" ascending:false];
}



/// Maps [Event] by {eventID : Event}
///
/// - parameters:
///     - objects: RLMResults<Event *> The events to be mapped
/// - returns: NSMutableDictionary<[eventID<NSString> : Event *]>
- (NSMutableDictionary *)mapEventIDs:(RLMResults<Event *> *)objects {
    NSMutableDictionary *mappedEvents = [[NSMutableDictionary alloc] init];
    for (Event *object in objects) {
        [mappedEvents setObject:object forKey:object.eventID];
    }
    return mappedEvents;
}

- (void)refresh {
    __weak typeof(self) welf = self;

    [self.service getFeedWithHandler:^(NSArray<Event *> * _Nonnull feedFetchItems, NSError * _Nullable error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [welf.delegate didFailToUpdateDataSource:welf
                                                withError:error];
            });
            return;
        }
        // Persist your data easily
        RLMRealm *realm = [RLMRealm defaultRealm];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"groupID = %@", self.groupID];
        RLMResults<Event *> *events = [[[Event allObjects] objectsWithPredicate:predicate] sortedResultsUsingKeyPath:@"date" ascending:false];

        NSMutableDictionary *existingEvents = [self mapEventIDs:events];

        // determine if the
        NSMutableArray *addToRealm = [NSMutableArray array];
        NSMutableDictionary *removeFromRealm = [existingEvents mutableCopy];
        for (Event *parsedEvent in feedFetchItems) {
            Event *existingEvent = existingEvents[parsedEvent.eventID];
            if (existingEvent) {
                // If the event exists in the realm AND the parsed event is different, add it to the realm
                if(![existingEvent isEqual:parsedEvent]) {
                    [addToRealm addObject:parsedEvent];
                }
                [removeFromRealm removeObjectForKey:existingEvent.eventID];
            } else {
                [addToRealm addObject:parsedEvent];
            }
        }

        if ([addToRealm count] || [removeFromRealm count]) {
            [realm transactionWithBlock:^{
                if([addToRealm count]) {
                    [realm addOrUpdateObjects:addToRealm];
                }
                if([removeFromRealm count]) {
                    [realm deleteObjects:[removeFromRealm allValues]];
                }
            }];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [welf.delegate didChangeDataSource:welf
                                    withInsertions:nil
                                           updates:nil
                                         deletions:nil];
            });
        }

    }];
    [self.delegate willUpdateDataSource:self];
}

- (Event *)eventAtIndex:(NSUInteger)index {
    return self.events[index];
}

/// Updates EventDataSoruce [Event] by text search or gets all events if there is no search term
///
/// - paramaters:
///     -searchTerm: string to search
/// - returns: RLMResults<Event *>* array of Events
- (RLMResults<Event *> *)filterEventsWithSearchTerm:(NSString *)searchTerm {    
    NSPredicate *coffeeFilter = [NSPredicate predicateWithFormat:@"name CONTAINS[c] %@ OR venue.name CONTAINS[c] %@ && groupID = %@", searchTerm, searchTerm, self.groupID];
    RLMResults<Event *> *filteredCoffee = [[Event objectsWithPredicate:coffeeFilter]
                                           sortedResultsUsingKeyPath:@"date" ascending:false];
    return filteredCoffee;
}

- (NSUInteger)indexOfCurrentEvent {
    return [self.events indexOfObjectWhere:@"endDate > %@", [NSDate date]];
}

//MARK: - Respond To app Events

- (void)observeAppActivationEvents {
    __weak typeof(self) welf = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:NSNotification.applicationBecameActiveNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        [welf refresh];
    }];
}

/// FeedProvider protocol

- (NSUInteger)numberOfItems {
    return self.events.count;
}

- (NSUInteger)indexOfCurrentItem {
    return self.indexOfCurrentEvent;
}

@end

