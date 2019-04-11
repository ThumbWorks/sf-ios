//
//  NSUserDefaults+Settings.h
//  SF iOS
//
//  Created by Zachary Drayer on 4/8/19.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SettingsDirectionProvider) {
    SettingsDirectionProviderApple,
    SettingsDirectionProviderGoogle
};

@interface NSUserDefaults (Settings)

@property (nonatomic, assign, readwrite) SettingsDirectionProvider directionsProvider;

@end
