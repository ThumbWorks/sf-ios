//
//  EventNotificationCopyTests.m
//  SF iOSTests
//
//  Created by Roderic Campbell on 5/1/19.
//

#import <XCTest/XCTest.h>
#import "NSString+EventNotifications.h"
#import "Event.h"
@interface EventNotificationCopyTests : XCTestCase
@property (nonatomic) Event *event;

@end

@implementation EventNotificationCopyTests
- (void)setUp {
    [super setUp];
    NSDictionary *location = @{
                               @"formatted_address" : @"formatted_address",
                               @"latitude": @"-127.0",
                               @"longitude": @"37.0"
                               };
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
    self.event.date = [NSDate dateWithTimeIntervalSince1970:123456];
}

- (void)testMeetYourFriends {
    NSString *expected = @"Meet your friends Jan 2, 1970 at The Venue Name for Event name";
    NSString *notificationBody = [NSString newEventNotificationBodyForEvent:self.event withRandomSeed:0];
    XCTAssertTrue([notificationBody isEqualToString: expected]);
}

- (void)testEveryoneYouKnow {
    NSString *expected = @"Everyone you know will be at The Venue Name on Jan 2, 1970 for Event name";
    NSString *notificationBody = [NSString newEventNotificationBodyForEvent:self.event withRandomSeed:1];
    XCTAssertTrue([notificationBody isEqualToString: expected]);
}

- (void)testDidYouHearAbout {
    NSString *expected = @"Did you hear about Event name at The Venue Name on Jan 2, 1970";
    NSString *notificationBody = [NSString newEventNotificationBodyForEvent:self.event withRandomSeed:2];
    XCTAssertTrue([notificationBody isEqualToString: expected]);
}

@end
