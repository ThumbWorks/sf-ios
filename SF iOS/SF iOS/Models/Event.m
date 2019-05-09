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

@implementation Event

- (instancetype)initWithDictionary:(NSDictionary *)record {
    if (self = [super init]) {
        self.eventID = record[@"id"];
        self.groupID = record[@"group_id"];
        self.type = 0;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
        NSString *startAt = record[@"start_at"];
        self.date = [formatter dateFromString:startAt];
        self.endDate = [formatter dateFromString:record[@"end_at"]];
        self.duration = [self.endDate timeIntervalSinceDate:self.date];
        self.venue = [[Venue alloc] initWithDictionary:record[@"venue"]];
        self.imageFileURLString = record[@"image_url"];
        self.name = record[@"name"];
    }
    
    return self;
}

+ (NSString *)primaryKey {
    return @"eventID";
}

- (UIImage *)annotationGlyph {
    switch (self.type) {
        case EventTypeSFCoffee:
            return [UIImage imageNamed:@"coffee-map-glyph"];
            break;
        default:
            break;
    }
    // For now there are no other types
    return [UIImage imageNamed:@"coffee-map-glyph"];

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

- (BOOL)isEqual:(Event *)object {
    return [[self eventID] isEqualToString:[object eventID]] &&
    [self type] == [object type] &&
    [[self date] isEqualToDate:[object date]] &&
    [self duration] == [object duration] &&
    [[self venue] isEqual:[object venue]] &&
    [[self name] isEqualToString:[object name]] &&
    [[self endDate] isEqualToDate:[object endDate]] &&
    [self isActive] == [object isActive] &&
    ([[self imageFileURLString] isEqualToString:[object imageFileURLString]] || [self imageFileURLString] == nil);
}

-(NSUInteger)hash {
    return [[self eventID] hash] +
    [self type] +
    [[self date] hash] +
    [self duration] +
    [[self venue] hash] +
    [[self name] hash] +
    [[self endDate] hash] +
    [self isActive] +
    [[self imageFileURLString] hash];
}
@end
