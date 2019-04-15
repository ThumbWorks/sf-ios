//
//  EventDetailsViewController.m
//  SF iOS
//
//  Created by Amit Jain on 8/2/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import "EventDetailsViewController.h"
#import "UIStackView+ConvenienceInitializer.h"
#import "UIColor+SFiOSColors.h"
#import "NSAttributedString+EventDetails.h"
#import "NSDate+Utilities.h"
#import "MapView.h"
#import "TravelTimeService.h"
#import "TravelTimesView.h"
#import "DirectionsRequest.h"
#import "UIViewController+StatusBarBackground.h"
#import "Location.h"
@import MapKit;


NS_ASSUME_NONNULL_BEGIN
@interface EventDetailsViewController ()

@property (nonatomic) Event *event;
@property (nonatomic) MapView *mapView;
@property (nonatomic) UIStackView *containerStack;
@property (nonatomic) TravelTimeService *travelTimeService;
@property (nonatomic) TravelTimesView *travelTimesView;
@property (nullable, nonatomic) UserLocation *userLocationService;

@end
NS_ASSUME_NONNULL_END

@implementation EventDetailsViewController

- (instancetype)initWithEvent:(Event *)event userLocationService:(UserLocation *)userLocation {
    if (self = [super initWithNibName:nil bundle:nil]) {
        self.event = event;
        self.travelTimeService = [TravelTimeService new];
        self.userLocationService = userLocation;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    NSAssert(false, @"Use -initWithEvent");
    return [self initWithEvent:[Event new] userLocationService:[UserLocation new]];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    NSAssert(false, @"Use -initWithEvent");
    return [self initWithEvent:[Event new] userLocationService:[UserLocation new]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.extendedLayoutIncludesOpaqueBars = true;
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = self.event.name;
    titleLabel.font = [UIFont systemFontOfSize:28 weight:UIFontWeightSemibold];
    titleLabel.textColor = [UIColor blackColor];
    
    UILabel *subtitleLabel = [UILabel new];
    subtitleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightSemibold];
    subtitleLabel.textColor = [UIColor abbey];
    subtitleLabel.attributedText = [NSAttributedString attributedDetailsStringFromEvent:self.event];
    subtitleLabel.numberOfLines = 2;
    UIStackView *titleStack = [[UIStackView alloc] initWithArrangedSubviews:@[titleLabel, subtitleLabel]
                                                                       axis:UILayoutConstraintAxisVertical
                                                               distribution:UIStackViewDistributionEqualSpacing
                                                                  alignment:UIStackViewAlignmentFill
                                                                    spacing:9
                                                                    margins:UIEdgeInsetsMake(18, 21, 0, 21)];
    [titleStack setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
    
    self.mapView = [[MapView alloc] init];
    [self.mapView setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisVertical];

    self.travelTimesView = [[TravelTimesView alloc]
                            initWithDirectionsRequestHandler:^(TransportType transportType) {
                                [DirectionsRequest requestDirectionsToLocation:self.event.location.location
                                                                      withName:self.event.venueName
                                                            usingTransportType:transportType
                                                                    completion:^(BOOL success) {
                                                                        if (!success) {
                                                                            // show error
                                                                        }
                                                                    }];
                            }];
    self.travelTimesView.layoutMargins = UIEdgeInsetsMake(32, 21, 21, 21);
    self.travelTimesView.translatesAutoresizingMaskIntoConstraints = false;
    [self.travelTimesView.heightAnchor constraintGreaterThanOrEqualToConstant:141].active = true;
    
    self.containerStack = [[UIStackView alloc] initWithArrangedSubviews:@[self.mapView, titleStack, self.travelTimesView]
                                                                   axis:UILayoutConstraintAxisVertical
                                                           distribution:UIStackViewDistributionFill
                                                              alignment:UIStackViewAlignmentFill
                                                                spacing:0
                                                                margins:UIEdgeInsetsZero];
    self.containerStack.translatesAutoresizingMaskIntoConstraints = false;
    
    [self.view addSubview:self.containerStack];
    // Extend under status bar
    [self.containerStack.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:-self.statusBarHeight].active = true;
    [self.containerStack.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = true;
    [self.containerStack.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = true;
    [self.containerStack.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = true;
    
    UIButton *closeButton = [UIButton new];
    [closeButton setImage:[UIImage imageNamed:@"close-button"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    closeButton.translatesAutoresizingMaskIntoConstraints = false;
    [self.view addSubview:closeButton];
    [closeButton.widthAnchor constraintEqualToConstant:44].active = true;
    [closeButton.heightAnchor constraintEqualToConstant:44].active = true;
    [closeButton.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:8].active = true;
    [closeButton.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-12].active = true;
    
    [self addStatusBarBlurBackground];
    
    [self.mapView setDestinationToLocation:self.event.location.location withAnnotationImage:self.event.annotationImage];
    [self getTravelTimes];
}

// MARK: - Travel Times

- (void)getTravelTimes {
    if (!self.userLocationService) {
        return;
    }
    
    self.travelTimesView.loading = true;
    
    __weak typeof(self) welf = self;
    [self.userLocationService requestWithCompletionHandler:^(CLLocation * _Nullable currentLocation, NSError * _Nullable error) {
        if (!currentLocation || error) {
            NSLog(@"Could not get travel times: %@", error);
            self.travelTimesView.loading = false;
            return;
        }
        
        [welf.travelTimeService calculateTravelTimesFromLocation:currentLocation toLocation:welf.event.location.location withCompletionHandler:^(NSArray<TravelTime *> * _Nonnull travelTimes) {
            welf.travelTimesView.loading = false;
            
            if (travelTimes.count > 0) {
                [welf.travelTimesView configureWithTravelTimes:travelTimes eventStartDate:welf.event.date endDate:welf.event.endDate];
                [UIView animateWithDuration:0.3 animations:^{
                    [welf.mapView layoutIfNeeded];
                    [welf.containerStack layoutIfNeeded];
                }];
            }
        }];
    }];
}

// ---

- (void)dismiss {
    [self dismissViewControllerAnimated:true completion:nil];
}

@end

