//
//  LocationTests.m
//  SF iOSTests
//
//  Created by Roderic Campbell on 3/29/19.
//  Copyright © 2019 Amit Jain. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Location.h"
@interface LocationTests : XCTestCase
@property (nonatomic) Location *location;
@end

@implementation LocationTests

- (void)setUp {
    NSDictionary *locationDict = @{@"formatted_address": @"This is the address",
                                   @"latitude" : @(-124),
                                   @"longitude" : @35
                                   };
    self.location = [[Location alloc] initWithDictionary:locationDict];
}

- (void)testLatitude {
    CLLocationDegrees lon = self.location.location.coordinate.longitude;
    CLLocationDegrees lat = self.location.location.coordinate.latitude;
    XCTAssertEqual(lon, 35);
    XCTAssertEqual(lat, -124);
}

- (void)testTitle {
    XCTAssertEqual(self.location.streetAddress, @"This is the address");
}
@end
