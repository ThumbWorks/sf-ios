//
//  GroupBackgroundFetcher.m
//  Coffup
//
//  Created by Roderic Campbell on 5/9/19.
//

#import <UIKit/UIKit.h>
#import <Realm/Realm.h>
#import "GroupBackgroundFetcher.h"
#import "BackgroundFetcher.h"
#import "NSUserDefaults+Settings.h"
#import "Group.h"
#import "Analytics.h"

@interface GroupBackgroundFetcher()
@property (nonatomic, copy) void (^backgroundCompletionBlock)(UIBackgroundFetchResult);
@property (nonatomic, assign) UIBackgroundFetchResult latestResult;
@property (nonatomic) NSMutableArray<BackgroundFetcher *> *groupFetchers;
@end

@implementation GroupBackgroundFetcher

- (instancetype)initWithCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    self = [super init];
    if (self) {
        self.backgroundCompletionBlock = ^ (UIBackgroundFetchResult result) {
            Analytics *analytics = [[Analytics alloc] init];
            [analytics trackEvent:@"Background fetch complete"
                   withProperties:@{@"result" :  @(result)}
                     onCompletion:^(NSError * _Nullable error) {
                         if (error) {
                             NSLog(@"An error occured in analytics %@", error);
                         }
                         completionHandler(result);
                     }];
        };
        self.groupFetchers = [NSMutableArray array];
    }
    return self;
}

- (void)start {
    NSDictionary *notificationSettings = [[NSUserDefaults standardUserDefaults] notificationSettings];
    NSSet *keys = [notificationSettings keysOfEntriesPassingTest:^BOOL(NSString *key, id obj, BOOL *stop){
        return [notificationSettings[key] boolValue] == true;
    }];

    RLMResults<Group *> *groups = [Group objectsWhere:@"groupID in %@", keys];
    dispatch_group_t dipatchGroup = dispatch_group_create();

    __weak typeof(self) welf = self;
    for (Group *group in groups) {
        NSString *groupName = group.name;
        dispatch_group_enter(dipatchGroup);
        BackgroundFetcher *fetcher = [[BackgroundFetcher alloc] initForGroup:group withCompletionHandler:^(UIBackgroundFetchResult result) {
            switch (result) {
                case UIBackgroundFetchResultNewData:
                    // Don't do anything. We got new data at one point, keep it going
                    break;
                case UIBackgroundFetchResultNoData:
                    welf.latestResult = result;
                    break;
                case UIBackgroundFetchResultFailed:
                    // New data takes priority, nothing else mattersm
                    if (result == UIBackgroundFetchResultNewData) {
                        welf.latestResult = UIBackgroundFetchResultNewData;
                    }
                    break;
            }
            dispatch_group_leave(dipatchGroup);
        }];

        [self.groupFetchers addObject:fetcher];
    }
    dispatch_group_wait(dipatchGroup, DISPATCH_TIME_FOREVER);
    // Won't get here until everything has finished
    self.backgroundCompletionBlock(self.latestResult);
}
@end
