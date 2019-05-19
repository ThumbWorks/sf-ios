//
//  LightStyle.m
//  Coffup
//
//  Created by Zachary Drayer on 4/21/19.
//

#import <UIKit/UIKit.h>

#import "DynamicTypeFonts.h"
#import "MochaStyle.h"

@interface MochaStyleColors : NSObject <Colors>
@end

@implementation MochaStyleColors

- (UIColor *)backgroundColor {
	return [UIColor colorWithRed:38.0 / 255.0
						   green:38.0 / 255.0
							blue:38.0 / 255.0
						   alpha:1.0];
}

- (UIColor *)tintColor {
	return [UIColor colorWithRed:86.0 / 255.0
						   green:87.0 / 255.0
							blue:89.0 / 255.0
						   alpha:1.0];
}

- (UIColor *)loadingColor {
	return [self.backgroundColor colorWithAlphaComponent:0.5];
}

- (UIColor *)shadowColor {
	return [UIColor colorWithRed:136.0 / 255.0
						   green:137.0 / 255.0
							blue:141.0 / 255.0
						   alpha:1.0];
}

- (UIColor *)primaryTextColor {
	return [UIColor colorWithRed:160.0 / 255.0
						   green:70.0 / 255.0
							blue:71.0 / 255.0
						   alpha:1.0];
}

- (UIColor *)secondaryTextColor {
	return [UIColor colorWithRed:86.0 / 255.0
						   green:87.0 / 255.0
							blue:89.0 / 255.0
						   alpha:1.0];
}

- (UIColor *)inactiveTextColor {
	return [UIColor colorWithRed:136.0 / 255.0
						   green:137.0 / 255.0
							blue:140.0 / 255.0
						   alpha:1.0];
}

@end


@implementation MochaStyle

+ (NSString *)identifier {
	return NSStringFromClass(self.class);
}

@synthesize colors = _colors;
@synthesize fonts = _fonts;

- (instancetype)init {
	self = [super init];
	NSAssert(self != nil, @"[super init] should never fail");

	_colors = [[MochaStyleColors alloc] init];
	_fonts = [[DynamicTypeFonts alloc] init];

	return self;
}

@end
