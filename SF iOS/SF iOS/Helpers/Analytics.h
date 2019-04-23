//
//  Analytics.h
//  Coffup
//
//  Created by Roderic Campbell on 4/22/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Analytics : NSObject
- (void)start;
- (void)trackEvent:(NSString *)event;
- (void)trackEvent:(NSString *)event withProperties:(NSDictionary <NSString *, NSString *> *)properties;
@end

NS_ASSUME_NONNULL_END
