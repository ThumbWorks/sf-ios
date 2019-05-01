//
//  NSString+EventNotifications.m
//  Coffup
//
//  Created by Roderic Campbell on 5/1/19.
//

#import "NSString+EventNotifications.h"
#import "Event.h"
#import "NSDate+Utilities.h"
typedef NSString* (^BodyCreationBlock)( Event *blockevent);

@implementation NSString (EventNotifications)
+ (NSString *)newEventNotificationBodyForEvent:(Event *)event withRandomSeed:(NSUInteger)seed {
    NSArray<BodyCreationBlock> *bodyBlocks = @[
                                               [[self meetYourFriendsForEvent:event] copy],
                                               [[self everyoneYouKnow:event] copy],
                                               [[self didYouHearAbout:event] copy],
                                               ];
    NSUInteger offset = seed % bodyBlocks.count;
    NSLog(@" %lu %lu", (unsigned long)bodyBlocks.count, (unsigned long)offset);
    return bodyBlocks[offset](event);
}

+ (BodyCreationBlock)meetYourFriendsForEvent:(Event *)event {
    NSString * (^meetYourFriendsAtBlock)(Event *) = ^NSString *(Event *blockEvent) {
        NSString *bodyTemplate = NSLocalizedString(@"Meet your friends %@ at %@ for %@",
                                                   @"notification body for newly created events: Meet your friends <date> at <venue> for <event name>");

        NSString *contentBody = [NSString stringWithFormat:bodyTemplate,
                                 [event.date dateString],
                                 event.venueName,
                                 event.name];
        return contentBody;
    };
    return meetYourFriendsAtBlock;
}

+ (BodyCreationBlock)didYouHearAbout:(Event *)event {
    NSString * (^didYouHearAboutBlock)(Event *) = ^NSString *(Event *blockEvent) {
        NSString *bodyTemplate = NSLocalizedString(@"Did you hear about %@ at %@ on %@",
                                                   @"notification body for newly created events: Did you hear about <event name> at <Venue> on <date>");
        NSString *contentBody = [NSString stringWithFormat:bodyTemplate,
                                 event.name,
                                 event.venueName,
                                 [event.date dateString]];
        return contentBody;
    };
    return didYouHearAboutBlock;
}

+ (BodyCreationBlock)everyoneYouKnow:(Event *)event {
    NSString * (^everyoneYouKnowBlock)(Event *) = ^NSString *(Event *blockEvent) {
        NSString *bodyTemplate = NSLocalizedString(@"Everyone you know will be at %@ on %@ for %@",
                                                   @"notification body for newly created events: Everyone you know will meet at <Event name> at <Venue name> for <event name>");
        NSString *contentBody = [NSString stringWithFormat:bodyTemplate,
                                 event.venueName,
                                 [event.date dateString],
                                 event.name];
        return contentBody;
    };
    return everyoneYouKnowBlock;
}

@end
