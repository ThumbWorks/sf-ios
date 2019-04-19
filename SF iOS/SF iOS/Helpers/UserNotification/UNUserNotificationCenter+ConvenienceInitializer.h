//
//  UNUserNotificationCenter+Convenience.h
//  SF iOS
//
//  Created by Jerry Tung on 4/4/19.
//  Copyright © 2019 Amit Jain. All rights reserved.
//

#import <UserNotifications/UserNotifications.h>

NS_ASSUME_NONNULL_BEGIN

@interface UNUserNotificationCenter(Convenience)
- (void)scheduleNotificationWithIdentifier:(NSString*)identifier
                                   content:(UNMutableNotificationContent*)content
                                   trigger:(UNTimeIntervalNotificationTrigger*)trigger;

- (void)scheduleNotificationWithIdentifier:(NSString* __nullable)identifier
                              contentTitle:(NSString*)title
                               contentBody:(NSString*)body;

@end

NS_ASSUME_NONNULL_END
