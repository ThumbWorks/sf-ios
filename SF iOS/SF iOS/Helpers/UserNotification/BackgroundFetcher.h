//
//  BackgroundFetcher.h
//  Coffup
//
//  Created by Roderic Campbell on 4/17/19.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class Group;

NS_ASSUME_NONNULL_BEGIN

/**
 Check for changes on the server to provide event changes notifications
 */
@interface BackgroundFetcher : NSObject

- (instancetype)initForGroup:(Group *)group
         withCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler;

@end

NS_ASSUME_NONNULL_END
