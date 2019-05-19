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
#import "Location.h"
@import MapKit;


NS_ASSUME_NONNULL_BEGIN
@interface EventDetailsViewController ()

@property (nonatomic) Event *event;
@property (nonatomic) NSString *groupName;
@property (nonatomic) MapView *mapView;
@property (nonatomic) UIStackView *containerStack;
@property (nonatomic) TravelTimeService *travelTimeService;
@property (nonatomic) TravelTimesView *travelTimesView;
@property (nullable, nonatomic) UserLocation *userLocationService;

@end
NS_ASSUME_NONNULL_END

@implementation EventDetailsViewController

- (instancetype)initWithEvent:(Event *)event groupName:(nullable NSString *)groupName userLocationService:(nullable UserLocation *)userLocation {
    if (self = [super initWithNibName:nil bundle:nil]) {
        self.event = event;
        self.groupName = groupName;
        self.travelTimeService = [TravelTimeService new];
        self.userLocationService = userLocation;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    NSAssert(false, @"Use -initWithEvent");
    return [self initWithEvent:[Event new] groupName:nil userLocationService:[UserLocation new]];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    NSAssert(false, @"Use -initWithEvent");
    return [self initWithEvent:[Event new] groupName:nil userLocationService:[UserLocation new]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
    self.view.backgroundColor = [UIColor whiteColor];
    self.extendedLayoutIncludesOpaqueBars = true;
    
    // Show Share button for events in the future.
    if(self.event.date.isInFuture){
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                                           target:self
                                                                                           action:@selector(share)];
    }
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = self.event.name;
    titleLabel.font = [UIFont systemFontOfSize:28 weight:UIFontWeightSemibold];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.numberOfLines = 0;

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
    
    self.containerStack = [[UIStackView alloc] initWithArrangedSubviews:@[self.mapView, titleStack, self.travelTimesView]
                                                                   axis:UILayoutConstraintAxisVertical
                                                           distribution:UIStackViewDistributionFill
                                                              alignment:UIStackViewAlignmentFill
                                                                spacing:0
                                                                margins:UIEdgeInsetsZero];
    self.containerStack.translatesAutoresizingMaskIntoConstraints = false;
    
    [self.view addSubview:self.containerStack];
    // Extend under status bar
    [NSLayoutConstraint activateConstraints:
     @[
       [self.travelTimesView.heightAnchor constraintGreaterThanOrEqualToConstant:141],

       [self.containerStack.topAnchor constraintEqualToAnchor:self.view.topAnchor],
       [self.containerStack.leftAnchor constraintEqualToAnchor:self.view.leftAnchor],
       [self.containerStack.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
       [self.containerStack.rightAnchor constraintEqualToAnchor:self.view.rightAnchor]
       ]
     ];
            
    [self.mapView setDestinationToLocation:self.event.location.location withAnnotationGlyph:self.event.annotationGlyph];
    [self getTravelTimes];
}

- (NSArray<id<UIPreviewActionItem>> *)previewActionItems {
    NSString *copyActionTitle = NSLocalizedString(@"Copy Address", @"");
    UIPreviewAction *copyAction = [UIPreviewAction actionWithTitle:copyActionTitle
                                                             style:UIPreviewActionStyleDefault
                                                           handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
                                                               NSString *addressString = self.event.location.streetAddress;
                                                               [[UIPasteboard generalPasteboard] setString:addressString];
                                                           }];
    return @[copyAction];
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

// MARK: Share

- (void)share {
    // TODO: Use coffeecoffeecoffee.coffee url.
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDoesRelativeDateFormatting:YES];
    
    NSString *text = [NSString stringWithFormat:NSLocalizedString(@"Join us at %@ for %@, kicking off %@.", @"Join us at %@ for %@, kicking off %@."), self.event.venueName, self.groupName, [formatter stringFromDate:self.event.date]];
    NSArray *items = @[text, self.event.venueURL];
    UIActivityViewController *shareSheet = [[UIActivityViewController alloc] initWithActivityItems:items
                                                                             applicationActivities:nil];
    [self presentViewController:shareSheet animated:true completion:nil];
}

@end

