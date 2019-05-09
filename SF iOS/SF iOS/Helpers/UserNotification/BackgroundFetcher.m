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

@interface BackgroundFetcher () <FeedProviderDelegate>
// The backgroundDataSource will tell us what if anything has changed
@property (nonatomic) EventDataSource *backgroundDataSource;
@property (nonatomic, copy) void (^backgroundCompletionBlock)(UIBackgroundFetchResult);
@end

@implementation BackgroundFetcher

- (instancetype)initForGroup:(Group *)group
         withCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    if (self = [super init]) {
        self.backgroundDataSource = [[EventDataSource alloc] initWithGroup:group];
        self.backgroundDataSource.delegate = self;
        self.backgroundCompletionBlock = completionHandler;
        // start the fetch/check process
        [self.backgroundDataSource refresh];
    }

    return self;
}

- (void)didChangeDataSource:(nonnull id<FeedProvider>)datasource withInsertions:(nullable NSArray<NSIndexPath *> *)insertions updates:(nullable NSArray<NSIndexPath *> *)updates deletions:(nullable NSArray<NSIndexPath *> *)deletions {

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

- (void)didFailToUpdateDataSource:(nonnull id<FeedProvider>)datasource withError:(NSError * _Nonnull)error {
    self.backgroundCompletionBlock(UIBackgroundFetchResultFailed);
}

- (void)willUpdateDataSource:(nonnull EventDataSource *)datasource {
        // no op. We asked it to update
}

@end
