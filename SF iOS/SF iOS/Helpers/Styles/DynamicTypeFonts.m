//
//  DynamicTypeFonts.m
//  Coffup
//
//  Created by Zachary Drayer on 5/21/19.
//

#import "DynamicTypeFonts.h"

@implementation DynamicTypeFonts

@synthesize headerFont = _headerFont;
@synthesize primaryFont = _primaryFont;
@synthesize secondaryFont = _secondaryFont;
@synthesize subtitleFont = _subtitleFont;

- (instancetype)init {
	self = [super init];

	{
		UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleLargeTitle compatibleWithTraitCollection:UIApplication.sharedApplication.keyWindow.traitCollection];
		UIFontDescriptor *descriptor = [font.fontDescriptor fontDescriptorByAddingAttributes:@{ UIFontDescriptorTraitsAttribute: @{ UIFontWeightTrait: @(UIFontWeightBold) } }];
		_headerFont = [UIFont fontWithDescriptor:descriptor size:font.pointSize];
	}

	{
		UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleTitle1 compatibleWithTraitCollection:UIApplication.sharedApplication.keyWindow.traitCollection];
		UIFontDescriptor *descriptor = [font.fontDescriptor fontDescriptorByAddingAttributes:@{ UIFontDescriptorTraitsAttribute: @{ UIFontWeightTrait: @(UIFontWeightSemibold) } }];
		_primaryFont = [UIFont fontWithDescriptor:descriptor size:font.pointSize];
	}

	{
		UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleTitle1 compatibleWithTraitCollection:UIApplication.sharedApplication.keyWindow.traitCollection];
		UIFontDescriptor *descriptor = [font.fontDescriptor fontDescriptorByAddingAttributes:@{ UIFontDescriptorTraitsAttribute: @{ UIFontWeightTrait: @(UIFontWeightRegular) } }];
		_secondaryFont = [UIFont fontWithDescriptor:descriptor size:font.pointSize];
	}

	{
		UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleCallout compatibleWithTraitCollection:UIApplication.sharedApplication.keyWindow.traitCollection];
		UIFontDescriptor *descriptor = [font.fontDescriptor fontDescriptorByAddingAttributes:@{ UIFontDescriptorTraitsAttribute: @{ UIFontWeightTrait: @(UIFontWeightThin) } }];
		_subtitleFont = [UIFont fontWithDescriptor:descriptor size:font.pointSize];
	}

	return self;
}

@end
