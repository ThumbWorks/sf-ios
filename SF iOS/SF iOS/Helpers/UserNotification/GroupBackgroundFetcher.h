//
//  GroupBackgroundFetcher.h
//  Coffup
//
//  Created by Roderic Campbell on 5/9/19.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, GroupBackgroundFetcherResult) {
	GroupBackgroundFetcherResultNoData,
	GroupBackgroundFetcherResultNewData,
	GroupBackgroundFetcherResultFailed
};

NS_ASSUME_NONNULL_BEGIN

@interface GroupBackgroundFetcher : NSObject
- (instancetype)initWithCompletionHandler:(void (^)(GroupBackgroundFetcherResult result))completionHandler;
- (void)start;
@end

NS_ASSUME_NONNULL_END
