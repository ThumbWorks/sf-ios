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
#import <Realm/Realm.h>

@interface EventDataSource ()

@property (nonatomic, assign) EventType eventType;
@property (nonatomic) RLMResults<Event *> *events;
@property (nonatomic) FeedFetchService *service;
@property (nonatomic) RLMNotificationToken *notificationToken;
@property (nonatomic) RLMRealm *realm;
@end

@implementation EventDataSource

- (instancetype)initWithEventType:(EventType)eventType {
    if (self = [super init]) {
        self.eventType = eventType;
        self.events = [[Event allObjects] sortedResultsUsingKeyPath:@"date" ascending:false];
        self.service = [[FeedFetchService alloc] init];
        [self observeAppActivationEvents];
        self.realm = [RLMRealm defaultRealm];
        __weak typeof(self) welf = self;
        self.notificationToken = [self.events
                                  addNotificationBlock:^(RLMResults<Event *> *results, RLMCollectionChange *changes, NSError *error) {

                                      if (error) {
                                          [welf.delegate didFailToUpdateWithError:error];
                                          return;
                                      }
                                      // Initial run of the query will pass nil for the change information
                                      if (!changes) {
                                          return;
                                      }

                                      NSArray *inserts = [changes insertionsInSection:0];
                                      NSArray *deletions = [changes deletionsInSection:0];
                                      NSArray *updates = [changes modificationsInSection:0];

                                      [welf.delegate didChangeDataSourceWithInsertions:inserts
                                                                               updates:updates deletions:deletions];
                                  }];
    }
    return self;
}

- (void)dealloc {
    [self.notificationToken invalidate];
}

- (void)refresh {
    __weak typeof(self) welf = self;
    [self.service getFeedWithHandler:^(NSArray<Event *> * _Nonnull feedFetchItems, NSError * _Nullable error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [welf.delegate didFailToUpdateWithError:error];
            });
            return;
        }
        // Persist your data easily
        RLMRealm *realm = [RLMRealm defaultRealm];

        // Fetch all existing events from the realm and map by {eventID : Event}
        NSMutableDictionary *existingEvents = [[NSMutableDictionary alloc] init];
        for (Event *object in [Event allObjects]) {
            [existingEvents setObject:object forKey:object.eventID];
        }

        // determine if the
        NSMutableArray *addToRealm = [NSMutableArray array];
        for (Event *parsedEvent in feedFetchItems) {
            Event *existingEvent = existingEvents[parsedEvent.eventID];
            if (existingEvent) {
                // If the event exists in the realm AND the parsed event is different, add it to the realm
                if(![existingEvent isEqual:parsedEvent]) {
                    [addToRealm addObject:parsedEvent];
                }
            } else {
                [addToRealm addObject:parsedEvent];
            }
        }

        if ([addToRealm count]) {
            [realm transactionWithBlock:^{
                [realm addOrUpdateObjects:addToRealm];
            }];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [welf.delegate didChangeDataSourceWithInsertions:nil updates:nil deletions:nil];
            });
        }

    }];
    [self.delegate willUpdateDataSource:self];
}

- (Event *)eventAtIndex:(NSUInteger)index {
    return self.events[index];
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

@end

