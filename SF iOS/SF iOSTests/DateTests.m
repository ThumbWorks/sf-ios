//
//  DateTests.m
//  SF iOSTests
//
//  Created by Amit Jain on 8/6/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSDate+Utilities.h"

@interface DateTests : XCTestCase
@end

@implementation DateTests

- (void)testLaterThanDate {
    NSDate *now = [[NSDate alloc] initWithTimeIntervalSince1970:2000];
    NSDate *later = [now dateByAddingTimeInterval:1000];
    XCTAssertTrue([later isLaterThanDate:now]);
}

- (void)testBefioreThanDate {
    NSDate *now = [[NSDate alloc] initWithTimeIntervalSince1970:2000];
    NSDate *earlier = [now dateByAddingTimeInterval:-01000];
    XCTAssertTrue([earlier isEarlierThanDate:now]);
}


@end
