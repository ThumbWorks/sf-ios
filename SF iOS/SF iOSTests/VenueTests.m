//
//  VenueTests.m
//  SF iOSTests
//
//  Created by Roderic Campbell on 3/29/19.
//

#import <XCTest/XCTest.h>
#import "Venue.h"
#import "Location.h"

@interface VenueTests : XCTestCase
@property (nonatomic) Venue *venue;
@property (nonatomic) Venue *secondVenue;
@end

@implementation VenueTests
- (void)setUp {
    [super setUp];
    NSDictionary *location = @{};
    NSDictionary *venueDictionary = @{
                                      @"name": @"The Venue Name",
                                      @"location": location,
                                      @"url": @"https://foursquare.com/v/four-barrel-coffee/480d1a5ef964a520284f1fe3"
                                      };
    self.venue = [[Venue alloc] initWithDictionary:venueDictionary];
    self.secondVenue = [[Venue alloc] initWithDictionary:venueDictionary];
}

- (void)testName {
    XCTAssertTrue([self.venue.name isEqualToString:@"The Venue Name"]);
}

- (void)testURL {
    NSURL *URL = [[NSURL alloc] initWithString:@"https://foursquare.com/v/four-barrel-coffee/480d1a5ef964a520284f1fe3"];
    XCTAssertTrue([self.venue.venueURL isEqual:URL]);
}

-(void)testEqualURL {
    self.secondVenue.venueURLString = @"something else";
    XCTAssertFalse([self.venue isEqual:self.secondVenue]);
}

-(void)testEqualLocation {
    self.secondVenue.location = [[Location alloc] init];
    XCTAssertFalse([self.venue isEqual:self.secondVenue]);
}

-(void)testEqualName {
    self.secondVenue.name = @"something else";
    XCTAssertFalse([self.venue isEqual:self.secondVenue]);
}


@end
