//
//  EventTests.m
//  SF iOSTests
//
//  Created by Roderic Campbell on 3/29/19.
//  Copyright © 2019 Amit Jain. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Event.h"
@interface EventTests : XCTestCase

@property (nonatomic) Event *event;

@end

@implementation EventTests
- (void)setUp {
    [super setUp];
    NSDictionary *location = @{};
    NSDictionary *venue = @{
                            @"name": @"The Venue Name",
                            @"location": location,
                            @"url": @"https://foursquare.com/v/four-barrel-coffee/480d1a5ef964a520284f1fe3"
                            };
    NSDictionary *dict = @{@"end_at": @"2019-04-03T17:00:00.000Z",
                           @"group_id": @"28ef50f9-b909-4f03-9a69-a8218a8cbd99",
                           @"id": @"adb7eb98-ed48-4d09-8eba-2f3acec9cf64",
                           @"image_url": @"https://fastly.4sqi.net/img/general/720x537/mIIPSQkw8mreYwS5STIU3srMXddR2rQD56uzvcEL7n4.jpg",
                           @"name": @"Event name",
                           @"venue": venue,
                           @"start_at": @"2019-04-03T15:30:00.000Z"
                           };
    self.event = [[Event alloc] initWithDictionary:dict];
    self.event.type = EventTypeSFCoffee;
    self.event.date = [NSDate new];
}

- (void)testName {
    XCTAssertTrue([self.event.name isEqualToString:@"Event name"]);
}

- (void)testEventURL {
    NSURL *URL = [[NSURL alloc] initWithString:@"https://foursquare.com/v/four-barrel-coffee/480d1a5ef964a520284f1fe3"];
    XCTAssertTrue([self.event.venueURL isEqual:URL]);
}

- (void)testImageURL {
    NSURL *URL = [[NSURL alloc] initWithString:@"https://fastly.4sqi.net/img/general/720x537/mIIPSQkw8mreYwS5STIU3srMXddR2rQD56uzvcEL7n4.jpg"];
    XCTAssertTrue([self.event.imageFileURL isEqual:URL]);
}

- (void)testVenueName {
    XCTAssertTrue([self.event.venueName isEqual:@"The Venue Name"]);
}



@end
