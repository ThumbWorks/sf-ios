//
//  EventDataSourceTests.m
//  SF iOSTests
//
//  Created by Amit Jain on 7/30/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "EventDataSource.h"
#import "FeedProviderDelegate.h"
#import <Realm/Realm.h>
#import "Group.h"

@interface EventDataSourceTests : XCTestCase <FeedProviderDelegate>
@property (nonatomic) EventDataSource *dataSource;
@property (nonatomic) XCTestExpectation *fetchingExpectation;
@property (nonatomic) Event *event;
@property (nonatomic) Group *group;
@property (nonatomic) RLMRealmConfiguration *realmConfiguration;
@end

@implementation EventDataSourceTests


- (void)setUp {
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

    self.group = [[Group alloc] init];
    self.group.groupID = @"28ef50f9-b909-4f03-9a69-a8218a8cbd99";
    self.event = [[Event alloc] initWithDictionary:dict];

    _fetchingExpectation = [self expectationWithDescription:@"Wait for events"];

    self.realmConfiguration = [RLMRealmConfiguration defaultConfiguration];

    // In-memory Realms do not save data across app launches, but all other features of Realm will work as expected, including querying, relationships and thread-safety. This is a useful option if you need flexible data access without the overhead of disk persistence.
    [self.realmConfiguration setInMemoryIdentifier:@"UnitTest"];

    [RLMRealmConfiguration setDefaultConfiguration:self.realmConfiguration];

    self.dataSource = [[EventDataSource alloc] initWithGroup:self.group];

    self.dataSource.delegate = self;
    [super setUp];
}

- (void)testAddingEvents {
    RLMRealm *realm = [RLMRealm realmWithConfiguration:self.realmConfiguration error:nil];
    [realm transactionWithBlock:^{
        [realm addObject:self.event];
    }];

    [self waitForExpectationsWithTimeout:1.0 handler:^(NSError *error) {
        XCTAssertEqual(self.dataSource.numberOfItems, 1);
        if (error) {
            XCTFail(@"Expectation failed \(error)");
            NSLog(@"%@",error.localizedDescription);
        }
    }];
}

- (void)didChangeDataSource:(nonnull id<FeedProvider>)datasource withInsertions:(nullable NSArray<NSIndexPath *> *)insertions updates:(nullable NSArray<NSIndexPath *> *)updates deletions:(nullable NSArray<NSIndexPath *> *)deletions {
    [_fetchingExpectation fulfill];
}

- (void)didFailToUpdateDataSource:(nonnull id<FeedProvider>)datasource withError:(NSError * _Nonnull)error {
    XCTFail(@"failed to update data source");
}

- (void)willUpdateDataSource:(nonnull id<FeedProvider>)datasource {
    // no op
}

@end
