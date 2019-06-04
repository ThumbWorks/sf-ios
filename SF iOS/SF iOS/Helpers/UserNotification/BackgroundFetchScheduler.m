//
//  BackgroundFetchScheduler.m
//  Coffup
//
//  Created by Zachary Drayer on 6/3/19.
//

#import "BackgroundFetchScheduler.h"
#import "GroupBackgroundFetcher.h"

#if defined(__IPHONE_13_0)
@import BackgroundTasks;
#endif

@import UIKit;

static NSString *const BackgroundTaskGroupUpdateIdentifier = @"BackgroundTaskGroupUpdateIdentifier";

@interface BackgroundFetchScheduler ()

@property (nonatomic) GroupBackgroundFetcher *bgFetcher;

@end

@implementation BackgroundFetchScheduler

- (void)schedule
{
#if defined(__IPHONE_13_0)
	if (@available(iOS 13.0, *)) {
		// cancel existing task
		[BGTaskScheduler.sharedScheduler cancelTaskRequestWithIdentifier:BackgroundTaskGroupUpdateIdentifier];

		// re-schedule it
		BGAppRefreshTaskRequest *taskRequest = [[BGAppRefreshTaskRequest alloc] initWithIdentifier:BackgroundTaskGroupUpdateIdentifier];
		taskRequest.earliestBeginDate = [NSDate dateWithTimeIntervalSinceNow:60 * 60]; // wait at least an hour

		NSError *taskSubmissionError = nil;
		BOOL taskSubmitted = [BGTaskScheduler.sharedScheduler submitTaskRequest:taskRequest error:&taskSubmissionError];
		if (!taskSubmitted) {
			// oops
		}
	} else {
#endif
		[UIApplication.sharedApplication setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
#if defined(__IPHONE_13_0)
	}
#endif
}

- (void)registerLaunchHandlers
{
#if defined(__IPHONE_13_0)
	if (@available(iOS 13.0, *)) {
		[BGTaskScheduler.sharedScheduler registerForTaskWithIdentifier:BackgroundTaskGroupUpdateIdentifier
															usingQueue:dispatch_get_main_queue()
														 launchHandler:^(BGTask *task) {
															 self.bgFetcher = [[GroupBackgroundFetcher alloc] initWithCompletionHandler:^(GroupBackgroundFetcherResult result) {
																 BOOL const success = (result != GroupBackgroundFetcherResultFailed);
																 [task setTaskCompletedWithSuccess:success];
															 }];
															 [self.bgFetcher start];
														 }];
	};
#endif
}

- (void)startWithCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler
{
	self.bgFetcher = [[GroupBackgroundFetcher alloc] initWithCompletionHandler:^(GroupBackgroundFetcherResult result) {
		UIBackgroundFetchResult uiResult = UIBackgroundFetchResultNoData;
		switch (result) {
			case GroupBackgroundFetcherResultNoData:
				uiResult = UIBackgroundFetchResultNoData;
				break;
			case GroupBackgroundFetcherResultNewData:
				uiResult = UIBackgroundFetchResultNewData;
				break;
			case GroupBackgroundFetcherResultFailed:
				uiResult = UIBackgroundFetchResultFailed;
				break;
		}
		completionHandler(uiResult);
	}];
	[self.bgFetcher start];
}

@end
