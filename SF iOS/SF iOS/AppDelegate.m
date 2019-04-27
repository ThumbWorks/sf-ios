//
//  AppDelegate.m
//  SF iOS
//
//  Created by Amit Jain on 7/28/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import "AppDelegate.h"
#import "NSNotification+ApplicationEventNotifications.h"
#import "SwipableNavigationContainer.h"
#import "BackgroundFetcher.h"
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate ()
@property (nonatomic) SwipableNavigationContainer *navigationContainer;
@property (nonatomic) BackgroundFetcher *bgFetcher;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.navigationContainer = [[SwipableNavigationContainer alloc] init];
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UNUserNotificationCenter *notificationCenter = [UNUserNotificationCenter currentNotificationCenter];
    UNAuthorizationOptions options = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
    [notificationCenter requestAuthorizationWithOptions:options
                                      completionHandler:^(BOOL granted, NSError *error){}];

    [self setSharedNetworkCacheMemoryMegabytes:5
                                 diskMegabytes:25];
    [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];

    [self.navigationContainer.window makeKeyAndVisible];
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];

    [[NSNotificationCenter defaultCenter] postNotificationName:NSNotification.applicationBecameActiveNotification object:nil];
}

- (UIWindow *)window {
    return self.navigationContainer.window;
}

// MARK: - Background Fetch
- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    self.bgFetcher = [[BackgroundFetcher alloc] initWithCompletionHandler:^(UIBackgroundFetchResult result) {
        completionHandler(result);
        self.bgFetcher = nil;
    }];
}

//MARK: - Configure cache
- (void)setSharedNetworkCacheMemoryMegabytes:(NSInteger)memoryMiB diskMegabytes:(NSInteger)diskMiB
{
    NSUInteger cashSize = memoryMiB * 1024 * 1024;
    NSUInteger cashDiskSize = diskMiB * 1024 * 1024;
    NSURLCache *imageCache = [[NSURLCache alloc] initWithMemoryCapacity:cashSize
                                                           diskCapacity:cashDiskSize
                                                               diskPath:@"networking"];
    [NSURLCache setSharedURLCache:imageCache];
}

@end
