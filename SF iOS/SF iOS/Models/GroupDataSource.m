//
//  GroupDataSource.m
//  Coffup
//
//  Created by Roderic Campbell on 4/17/19.
//

#import "GroupDataSource.h"
#import "Group.h"
#import "GroupFetchService.h"
#import <Realm/Realm.h>
#import "NSNotification+ApplicationEventNotifications.h"

@interface GroupDataSource()

@property (nonatomic) RLMResults<Group *> *groups;
@property (nonatomic) GroupFetchService *service;
@property (nonatomic) RLMRealm *realm;
@property (nonatomic) RLMNotificationToken *notificationToken;
@end

@implementation GroupDataSource

- (instancetype)init {
    if (self = [super init]) {
        self.groups = [Group allObjects];
        self.service = [[GroupFetchService alloc] init];
        [self observeAppActivationEvents];
        self.realm = [RLMRealm defaultRealm];
        __weak typeof(self) welf = self;
        self.notificationToken = [self.groups
                                  addNotificationBlock:^(RLMResults<Group *> *results, RLMCollectionChange *changes, NSError *error) {

                                      if (error) {
                                          [welf.delegate didFailToUpdateDataSource:welf
                                                                         withError:error];
                                          return;
                                      }
                                      // Initial run of the query will pass nil for the change information
                                      if (!changes) {
                                          [welf.delegate didChangeDataSource:welf
                                                              withInsertions:nil
                                                                                   updates:nil
                                                                                 deletions:nil];
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

- (Group *)groupAtIndex:(NSUInteger)index {
    return self.groups[index];
}

- (NSUInteger)numberOfItems {
    return self.groups.count;
}

- (void)refresh {
    __weak typeof(self) welf = self;
    [self.service getGroupsWithHandler:^(NSArray<Group *> * _Nonnull groupFetchItems, NSError * _Nullable error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [welf.delegate didFailToUpdateDataSource:welf
                                               withError:error];
            });
            return;
        }

        // Persist your data easily
        RLMRealm *realm = [RLMRealm defaultRealm];

        // Fetch all existing groups from the realm and map by {groupID : Event}
        NSMutableDictionary *existingGroups = [[NSMutableDictionary alloc] init];
        for (Group *object in [Group allObjects]) {
            [existingGroups setObject:object forKey:object.groupID];
        }

        // determine if the
        NSMutableArray *addToRealm = [NSMutableArray array];
        NSMutableDictionary *removeFromRealm = [existingGroups mutableCopy];
        for (Group *parsedGroup in groupFetchItems) {
            Group *existingGroup = existingGroups[parsedGroup.groupID];
            if (existingGroup) {
                // If the group exists in the realm AND the parsed group is different, add it to the realm
                if(![existingGroup isEqual:parsedGroup]) {
                    [addToRealm addObject:parsedGroup];
                }
                [removeFromRealm removeObjectForKey:existingGroup.groupID];
            } else {
                // if this is an item that is not in the realm, add it
                [addToRealm addObject:parsedGroup];
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

- (void)observeAppActivationEvents {
    __weak typeof(self) welf = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:NSNotification.applicationBecameActiveNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        [welf refresh];
    }];
}

- (Group *)groupWithID:(NSString *)groupID {
    return [[Group objectsWhere:@"groupID = %@", groupID] firstObject];
}
@end
