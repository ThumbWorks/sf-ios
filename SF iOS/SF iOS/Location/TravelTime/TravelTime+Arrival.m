//
//  TravelTime+Arrival.m
//  SF iOS
//
//  Created by Amit Jain on 8/8/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import "TravelTime+Arrival.h"
#import "NSDate+Utilities.h"

@implementation TravelTime (Arrival)

- (Arrival)arrivalToEventWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate {
    if (self.travelTime < 0) {
        return ArrivalImpossible;
    }

    // if the event is in the past, magnitudes do not matter
    if ([endDate isEarlierThanDate:[NSDate new]]) {
        return ArrivalOnTime;
    }
    
    NSDate *arrivalDate = [NSDate dateWithTimeIntervalSinceNow:self.travelTime];
    
    // arrive on time
    if ([arrivalDate isEarlierThanDate:startDate]) {
        return ArrivalOnTime;
    }
    // arrive before event end
    else if ([arrivalDate isEarlierThanDate:endDate]) {
        return ArrivalDuringEvent;
    } else {
        return ArrivalAfterEvent;
    }
}

@end
