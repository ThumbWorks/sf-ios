//
//  BackgroundFetcher.h
//  Coffup
//
//  Created by Roderic Campbell on 4/17/19.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Check for changes on the server to provide event changes notifications
 */
@interface BackgroundFetcher : NSObject

- (instancetype)initWithCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler;

@end

NS_ASSUME_NONNULL_END
