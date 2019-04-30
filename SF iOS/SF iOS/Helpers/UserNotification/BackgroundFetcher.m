//
//  BackgroundFetcher.m
//  Coffup
//
//  Created by Roderic Campbell on 4/17/19.
//

#import "BackgroundFetcher.h"
#import "EventDataSource.h"
#import "UNUserNotificationCenter+EventNotifications.h"
#import "NSDate+Utilities.h"
#import "Analytics.h"
#import "NSUserDefaults+Settings.h"

@interface BackgroundFetcher () <FeedProviderDelegate>
// The backgroundDataSource will tell us what if anything has changed
@property (nonatomic) EventDataSource *backgroundDataSource;
@property (nonatomic, copy) void (^backgroundCompletionBlock)(UIBackgroundFetchResult);
@end

@implementation BackgroundFetcher

- (instancetype)initWithCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    if (self = [super init]) {
        // TODO need to figure out which of the data sources they care about
        self.backgroundDataSource = [[EventDataSource alloc] init];
        self.backgroundDataSource.delegate = self;
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

        // start the fetch/check process
        [self.backgroundDataSource refresh];
    }

    return self;
}

- (void)didChangeDataSourceWithInsertions:(nullable NSArray<NSIndexPath *> *)insertions updates:(nullable NSArray<NSIndexPath *> *)updates deletions:(nullable NSArray<NSIndexPath *> *)deletions {

    // No changes
    if (insertions == nil && deletions == nil && updates == nil) {
        self.backgroundCompletionBlock(UIBackgroundFetchResultNoData);
        return;
    }

    // all empty arrays also signifies no changes
    if ([updates count] == 0 && [deletions count] == 0 && [insertions count] == 0) {
        self.backgroundCompletionBlock(UIBackgroundFetchResultNoData);
        return;
    }

    // TODO until group interactions are merged in this is always sf-ios-coffee
    BOOL shouldAlert = [[NSUserDefaults standardUserDefaults] notificationSettingForGroup:nil];
    if (!shouldAlert) {
    // Tell the OS that we got new data but we don't really do anything about it
        self.backgroundCompletionBlock(UIBackgroundFetchResultNewData);
        return;
    }

    NSInteger currentBadgeCount = [[UIApplication sharedApplication] applicationIconBadgeNumber];

    for (NSIndexPath *update in updates) {
        Event *event = [self.backgroundDataSource eventAtIndex:[update row]];

        // Prevent notifications if changes, e.g. images and URLs, are made to past events
        if ([[event endDate] isInFuture] == NO) {
            continue;
        }
        [UNUserNotificationCenter scheduleLocalNotificationForEvent:event
                                                               type:EventNotificationTypeChanged];
        currentBadgeCount++;
    }

    // This is a new event, it should have a nice alert.
    for (NSIndexPath *insert in insertions) {
        Event *event = [self.backgroundDataSource eventAtIndex:[insert row]];
        // Prevent notifications if changes, e.g. images and URLs, are made to past events
        if ([[event endDate] isInFuture] == NO) {
            continue;
        }
        [UNUserNotificationCenter scheduleLocalNotificationForEvent:event
                                                               type:EventNotificationTypeNew];
        currentBadgeCount++;
    }

    // Increment the badge value by one every time a fetch with a change occurs
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:currentBadgeCount];

    // Tell the OS that we got new data. It should adjust accordingly.
    self.backgroundCompletionBlock(UIBackgroundFetchResultNewData);
}

- (void)didFailToUpdateWithError:(nonnull NSError *)error {
        self.backgroundCompletionBlock(UIBackgroundFetchResultFailed);
}

- (void)willUpdateDataSource:(nonnull EventDataSource *)datasource {
    NSLog(@"will update background fetcher data source ");
        // no op. We asked it to update
}

@end
