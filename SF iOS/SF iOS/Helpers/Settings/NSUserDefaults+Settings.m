//
//  NSUserDefaults+Settings.m
//  SF iOS
//
//  Created by Zachary Drayer on 4/8/19.
//  Copyright © 2019 Amit Jain. All rights reserved.
//

#import "NSUserDefaults+Settings.h"

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

@end
