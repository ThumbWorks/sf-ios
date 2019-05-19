//
//  Style.h
//  Coffup
//
//  Created by Zachary Drayer on 4/21/19.
//

@import Foundation;
@import UIKit;

NS_ASSUME_NONNULL_BEGIN


@protocol Colors

@property (nonatomic, readonly) UIColor *backgroundColor;
@property (nonatomic, readonly) UIColor *tintColor;
@property (nonatomic, readonly) UIColor *loadingColor;
@property (nonatomic, readonly) UIColor *shadowColor;

@property (nonatomic, readonly) UIColor *primaryTextColor; // title text
@property (nonatomic, readonly) UIColor *secondaryTextColor; // subtitle text
@property (nonatomic, readonly) UIColor *inactiveTextColor; // disabled state text

@end

@protocol Fonts

@property (nonatomic, readonly) UIFont *headerFont;
@property (nonatomic, readonly) UIFont *primaryFont;
@property (nonatomic, readonly) UIFont *secondaryFont;
@property (nonatomic, readonly) UIFont *subtitleFont;

@end

@protocol Style <NSObject>

@property (class, nonatomic, readonly) NSString *identifier;

@property (nonatomic, readonly) id<Colors> colors;
@property (nonatomic, readonly) id<Fonts> fonts;

@end

NS_ASSUME_NONNULL_END
