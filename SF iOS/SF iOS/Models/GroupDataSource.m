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
                                          [welf.delegate didFailToUpdateWithError:error];
                                          return;
                                      }
                                      // Initial run of the query will pass nil for the change information
                                      if (!changes) {
                                          [welf.delegate didChangeDataSourceWithInsertions:nil
                                                                                   updates:nil
                                                                                 deletions:nil];
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

- (Group *)groupAtIndex:(NSUInteger)index {
    return [[Group alloc] initWithDictionary:@{}]; // NO
}
- (NSUInteger)indexOfCurrentItem {
    // TODO when we set the current feed
    return 0;
}

- (NSUInteger)numberOfItems {
    return self.groups.count;
}

- (void)refresh {
    __weak typeof(self) welf = self;
    [self.service getGroupsWithHandler:^(NSArray<Group *> * _Nonnull groupFetchItems, NSError * _Nullable error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [welf.delegate didFailToUpdateWithError:error];
            });
            return;
        }
        NSLog(@"Groups %@", groupFetchItems);
    }];
}

- (void)observeAppActivationEvents {
    __weak typeof(self) welf = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:NSNotification.applicationBecameActiveNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        [welf refresh];
    }];
}
@end
