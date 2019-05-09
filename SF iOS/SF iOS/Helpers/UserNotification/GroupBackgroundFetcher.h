//
//  GroupBackgroundFetcher.h
//  Coffup
//
//  Created by Roderic Campbell on 5/9/19.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GroupBackgroundFetcher : NSObject
- (instancetype)initWithCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler;
- (void)start;
@end

NS_ASSUME_NONNULL_END
