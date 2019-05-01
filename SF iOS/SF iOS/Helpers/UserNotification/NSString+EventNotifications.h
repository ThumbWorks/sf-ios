//
//  NSString+EventNotifications.h
//  Coffup
//
//  Created by Roderic Campbell on 5/1/19.
//

#import <Foundation/Foundation.h>
@class Event;

NS_ASSUME_NONNULL_BEGIN

@interface NSString (EventNotifications)
+ (NSString *)newEventNotificationBodyForEvent:(Event *)event withRandomSeed:(NSUInteger)seed;
@end

NS_ASSUME_NONNULL_END
