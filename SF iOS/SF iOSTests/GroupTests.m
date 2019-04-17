//
//  GroupTests.m
//  SF iOSTests
//
//  Created by Roderic Campbell on 4/17/19.
//

#import <XCTest/XCTest.h>
#import "Group.h"
@interface GroupTests : XCTestCase

@property (nonatomic) Group *group;
@end

@implementation GroupTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    NSDictionary *data = @{
                           @"id": @"28ef50f9-b909-4f03-9a69-a8218a8cbd99",
                           @"slug": @"sf-ios-coffee",
                           @"name": @"SF iOS Coffee",
                           @"image_url": @"https://fastly.4sqi.net/img/general/612x612/403777_tR60tUZMVoJ5Q5ylr8hQnp0pgZTy5BOQLqydzAoHWiA.jpg"
                           };
    self.group = [[Group alloc] initWithDictionary:data];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testID {
    XCTAssertTrue([[self.group groupID] isEqualToString:@"28ef50f9-b909-4f03-9a69-a8218a8cbd99"]);
}

- (void)testName {
    XCTAssertTrue([[self.group name] isEqualToString:@"SF iOS Coffee"]);
}

- (void)testSlug {
    XCTAssertTrue([[self.group slug] isEqualToString:@"sf-ios-coffee"]);
}

- (void)testImageURL {
    XCTAssertTrue([[self.group imageURLString] isEqualToString:@"https://fastly.4sqi.net/img/general/612x612/403777_tR60tUZMVoJ5Q5ylr8hQnp0pgZTy5BOQLqydzAoHWiA.jpg"]);
}

@end
