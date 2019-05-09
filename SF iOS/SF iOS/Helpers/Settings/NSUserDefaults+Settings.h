//
//  NSUserDefaults+Settings.h
//  SF iOS
//
//  Created by Zachary Drayer on 4/8/19.
//

#import <Foundation/Foundation.h>
@class Group;

typedef NS_ENUM(NSInteger, SettingsDirectionProvider) {
    SettingsDirectionProviderApple,
    SettingsDirectionProviderGoogle
};

@interface NSUserDefaults (Settings)

@property (nonatomic, assign, readwrite) SettingsDirectionProvider directionsProvider;

- (void)setNotificationSetting:(BOOL)isOn forGroup:(nonnull Group *)group;

/**
 * Returns the group specific push notifications setting
 * @return BOOL true indicating that the user wants to receive pushes for this group, false otherwise
 */
- (BOOL)notificationSettingForGroup:(nonnull Group *)group;

- (NSDictionary *_Nullable)notificationSettings;

- (NSString *_Nullable)lastViewedGroupID;
- (void)setLastViewedGroupID:(NSString *_Nullable)groupID;
@end
