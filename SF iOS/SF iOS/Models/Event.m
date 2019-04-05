//
//  Event.m
//  SF iOS
//
//  Created by Amit Jain on 7/29/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import "Event.h"
#import "NSDate+Utilities.h"
#import "Venue.h"

@import CloudKit;

@implementation Event

- (instancetype)initWithDictionary:(NSDictionary *)record {
    if (self = [super init]) {
        self.eventID = record[@"id"];
        self.type = 0;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
        NSString *startAt = record[@"start_at"];
        self.date = [formatter dateFromString:startAt];
        NSDate *endDate = [formatter dateFromString:record[@"end_at"]];
        self.duration = [endDate timeIntervalSinceDate:self.date];
        self.venue = [[Venue alloc] initWithDictionary:record[@"venue"]];

        self.imageFileURLString = record[@"image_url"];
        self.name = record[@"name"];
    }
    
    return self;
}

- (UIImage *)annotationImage {
    switch (self.type) {
        case EventTypeSFCoffee:
            return [UIImage imageNamed:@"coffee-location-icon"];
            break;
        default:
            break;
    }
    // For now there are no other types
    return [UIImage imageNamed:@"coffee-location-icon"];

}

- (NSDate *)endDate {
    return [self.date dateByAddingTimeInterval:self.duration];
}

- (BOOL)isActive {
    return self.endDate.isInFuture;
}

- (nullable NSURL *)venueURL {
    return self.venue.venueURL;
}

- (Location *)location {
    return self.venue.location;
}

- (NSString *)venueName {
    return self.venue.name;
}

- (nullable NSURL *)imageFileURL {
    if (!self.imageFileURLString) {
        return nil;
    }
    return [[NSURL alloc] initWithString:self.imageFileURLString];
}
@end
