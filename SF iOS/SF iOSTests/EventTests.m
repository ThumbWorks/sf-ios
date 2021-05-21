//
//  EventTests.m
//  SF iOSTests
//
//  Created by Roderic Campbell on 3/29/19.
//

#import <XCTest/XCTest.h>
#import "Event.h"
#import "Venue.h"
#import "NSDate+Utilities.h"

@interface EventTests : XCTestCase

@property (nonatomic) Event *event;
@property (nonatomic) Event *secondEvent;

@end

@implementation EventTests
- (void)setUp {
    [super setUp];
    NSDictionary *location = @{@"formatted_address": @"736 Divisadero St (btwn Grove St Fulton St), San Francisco, CA 94117, United States",
                               @"latitude": @(37.77632881728594),
                               @"longitude": @(-122.43802428245543)};
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
    self.event = [[Event alloc] initWithDictionary:dict dateFormatter:[NSDate formatter]];
    self.event.type = EventTypeSFCoffee;
    self.event.date = [NSDate new];
    self.event = [[Event alloc] initWithDictionary:dict dateFormatter:[NSDate formatter]];
    self.secondEvent = [[Event alloc] initWithDictionary:dict dateFormatter:[NSDate formatter]];

    self.secondEvent.type = EventTypeSFCoffee;
    self.secondEvent.date = self.event.date;
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


- (void)testEqual {
    XCTAssert([self.event isEqual:self.secondEvent]);
}

- (void)testEqualNames {
    self.secondEvent.name = @"something else";
    XCTAssertFalse([self.event isEqual:self.secondEvent]);
}

- (void)testEqualDate {
    self.secondEvent.date = [self.secondEvent.date dateByAddingTimeInterval:1];
    XCTAssertFalse([self.event isEqual:self.secondEvent]);
}

- (void)testEqualDuration {
    self.secondEvent.duration = 123;
    XCTAssertFalse([self.event isEqual:self.secondEvent]);
}

- (void)testEqualVenue {
    self.secondEvent.venue = [[Venue alloc] init];
    XCTAssertFalse([self.event isEqual:self.secondEvent]);
}

- (void)testEqualEventID {
    self.secondEvent.eventID = @"";
    XCTAssertFalse([self.event isEqual:self.secondEvent]);
}

- (void)testEqualEndDate {
    self.secondEvent.endDate = [self.event.endDate dateByAddingTimeInterval:1];
    XCTAssertFalse([self.event isEqual:self.secondEvent]);
}

- (void)testEqualImageFileURLString {
    self.secondEvent.imageFileURLString = @"some url string";
    XCTAssertFalse([self.event isEqual:self.secondEvent]);
}

@end
