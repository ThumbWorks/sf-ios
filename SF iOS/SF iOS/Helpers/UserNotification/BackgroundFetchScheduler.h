//
//  BackgroundFetchScheduler.h
//  Coffup
//
//  Created by Zachary Drayer on 6/3/19.
//

@import UIKit;

@interface BackgroundFetchScheduler : NSObject

- (void)schedule;
- (void)registerLaunchHandlers;

// only needed for <= iOS 12
- (void)startWithCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler;

@end
