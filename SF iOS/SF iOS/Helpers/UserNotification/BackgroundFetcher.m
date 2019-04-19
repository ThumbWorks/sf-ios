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

@interface BackgroundFetcher () <EventDataSourceDelegate>
// The backgroundDataSource will tell us what if anything has changed
@property (nonatomic) EventDataSource *backgroundDataSource;
@property (nonatomic, copy) void (^backgroundCompletionBlock)(UIBackgroundFetchResult);
@end

@implementation BackgroundFetcher

- (instancetype)initWithCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    if (self = [super init]) {
        self.backgroundDataSource = [[EventDataSource alloc] initWithEventType:EventTypeSFCoffee];
        self.backgroundDataSource.delegate = self;
        self.backgroundCompletionBlock = completionHandler;

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
        NSString *contentTitle = NSLocalizedString(@"Coffee Events change",
                                                   @"notification title for changed events");
        Event *event = [self.backgroundDataSource eventAtIndex:[update row]];
        NSString *bodyTemplate = NSLocalizedString(@"%@ at %@ has changed. Find the latest info in app.",
                                                   @"notification body: <Event name> at <venue name> has changed");
        NSString *contentBody = [NSString stringWithFormat:bodyTemplate,
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
        NSString *contentTitle = NSLocalizedString(@"New Event",
                                                   @"notification title for new events");

        NSString *bodyTemplate = NSLocalizedString(@"meet your friends at %@ for %@",
                                                   @"notification body for newly created events");
        NSString *contentBody = [NSString stringWithFormat:bodyTemplate,
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
