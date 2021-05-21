//
//  NSDate+Utilities.m
//  SF iOS
//
//  Created by Amit Jain on 7/31/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import "NSDate+Utilities.h"

@implementation NSDate (Utilities)

- (BOOL)isYesterday {
    return [[NSCalendar currentCalendar] isDateInYesterday:self];
}

- (BOOL)isToday {
    return [[NSCalendar currentCalendar] isDateInToday:self];
}

- (BOOL)isTomorrow {
    return [[NSCalendar currentCalendar] isDateInTomorrow:self];
}

-(NSString *)relativeDayRepresentation {
    if (self.isYesterday) {
        return NSLocalizedString(@"Yesterday",
                                 @"The day before today");
    } else if (self.isToday) {
        return NSLocalizedString(@"Today", @"Today");
    } else if (self.isTomorrow) {
        return NSLocalizedString(@"Tomorrow", @"Tomorrow");
    } else {
        return nil;
    }
}

- (BOOL)isThisWeek {
    return [self isInThisCalendarUnit:NSCalendarUnitYear] && [self isInThisCalendarUnit:NSCalendarUnitWeekOfYear];
}

- (BOOL)isThisYear {
    return [self isInThisCalendarUnit:NSCalendarUnitYear];
}

- (BOOL)isInThisCalendarUnit:(NSCalendarUnit)unit {
    NSInteger dateUnit = [[NSCalendar currentCalendar] component:unit fromDate:self];
    NSInteger currentUnit = [[NSCalendar currentCalendar] component:unit fromDate:[NSDate new]];
    return dateUnit == currentUnit;
}

- (BOOL)isInFuture {
    return [self compare:[NSDate new]] == NSOrderedDescending;
}

- (NSString *)abbreviatedTimeintervalFromNow {
    NSTimeInterval difference = [self timeIntervalSinceNow];
    return [NSDate abbreviatedTimeIntervalForTimeInterval:difference];
}

+ (NSISO8601DateFormatter *)formatter {
    NSISO8601DateFormatter *formatter = [[NSISO8601DateFormatter alloc] init];
    [formatter setFormatOptions: NSISO8601DateFormatWithFullDate |
     NSISO8601DateFormatWithFullTime |
     NSISO8601DateFormatWithTimeZone |
     NSISO8601DateFormatWithDashSeparatorInDate |
     NSISO8601DateFormatWithColonSeparatorInTime |
     NSISO8601DateFormatWithColonSeparatorInTimeZone |
     NSISO8601DateFormatWithFractionalSeconds];
    return formatter;
}

+ (NSString *)abbreviatedTimeIntervalForTimeInterval:(NSTimeInterval)timeInterval {
    NSDateComponentsFormatter *formatter = [NSDateComponentsFormatter new];
    formatter.unitsStyle = NSDateComponentsFormatterUnitsStyleAbbreviated;
    
    if (timeInterval > 86400) {
        formatter.allowedUnits = NSCalendarUnitDay | NSCalendarUnitHour;
    } else {
        formatter.allowedUnits = NSCalendarUnitHour | NSCalendarUnitMinute;
    }
    
    return [formatter stringFromTimeInterval:timeInterval];
}

+ (NSString *)timeslotStringFromStartDate:(NSDate *)startDate duration:(NSTimeInterval)duration {
    NSDate *endDate = [startDate dateByAddingTimeInterval:duration];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    BOOL startDateIsInAM = [calendar component:NSCalendarUnitHour fromDate:startDate] < 12;
    BOOL endDateIsInAM = [calendar component:NSCalendarUnitHour fromDate:endDate] < 12;
    BOOL shouldShowPeriodInStartDate = (startDateIsInAM != endDateIsInAM); // show period when start and end are in different periods
    
    NSString *timeFormat = @"h:mm";
    NSString *timeFormatWithPeriod = @"h:mma";
    NSString *startTime = [startDate stringWithformat:shouldShowPeriodInStartDate ? timeFormatWithPeriod : timeFormat];
    NSString *endTime = [endDate stringWithformat:timeFormatWithPeriod];
    
    return [@[startTime, endTime] componentsJoinedByString:@" - "];
}

- (NSString *)stringWithformat:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    return [formatter stringFromDate:self];
}

- (NSString *)weekdayName {
    return [self stringWithformat:@"E"];
}

- (BOOL)isLaterThanDate:(NSDate *)date {
    return [self compare:date] == NSOrderedDescending;
}

- (BOOL)isEarlierThanDate:(NSDate *)date {
    return [self compare:date] == NSOrderedAscending;
}

- (BOOL)isBetweenEarlierDate:(NSDate *)earlierDate laterDate:(NSDate *)laterDate {
    return [self isLaterThanDate:earlierDate] && [self isEarlierThanDate:laterDate];
}

- (NSString *)dateString {
    NSString *relativeDate = self.relativeDayRepresentation;
    if (relativeDate) {
        return relativeDate;
    } else if (self.isThisYear) {
        return [self stringWithformat:@"MMM d"];
    } else {
        return [self stringWithformat:@"MMM d, yyyy"];
    }
}
@end
