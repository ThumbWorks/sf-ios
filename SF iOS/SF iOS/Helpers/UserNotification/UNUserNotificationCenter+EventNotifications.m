//
//  UNNotificationAttachment+EventNotifications.m
//  Coffup
//
//  Created by Roderic Campbell on 5/1/19.
//

#import "UNUserNotificationCenter+EventNotifications.h"
#import "Event.h"
#import "NSDate+Utilities.h"
#import "UNNotificationAttachment+EventNotifications.h"
#import "UNNotificationContent+EventNotifications.h"
#import "NSString+EventNotifications.h"

@implementation UNUserNotificationCenter (EventNotifications)

+ (UNNotificationContent *)contentForNewEvent:(Event *)event {
    NSString *contentTitle = NSLocalizedString(@"New Coffee Event",
                                               @"notification title for new events");
    NSString *contentBody = [NSString newEventNotificationBodyForEvent:event withRandomSeed:rand()];
    return [UNNotificationContent contentForEvent:event
                                            title:contentTitle
                                             body:contentBody];
}

+ (UNNotificationContent *)contentForUpdatedEvent:(Event *)event {
    NSString *contentTitle = NSLocalizedString(@"Coffee Event changed",
                                               @"notification title for changed events");

    NSString *bodyTemplate = NSLocalizedString(@"%@'s %@ at %@ has changed. Find the latest info in app.",
                                               @"notification body: <Date>'s <Event name> at <venue name> has changed");
    NSString *contentBody = [NSString stringWithFormat:bodyTemplate,
                             [event.date dateString],
                             event.name,
                             event.venueName];
    return [UNNotificationContent contentForEvent:event
                                            title:contentTitle
                                             body:contentBody];
}

+ (void)scheduleLocalNotificationForEvent:(Event *)event type:(EventNotificationType)type {
    UNNotificationContent *content;
    switch (type) {
        case EventNotificationTypeChanged:
            content = [self contentForUpdatedEvent:event];
            break;
        case EventNotificationTypeNew:
            content = [self contentForNewEvent:event];
            break;
    }

    UNUserNotificationCenter *notificationCenter = [UNUserNotificationCenter currentNotificationCenter];

    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:event.eventID
                                                                          content:content
                                                                          trigger:nil];
    [notificationCenter addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"error %@", error);
        }
    }];
}
@end
