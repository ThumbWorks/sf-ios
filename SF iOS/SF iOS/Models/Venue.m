//
//  Venue.m
//  SF iOS
//
//  Created by Roderic Campbell on 3/29/19.
//  Copyright © 2019 Amit Jain. All rights reserved.
//

#import "Venue.h"
#import "Location.h"

@implementation Venue
- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        self.venueURLString = dict[@"url"];
        self.location = [[Location alloc] initWithDictionary:dict[@"location"]];
        self.name = dict[@"name"];
    }
    return self;
}

+ (NSString *)primaryKey {
    return @"venueURLString";
}

- (nullable NSURL *)venueURL {
    if (!self.venueURLString) {
        return nil;
    }
    return [[NSURL alloc] initWithString:self.venueURLString];
}

- (BOOL)isEqual:(Venue *)object {
    return [[self venueURLString] isEqualToString:[object venueURLString]] &&
    [[self name] isEqualToString:[object name]] &&
    [[self location] isEqual:[object location]];
}

-(NSUInteger)hash {
    return [[self venueURLString] hash] + [[self name] hash] + [[self location] hash];
}
@end
