//
//  Analytics.h
//  Coffup
//
//  Created by Roderic Campbell on 4/22/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^TrackingComplete)(NSError *_Nullable error);


@interface Analytics : NSObject
- (void)trackEvent:(NSString *)event withProperties:(NSDictionary <NSString *, id> *)properties onCompletion:(TrackingComplete)onCompletion;
@end

NS_ASSUME_NONNULL_END
