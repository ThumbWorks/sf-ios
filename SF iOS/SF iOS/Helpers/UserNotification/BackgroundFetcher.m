//
//  BackgroundFetcher.m
//  Coffup
//
//  Created by Roderic Campbell on 4/17/19.
//

#import "BackgroundFetcher.h"
#import "EventDataSource.h"
#import <UserNotifications/UserNotifications.h>
#import "UNUserNotificationCenter+ConvenienceInitializer.h"
#import "NSDate+Utilities.h"
#import "Analytics.h"

@interface BackgroundFetcher () <FeedProviderDelegate>
// The backgroundDataSource will tell us what if anything has changed
@property (nonatomic) EventDataSource *backgroundDataSource;
@property (nonatomic, copy) void (^backgroundCompletionBlock)(UIBackgroundFetchResult);
@end

@implementation BackgroundFetcher

- (instancetype)initWithCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    if (self = [super init]) {
        self.backgroundDataSource = [[EventDataSource alloc] initWithEventType:EventTypeSFCoffee];
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
    NSInteger currentBadgeCount = [[UIApplication sharedApplication] applicationIconBadgeNumber];

    for (NSIndexPath *update in updates) {
        Event *event = [self.backgroundDataSource eventAtIndex:[update row]];

        // Prevent notifications if changes, e.g. images and URLs, are made to past events
        if ([[event endDate] isInFuture] == NO) {
            continue;
        }
        NSString *contentTitle = NSLocalizedString(@"Coffee Event changed",
                                                   @"notification title for changed events");
        
        NSString *bodyTemplate = NSLocalizedString(@"%@'s %@ at %@ has changed. Find the latest info in app.",
                                                   @"notification body: <Date>'s <Event name> at <venue name> has changed");
        NSString *contentBody = [NSString stringWithFormat:bodyTemplate,
                                 [event.date dateString],
                                 event.name,
                                 event.venueName];
        UNUserNotificationCenter *notificationCenter = [UNUserNotificationCenter currentNotificationCenter];
        [notificationCenter scheduleNotificationWithIdentifier:event.eventID
                                                  contentTitle:contentTitle
                                                   contentBody:contentBody];
        currentBadgeCount++;
    }

    // This is a new event, it should have a nice alert.
    for (NSIndexPath *insert in insertions) {
        Event *event = [self.backgroundDataSource eventAtIndex:[insert row]];
        NSString *contentTitle = NSLocalizedString(@"New Coffee Event",
                                                   @"notification title for new events");

        NSString *bodyTemplate = NSLocalizedString(@"Meet your friends %@ at %@ for %@",
                                                   @"notification body for newly created events");
        NSString *contentBody = [NSString stringWithFormat:bodyTemplate,
                                 [event.date dateString],
                                 event.venueName,
                                 event.name];
        UNUserNotificationCenter *notificationCenter = [UNUserNotificationCenter currentNotificationCenter];
        [notificationCenter scheduleNotificationWithIdentifier:event.eventID
                                                  contentTitle:contentTitle
                                                   contentBody:contentBody];
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
