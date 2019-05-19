//
//  TravelTimeView.m
//  SF iOS
//
//  Created by Amit Jain on 8/3/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import "TravelTimeView.h"

#import "Style.h"
#import "UIColor+SFiOSColors.h"
#import "UIStackView+ConvenienceInitializer.h"

@interface TravelTimeView ()

@property (nonatomic) UIImageView *iconView;
@property (nonatomic) UILabel *timeLabel;
@property (nonatomic) TransportType transportType;
@property (nonatomic, copy) DirectionsRequestHandler directionsRequestHandler;

@end

@implementation TravelTimeView

- (instancetype)initWithTravelTime:(TravelTime *)travelTime arrival:(Arrival)arrival directionsRequestHandler:(DirectionsRequestHandler)directionsRequestHandler {
    if (self = [super initWithFrame:CGRectZero]) {
        [self setup];
		_iconView.image = [travelTime.icon imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        _transportType = travelTime.transportType;
        _directionsRequestHandler = directionsRequestHandler;
        
        _timeLabel.text = travelTime.travelTimeEstimateString;
        switch (arrival) {
            case ArrivalOnTime:
                _timeLabel.textColor = [UIColor atlantis];
                break;
            
            case ArrivalDuringEvent:
                _timeLabel.textColor = [UIColor saffron];
                break;
                
            case ArrivalAfterEvent:
                _timeLabel.textColor = [UIColor mandy];
                break;
                
            default:
                break;
        }
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    NSAssert(false, @"Use initWithTravelTime:");
    return [self initWithTravelTime:[TravelTime new] arrival:ArrivalOnTime directionsRequestHandler:^(TransportType transportType) {}];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    NSAssert(false, @"Use initWithTravelTime:");
    return [self initWithTravelTime:[TravelTime new] arrival:ArrivalOnTime directionsRequestHandler:^(TransportType transportType) {}];
}

- (void)setup {
    self.layer.cornerRadius = 8;
    self.layer.shadowOpacity = 0.35;
    self.layer.shadowOffset = CGSizeMake(0, 2);
    self.layer.shadowRadius = 8;
    self.clipsToBounds = false;
    
    self.timeLabel = [UILabel new];
    self.timeLabel.textColor = [UIColor atlantis];
    self.timeLabel.numberOfLines = 1;
    self.timeLabel.userInteractionEnabled = false;
    
    self.iconView = [UIImageView new];
    self.iconView.contentMode = UIViewContentModeScaleAspectFit;
    [self.iconView setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    
    UIStackView *contentStack = [[UIStackView alloc] initWithArrangedSubviews:@[self.iconView, self.timeLabel]
                                                                         axis:UILayoutConstraintAxisHorizontal
                                                                 distribution:UIStackViewDistributionFill
                                                                    alignment:UIStackViewAlignmentFill
                                                                      spacing:10
                                                                      margins:UIEdgeInsetsMake(10, 10, 10, 10)];
    contentStack.userInteractionEnabled = false;
    contentStack.translatesAutoresizingMaskIntoConstraints = false;
    [contentStack setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [self addSubview:contentStack];
    [NSLayoutConstraint activateConstraints:
     @[
       [contentStack.leftAnchor constraintEqualToAnchor:self.leftAnchor],
       [contentStack.rightAnchor constraintEqualToAnchor:self.rightAnchor],
       [contentStack.topAnchor constraintEqualToAnchor:self.topAnchor],
       [contentStack.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
       [contentStack.heightAnchor constraintEqualToConstant:36]
       ]
     ];
    
    [self addTarget:self action:@selector(requestDirections) forControlEvents:UIControlEventTouchUpInside];
}

//MARK: - Touch Handling

- (void)requestDirections {
    if (self.directionsRequestHandler) {
        self.directionsRequestHandler(self.transportType);
    }
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    CGAffineTransform transform = highlighted ? CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1) : CGAffineTransformIdentity;
    [UIView animateWithDuration:0.15 animations:^{
        self.transform = transform;
    }];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
	[super setBackgroundColor:backgroundColor];
}

- (void)applyStyle:(id<Style>)style {
	self.backgroundColor = style.colors.backgroundColor;
	self.timeLabel.font = style.fonts.subtitleFont;
	self.iconView.tintColor = style.colors.tintColor;
	self.layer.shadowColor = style.colors.shadowColor.CGColor;
	self.layer.borderColor = style.colors.tintColor.CGColor;
	self.layer.borderWidth = 1.0 / UIScreen.mainScreen.scale;
}

@end
