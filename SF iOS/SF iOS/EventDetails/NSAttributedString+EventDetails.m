//
//  NSAttributedString+EventDetails.m
//  SF iOS
//
//  Created by Amit Jain on 8/8/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import "NSAttributedString+EventDetails.h"
#import "NSDate+Utilities.h"
#import "NSAttributedString+Kerning.h"

@implementation NSAttributedString (EventDetails)

+ (NSAttributedString *)attributedDetailsStringFromEvent:(Event *)event {
    NSDate *eventDate = event.date;
    NSDate *currentDate = [NSDate new];
    NSString *timeLabelText;
    
    // If the event is ongoing: "Ends in 45mins"
    if ([currentDate isBetweenEarlierDate:eventDate laterDate:event.endDate]) {
        NSString *remainingtime = [event.endDate abbreviatedTimeintervalFromNow];
        timeLabelText = [NSString stringWithFormat:@"Ends in %@", remainingtime];
    }
    // If the event is upcoming today: "in 32min"
    else if (eventDate.isInFuture && eventDate.isToday) {
        timeLabelText = [NSString stringWithFormat:@"in %@", eventDate.abbreviatedTimeintervalFromNow];
    }
    // If the event is upcoming this week: "Wednesday 8:30 - 10:00am"
    else if (eventDate.isInFuture && eventDate.isThisWeek) {
        NSString *weekday = [eventDate weekdayName];
        NSString *time = [NSDate timeslotStringFromStartDate:eventDate duration:event.duration];
        timeLabelText = [NSString stringWithFormat:@"%@ %@", weekday, time];
    }
    // Otherwise: "Oct 11 8:30 - 10:00am"
    else {
        NSString *date = [eventDate stringWithformat:@"MMM d"];
        NSString *time = [NSDate timeslotStringFromStartDate:eventDate duration:event.duration];
        timeLabelText = [NSString stringWithFormat:@"%@ %@", date, time];
    }
    NSString *subTitleText = [event.venueName stringByAppendingFormat:@"\n%@", timeLabelText];
    return [NSAttributedString kernedStringFromString:[subTitleText uppercaseString]];
}

@end
