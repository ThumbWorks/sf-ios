//
//  TravelTime+Arrival.h
//  SF iOS
//
//  Created by Amit Jain on 8/8/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import "TravelTime.h"

typedef NS_ENUM(NSUInteger, Arrival) {
    ArrivalOnTime,
    ArrivalDuringEvent,
    ArrivalAfterEvent,
    ArrivalImpossible,
};

@interface TravelTime (Arrival)

- (Arrival)arrivalToEventWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate;

@end
