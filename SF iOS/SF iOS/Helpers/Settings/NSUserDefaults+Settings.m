//
//  NSUserDefaults+Settings.m
//  SF iOS
//
//  Created by Zachary Drayer on 4/8/19.
//

#import "NSUserDefaults+Settings.h"
#import "Group.h"

@implementation NSUserDefaults (Settings)

- (NSString *)SFIOS_directionsProviderKey {
    return NSStringFromSelector(@selector(directionsProvider));
}

- (SettingsDirectionProvider)directionsProvider {
    return [self integerForKey:self.SFIOS_directionsProviderKey];
}

- (void)setDirectionsProvider:(SettingsDirectionProvider)directionsProvider {
    [self setInteger:directionsProvider forKey:self.SFIOS_directionsProviderKey];
}

#pragma mark -

- (NSString *)SFIOS_notificationsDictionaryKey {
    return NSStringFromSelector(@selector(notificationSettingForGroup:));
}

- (void)setNotificationSetting:(BOOL)isOn forGroupWithID:(nonnull NSString *)groupID {
    NSNumber *newValue = [NSNumber numberWithBool:isOn];
    NSString *key = self.SFIOS_notificationsDictionaryKey;
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
    return [self dictionaryForKey:self.SFIOS_notificationsDictionaryKey];
}

- (BOOL)notificationSettingForGroupWithID:(nonnull NSString *)groupID {
    NSDictionary *settingsDictionary = [self dictionaryForKey:self.SFIOS_notificationsDictionaryKey];
    return [[settingsDictionary valueForKey:groupID] boolValue];
}

#pragma mark -

- (NSString *)SFIOS_lastViewedGroupKey {
    return NSStringFromSelector(@selector(lastViewedGroupID));
}

- (NSString *_Nullable)lastViewedGroupID {
    return [self objectForKey:self.SFIOS_lastViewedGroupKey];
}

- (void)setLastViewedGroupID:(NSString *_Nullable)groupID {
    [self setObject:groupID forKey:self.SFIOS_lastViewedGroupKey];
}

#pragma mark -

- (NSString *)SFIOS_activeStyleIdentifier {
	return NSStringFromSelector(@selector(SFIOS_activeStyleIdentifier));
}

- (NSString *)activeStyleIdentifier {
	return [self objectForKey:self.SFIOS_activeStyleIdentifier];
}

- (void)setActiveStyleIdentifier:(NSString *)activeStyleIdentifier {
	[self setObject:activeStyleIdentifier forKey:self.SFIOS_activeStyleIdentifier];
}

@end
