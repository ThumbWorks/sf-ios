//
//  TravelTimesView.m
//  SF iOS
//
//  Created by Amit Jain on 8/3/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import "TravelTimesView.h"
#import "TravelTimeView.h"
#import "UIStackView+ConvenienceInitializer.h"

typedef NS_ENUM(NSUInteger, TravelTimeType) {
    TravelTimeTypeRegular = 0,
    TravelTimeTypeRideSharing = 1
};

@interface TravelTimesView ()

@property (nonatomic) UIStackView *regularStack;
@property (nonatomic) UIStackView *ridesharingStack;
@property (nonatomic) UIActivityIndicatorView *loadingIndicator;
@property (copy, nonatomic) DirectionsRequestHandler directionsRequestHandler;

@end

@implementation TravelTimesView

- (instancetype)initWithDirectionsRequestHandler:(DirectionsRequestHandler)directionsRequestHandler {
    if (self = [super initWithFrame:CGRectZero]) {
        self.directionsRequestHandler = directionsRequestHandler;
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    NSAssert(false, @"use initWithDirectionsRequestHandler:");
    return [self initWithDirectionsRequestHandler:^(TransportType transportType) {}];
}

- (instancetype)initWithFrame:(CGRect)frame {
    NSAssert(false, @"use initWithDirectionsRequestHandler:");
    return [self initWithDirectionsRequestHandler:^(TransportType transportType) {}];
}

- (void)setLoading:(BOOL)loading {
    _loading = loading;
    loading ? [self.loadingIndicator startAnimating] : [self.loadingIndicator stopAnimating];
}

- (void)configureWithTravelTimes:(NSArray<TravelTime *> *)travelTimes eventStartDate:(NSDate *)startDate endDate:(NSDate *)endDate {
    [self.loadingIndicator stopAnimating];
    
    [self.regularStack removeAllArrangedSubviews];
    [self.ridesharingStack removeAllArrangedSubviews];
    
    NSDictionary *categorizedTravelTimes = [self categorizedTravelTimesFromArray:travelTimes];
    NSArray *regularTimes = categorizedTravelTimes[@(TravelTimeTypeRegular)];
    if (regularTimes) {
        [self populateTravelTimeViewsInStack:self.regularStack withTimes:regularTimes startDate:startDate endDate:endDate];
    }
    
    NSArray *rideSharingTimes = categorizedTravelTimes[@(TravelTimeTypeRideSharing)];
    if (rideSharingTimes) {
        [self populateTravelTimeViewsInStack:self.ridesharingStack withTimes:rideSharingTimes startDate:startDate endDate:endDate];
    }
    
    [self animateInTravelTimeViews];
}

- (void)setup {
    self.backgroundColor = [UIColor whiteColor];
    self.clipsToBounds = false;
    
    self.axis = UILayoutConstraintAxisVertical;
    self.distribution = UIStackViewDistributionEqualSpacing;
    self.alignment = UIStackViewAlignmentLeading;
    self.spacing = 16;
    self.layoutMargins = UIEdgeInsetsZero;
    self.layoutMarginsRelativeArrangement = true;
    
    self.regularStack = [self timesStackView];
    [self addArrangedSubview:self.regularStack];
    self.ridesharingStack = [self timesStackView];
    [self addArrangedSubview:self.ridesharingStack];
    
    self.loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.loadingIndicator.hidesWhenStopped = true;
    self.loadingIndicator.translatesAutoresizingMaskIntoConstraints = false;
    [self addSubview:self.loadingIndicator];

    [NSLayoutConstraint activateConstraints:
     @[
       [self.loadingIndicator.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
       [self.loadingIndicator.centerYAnchor constraintEqualToAnchor:self.centerYAnchor]
       ]
     ];
}

- (void)populateTravelTimeViewsInStack:(nonnull UIStackView *)stack withTimes:(nonnull NSArray *)travelTimes startDate:(NSDate *)startDate endDate:(NSDate *)endDate {
    for (TravelTime *time in travelTimes) {
        Arrival arrival = [time arrivalToEventWithStartDate:startDate endDate:endDate];
        TravelTimeView *view = [[TravelTimeView alloc] initWithTravelTime:time arrival:arrival directionsRequestHandler:self.directionsRequestHandler];
        [stack addArrangedSubview:view];
    }
}

- (UIStackView *)timesStackView {
    return [[UIStackView alloc] initWithArrangedSubviews:@[] axis:UILayoutConstraintAxisHorizontal
                                            distribution:UIStackViewDistributionEqualSpacing
                                               alignment:UIStackViewAlignmentLeading
                                                 spacing:16
                                                 margins:UIEdgeInsetsZero];
}

- (void)animateInTravelTimeViews {
    if (self.regularStack.arrangedSubviews.count == 0 && self.ridesharingStack.arrangedSubviews.count == 0) {
        return;
    }
    
    NSTimeInterval stagger = 0.1;
    CGAffineTransform transform = CGAffineTransformTranslate(CGAffineTransformIdentity, [[UIScreen mainScreen] bounds].size.width, 0);
    
    NSArray<UIView *> *views = [self.regularStack.arrangedSubviews arrayByAddingObjectsFromArray:self.ridesharingStack.arrangedSubviews];
    [views enumerateObjectsUsingBlock:^(UIView * _Nonnull view, NSUInteger idx, BOOL * _Nonnull stop) {
        view.transform = transform;
        view.alpha = 0;
        [UIView
         animateWithDuration:0.3
         delay:stagger * (idx + 1)
         usingSpringWithDamping:0.85
         initialSpringVelocity:0
         options:0
         animations:^{
             view.alpha = 1;
             view.transform = CGAffineTransformIdentity;
         }
         completion:nil];
    }];
}

// MARK: - Binning

- (NSDictionary *)categorizedTravelTimesFromArray:(NSArray<TravelTime *> *)array {
    NSMutableArray *regular = [NSMutableArray new];
    NSMutableArray *ridesharing = [NSMutableArray new];
    
    for (TravelTime *time in array) {
        switch (time.transportType) {
            case TransportTypeUber:
                [ridesharing addObject: time];
                break;
            case TransportTypeLyft:
                [ridesharing addObject: time];
                break;
            case TransportTypeWalking:
                [regular addObject: time];
                break;
            case TransportTypeAutomobile:
                [regular addObject: time];
                break;
            case TransportTypeTransit:
                [regular addObject: time];
                break;
            default:
                break;
        }
    }
    
    return @{@(TravelTimeTypeRegular) : regular, @(TravelTimeTypeRideSharing) : ridesharing};
}

@end
