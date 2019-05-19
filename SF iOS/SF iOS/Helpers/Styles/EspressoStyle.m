//
//  LightStyle.m
//  Coffup
//
//  Created by Zachary Drayer on 4/21/19.
//

#import "EspressoStyle.h"
#import <UIKit/UIKit.h>

@interface EspressoStyleColors : NSObject <Colors>
@end

@implementation EspressoStyleColors

- (UIColor *)backgroundColor {
	return [UIColor colorWithRed:88.0 / 255.0
						   green:52.0 / 255.0
							blue:32.0 / 255.0
						   alpha:1.0];
}

- (UIColor *)tintColor {
	return [UIColor colorWithRed:88.0 / 255.0
						   green:52.0 / 255.0
							blue:32.0 / 255.0
						   alpha:1.0];
}

- (UIColor *)loadingColor {
	return [self.backgroundColor colorWithAlphaComponent:0.5];
}

- (UIColor *)shadowColor {
	return [UIColor colorWithRed:216.0 / 255.0
						   green:153.0 / 255.0
							blue:85.0 / 255.0
						   alpha:1.0];
}

- (UIColor *)primaryTextColor {
	return [UIColor colorWithRed:217.0 / 255.0
						   green:217.0 / 255.0
							blue:217.0 / 255.0
						   alpha:1.0];
}

- (UIColor *)secondaryTextColor {
	return [UIColor colorWithRed:216.0 / 255.0
						   green:153.0 / 255.0
							blue:85.0 / 255.0
						   alpha:1.0];
}

- (UIColor *)inactiveTextColor {
	return [UIColor colorWithRed:162.0 / 255.0
						   green:136.0 / 255.0
							blue:114.0 / 255.0
						   alpha:1.0];
}

@end

@interface EspressoStyleFonts : NSObject <Fonts>
@end

@implementation EspressoStyleFonts

- (UIFont *)headerFont {
	return [UIFont systemFontOfSize:34 weight:UIFontWeightBold];
}

- (UIFont *)primaryFont {
	return [UIFont systemFontOfSize:28 weight:UIFontWeightSemibold];;
}

- (UIFont *)secondaryFont {
	return [UIFont systemFontOfSize:28 weight:UIFontWeightRegular];;
}

- (UIFont *)subtitleFont {
	return [UIFont systemFontOfSize:13 weight:UIFontWeightSemibold];
}

@end

@implementation EspressoStyle

+ (NSString *)identifier {
	return NSStringFromClass(self.class);
}

@synthesize colors = _colors;
@synthesize fonts = _fonts;

- (instancetype)init {
	self = [super init];
	NSAssert(self != nil, @"[super init] should never fail");

	_colors = [[EspressoStyleColors alloc] init];
	_fonts = [[EspressoStyleFonts alloc] init];

	return self;
}

@end
