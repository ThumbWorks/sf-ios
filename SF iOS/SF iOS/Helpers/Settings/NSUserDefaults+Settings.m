//
//  NSUserDefaults+Settings.m
//  SF iOS
//
//  Created by Zachary Drayer on 4/8/19.
//

#import "NSUserDefaults+Settings.h"
#import "Group.h"

@implementation NSUserDefaults (Settings)

- (NSString *)SFIOS_lastViewedGroupKey {
    return NSStringFromSelector(@selector(lastViewedGroupID));
}

- (NSString *)SFIOS_directionsProviderKey {
    return NSStringFromSelector(@selector(directionsProvider));
}

- (NSString *)SFIOS_notifiationsDictionaryKey {
    return NSStringFromSelector(@selector(notificationSettingForGroup:));
}

- (SettingsDirectionProvider)directionsProvider {
    return [self integerForKey:self.SFIOS_directionsProviderKey];
}

- (void)setDirectionsProvider:(SettingsDirectionProvider)directionsProvider {
    [self setInteger:directionsProvider forKey:self.SFIOS_directionsProviderKey];
}

- (void)setNotificationSetting:(BOOL)isOn forGroup:(nonnull Group *)group {
    NSNumber *newValue = [NSNumber numberWithBool:isOn];
    NSString *key = self.SFIOS_notifiationsDictionaryKey;
    NSString *groupID = group.groupID;
    NSMutableDictionary<NSString *, NSNumber *> *settingsDictionary = [[self dictionaryForKey:key] mutableCopy];
    if (settingsDictionary == nil) {
        settingsDictionary = [[NSMutableDictionary<NSString *, NSNumber *> alloc] initWithObjectsAndKeys:newValue,
                              groupID,
                              nil];
    } else {
        [settingsDictionary setObject:newValue forKey:groupID];
    }
    [self setObject:settingsDictionary forKey:key];
}

- (NSDictionary *)notificationSettings {
    return [self dictionaryForKey:self.SFIOS_notifiationsDictionaryKey];
}

- (BOOL)notificationSettingForGroup:(nonnull Group *)group {
    NSString *groupID =  group.groupID;
    NSDictionary *settingsDictionary = [self dictionaryForKey:self.SFIOS_notifiationsDictionaryKey];
    return [[settingsDictionary valueForKey:groupID] boolValue];
}

- (NSString *_Nullable)lastViewedGroupID {
    return [self valueForKey:self.SFIOS_lastViewedGroupKey];
}

- (void)setLastViewedGroupID:(NSString *_Nullable)groupID {
    [self setObject:groupID forKey:self.SFIOS_lastViewedGroupKey];
}
@end
