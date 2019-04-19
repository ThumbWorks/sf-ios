//
//  UNUserNotificationCenter+Convenience.m
//  SF iOS
//
//  Created by Jerry Tung on 4/4/19.
//  Copyright © 2019 Amit Jain. All rights reserved.
//

#import "UNUserNotificationCenter+ConvenienceInitializer.h"
#import "NSDate+Utilities.h"


@implementation UNUserNotificationCenter(Convenience)

- (void)scheduleNotificationWithIdentifier:(NSString*)identifier
                                   content:(UNMutableNotificationContent*)content
                                   trigger:(UNTimeIntervalNotificationTrigger*)trigger {

    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier content:content trigger:trigger];

    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError* error) {
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
        }
    }];
}

- (void)scheduleNotificationWithIdentifier:(NSString* __nullable)identifier
                              contentTitle:(NSString*)title
                               contentBody:(NSString*)body {

    // Must be greater than 0.0
    UNTimeIntervalNotificationTrigger* trigger = [UNTimeIntervalNotificationTrigger
                                                  triggerWithTimeInterval:(0.2) repeats: NO];

    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = title;
    content.body = body;

    NSString *requestIdentifier = (identifier != nil) ? identifier : [[NSDate date] stringWithformat:@"yyyyMMdd:hhmmss"];

    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifier content:content trigger:trigger];

    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError* error) {
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
        }
    }];

}

@end
