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

@interface AppDelegate ()
@property (nonatomic) SwipableNavigationContainer *navigationContainer;
@property (nonatomic) BackgroundFetcher *bgFetcher;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self migrations];
    self.navigationContainer = [[SwipableNavigationContainer alloc] init];
    return YES;
}

- (void)migrations {
    RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
    // Set the new schema version. This must be greater than the previously used
    // version (if you've never set a schema version before, the version is 0).
    config.schemaVersion = 1;

    // Set the block which will be called automatically when opening a Realm with a
    // schema version lower than the one set above
    config.migrationBlock = ^(RLMMigration *migration, uint64_t oldSchemaVersion) {
        // We haven’t migrated anything yet, so oldSchemaVersion == 0
        if (oldSchemaVersion < 1) {
            // Nothing to do!
            // Realm will automatically detect new properties and removed properties
            // And will update the schema on disk automatically
        }
    };

    // Tell Realm to use this new configuration object for the default Realm
    [RLMRealmConfiguration setDefaultConfiguration:config];

    // Now that we've told Realm how to handle the schema change, opening the file
    // will automatically perform the migration
    [RLMRealm defaultRealm];
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
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
