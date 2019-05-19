//
//  TravelTimeView.m
//  SF iOS
//
//  Created by Amit Jain on 8/3/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import "TravelTimeView.h"
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
        self.iconView.image = travelTime.icon;
        self.transportType = travelTime.transportType;
        self.directionsRequestHandler = directionsRequestHandler;
        
        self.timeLabel.text = travelTime.travelTimeEstimateString;
        switch (arrival) {
            case ArrivalOnTime:
                self.timeLabel.textColor = [UIColor atlantis];
                break;
            
            case ArrivalDuringEvent:
                self.timeLabel.textColor = [UIColor saffron];
                break;
                
            case ArrivalAfterEvent:
                self.timeLabel.textColor = [UIColor mandy];
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
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 8;
    self.layer.shadowColor = [UIColor nobel].CGColor;
    self.layer.shadowOpacity = 0.5;
    self.layer.shadowOffset = CGSizeMake(0, 2);
    self.layer.shadowRadius = 8;
    self.clipsToBounds = false;
    
    self.timeLabel = [UILabel new];
    self.timeLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
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
    
    [self addTarget:self action:@selector(requestdirections) forControlEvents:UIControlEventTouchUpInside];
}

//MARK: - Touch Handling

- (void)requestdirections {
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

@end
