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

@property (nonatomic) RLMResults<Event *> *events;
@property (nonatomic) FeedFetchService *service;
@property (nonatomic) RLMNotificationToken *notificationToken;

- (RLMResults<Event *> *)filterEventsWithSearchTerm:(NSString *)searchTerm;
@end

@implementation EventDataSource
// TODO This is only here until we figure out how to initialize the whole thing without a default group
- (id)initWithGroupID:(NSString *)feedID forEventsInSection:(NSUInteger)section {
    if (self = [super init]) {
        self.searchQuery = @"";
        self.groupID = feedID;
        self.events = [[Event allObjects] sortedResultsUsingKeyPath:@"date" ascending:false];
        self.service = [[FeedFetchService alloc] initWithGroupID:feedID];
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

                                      NSArray *inserts = [changes insertionsInSection:section];
                                      NSArray *deletions = [changes deletionsInSection:section];
                                      NSArray *updates = [changes modificationsInSection:section];

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

/// Events array
/// The getter will return predicated if the _searchQuery is set
///
/// - returns: RLMResults<Event *> * Events array
- (RLMResults<Event *> *)events {
    if (self.searchQuery.length > 0) {
        return [self filterEventsWithSearchTerm:self.searchQuery];
    }
    return [[Event allObjects] sortedResultsUsingKeyPath:@"date" ascending:false];
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
        NSMutableDictionary *existingEvents = [self mapEventIDs:[Event allObjects]];

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
    NSPredicate *coffeeFilter = [NSPredicate predicateWithFormat:@"name CONTAINS[c] %@ OR venue.name CONTAINS[c] %@", searchTerm, searchTerm];
    RLMResults<Event *> *filteredCoffee = [[Event objectsWithPredicate:coffeeFilter]
                                           sortedResultsUsingKeyPath:@"date" ascending:false];
    return filteredCoffee;
}

- (NSUInteger)numberOfEvents {
    return self.events.count;
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
    return self.numberOfEvents;
}

- (NSUInteger)indexOfCurrentItem {
    return self.indexOfCurrentEvent;
}

@end

