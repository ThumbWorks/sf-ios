//
//  SettingsTests.m
//  SF iOSTests
//
//  Created by Roderic Campbell on 5/3/19.
//

#import <XCTest/XCTest.h>
#import "NSUserDefaults+Settings.h"
#import "Group.h"

static NSString *const kSettingTestSuiteName = @"coffee.coffeecoffeecoffee.settingstests";

@interface SettingsTests : XCTestCase
@property (nonatomic) Group *group1;
@property (nonatomic) Group *group2;
@end

@implementation SettingsTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.group1 = [[Group alloc] init];
    self.group1.groupID = @"group1ID";
    self.group2 = [[Group alloc] init];
    self.group2.groupID = @"group2ID";
    [[[NSUserDefaults alloc] init] removePersistentDomainForName:kSettingTestSuiteName];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testSettingGroup1StartsFalse {
    NSUserDefaults *testDefaults = [[NSUserDefaults alloc] initWithSuiteName:kSettingTestSuiteName];
    XCTAssertFalse([testDefaults notificationSettingForGroupWithID:self.group1.groupID]);
}

- (void)testSettingGroup1ToTrue {
    NSUserDefaults *testDefaults = [[NSUserDefaults alloc] initWithSuiteName:kSettingTestSuiteName];
    [testDefaults setNotificationSetting:TRUE forGroupWithID:self.group1.groupID];
    XCTAssertTrue([testDefaults notificationSettingForGroupWithID:self.group1.groupID]);
}

- (void)testSettingGroup1ToFalse {
    NSUserDefaults *testDefaults = [[NSUserDefaults alloc] initWithSuiteName:kSettingTestSuiteName];
    [testDefaults setNotificationSetting:FALSE forGroupWithID:self.group1.groupID];
    XCTAssertFalse([testDefaults notificationSettingForGroupWithID:self.group1.groupID]);
}

- (void)testSettingGroup2ToFalseAfterGroup1SettingExists {
    NSUserDefaults *testDefaults = [[NSUserDefaults alloc] initWithSuiteName:kSettingTestSuiteName];
    [testDefaults setNotificationSetting:FALSE forGroupWithID:self.group1.groupID];
    [testDefaults setNotificationSetting:FALSE forGroupWithID:self.group2.groupID];
    XCTAssertFalse([testDefaults notificationSettingForGroupWithID:self.group2.groupID]);
}

- (void)testSettingGroup2ToTrueAfterGroup1SettingExists {
    NSUserDefaults *testDefaults = [[NSUserDefaults alloc] initWithSuiteName:kSettingTestSuiteName];
    [testDefaults setNotificationSetting:FALSE forGroupWithID:self.group1.groupID];
    [testDefaults setNotificationSetting:TRUE forGroupWithID:self.group2.groupID];
    XCTAssertTrue([testDefaults notificationSettingForGroupWithID:self.group2.groupID]);
}

@end
