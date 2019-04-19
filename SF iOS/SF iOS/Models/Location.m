//
//  Location.m
//  SF iOS
//
//  Created by Amit Jain on 7/28/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import "Location.h"

@implementation Location

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        self.streetAddress = dict[@"formatted_address"];
        if (![dict[@"latitude"] isKindOfClass:[NSNull class]]) {
            CLLocationDegrees latitude = [dict[@"latitude"] doubleValue];
            self.latitude = latitude;
        }
        if (![dict[@"longitude"] isKindOfClass:[NSNull class]]) {
            CLLocationDegrees longitude = [dict[@"longitude"] doubleValue];
            self.longitude = longitude;
        }
    }
    return self;
}

- (CLLocation *)location {
    return [[CLLocation alloc] initWithLatitude:self.latitude
                                      longitude:self.longitude];
}

- (BOOL)isEqual:(Location *)object {
    return [[self streetAddress] isEqualToString:[object streetAddress]] &&
    [self latitude] == [object latitude] &&
    [self longitude] == [object longitude];
}

-(NSUInteger)hash {
    return [[self streetAddress] hash];
}
@end
