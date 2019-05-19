//
//  MapView.m
//  SF iOS
//
//  Created by Amit Jain on 7/31/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import "MapView.h"
#import "MKMapCamera+OverlookingLocations.h"

static NSString * const destAnnotationIdentifier = @"destinationAnnotationidentifier";

@interface MapView ()

@property (nonatomic) MKMapView *mapView;
@property (nullable, nonatomic) MKPointAnnotation *destinationAnnotation;
@property (nullable, nonatomic) UIImage *annotationGlyph;
@property (nullable, nonatomic) CLLocation *destination;
@property (nullable, nonatomic) CLLocation *userLocation;
@property (nonatomic, assign) BOOL cameraHasBeenSet;

@end

@implementation MapView

- (instancetype)init {
    if (self = [super initWithFrame:CGRectZero]) {
        [self setup];
    }
    return self;
}

- (void)setDestinationToLocation:(CLLocation *)destination withAnnotationGlyph:(nonnull UIImage *)annotationGlyph {
    self.destination = destination;
    self.annotationGlyph = annotationGlyph;
    
    [self updateDestinationAnnotation];
}

- (void)setup {
    self.mapView = [MKMapView new];
    self.mapView.delegate = self;
    self.mapView.mapType = MKMapTypeMutedStandard;
    self.mapView.showsTraffic = true;
    self.mapView.showsUserLocation = true;
    [self.mapView registerClass:[MKMarkerAnnotationView class] forAnnotationViewWithReuseIdentifier:destAnnotationIdentifier];
    
    self.mapView.translatesAutoresizingMaskIntoConstraints = false;
    [self addSubview:self.mapView];

    [NSLayoutConstraint activateConstraints:
     @[
       [self.mapView.leftAnchor constraintEqualToAnchor:self.leftAnchor],
       [self.mapView.rightAnchor constraintEqualToAnchor:self.rightAnchor],
       [self.mapView.topAnchor constraintEqualToAnchor:self.topAnchor],
       [self.mapView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]
       ]
     ];

    self.mapView.showsCompass = false;
    [self setCameraOnSanFrancisco];
}

//MARK: - Annotations

- (void)updateDestinationAnnotation {
    [self.mapView removeAnnotation:self.destinationAnnotation];
    self.destinationAnnotation = [MKPointAnnotation new];
    self.destinationAnnotation.coordinate = self.destination.coordinate;
    [self.mapView addAnnotation:self.destinationAnnotation];
    
    [self setCameraOverlookingDestinationAndUserLocation];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    MKMarkerAnnotationView *marker = (MKMarkerAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:destAnnotationIdentifier];
    if (!marker) {
        marker = [[MKMarkerAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:destAnnotationIdentifier];
    }
    marker.displayPriority = MKFeatureDisplayPriorityRequired;
    marker.glyphImage = self.annotationGlyph;
    marker.glyphTintColor = [UIColor blackColor];
    marker.markerTintColor = [UIColor whiteColor];
    
    return marker;
}

//MARK: - UserLocation

- (void)setUserLocation:(CLLocation *)userLocation {
    if ([self location:userLocation isSameAsLocation:_userLocation]) {
        return;
    }
    
    _userLocation = userLocation;
    if (self.userLocationObserver) {
        self.userLocationObserver(userLocation);
    }
    
    if (self.cameraHasBeenSet) { return; }
    if (!userLocation) {
        [self setCameraOnDestination];
    } else {
        [self setCameraOverlookingDestinationAndUserLocation];
    }
    self.cameraHasBeenSet = true;
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    self.userLocation = userLocation.location;
}

- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error {
    NSLog(@"Failed to locate user in MapView: %@", error);
    self.userLocation = nil;
}

//MARK: - Camera

- (void)setCameraOverlookingDestinationAndUserLocation {
    if (!self.userLocation) {
        [self setCameraOnDestination];
        return;
    } else if (!self.destination) {
        return;
    }

    MKMapCamera *camera = [MKMapCamera cameraOverlookingLocation1:self.userLocation location2:self.destination withPadding:0.8];
    [self.mapView setCamera:camera animated:true];
}

- (void)setCameraOnDestination {
    if (!self.destination) {
        return;
    }
    
    MKMapCamera *camera = [MKMapCamera cameraLookingAtCenterCoordinate:self.destination.coordinate fromDistance:6000 pitch:0 heading:0];
    [self.mapView setCamera:camera animated:true];
}

- (void)setCameraOnSanFrancisco {
    CLLocationCoordinate2D sanFrancisco = CLLocationCoordinate2DMake(37.749576, -122.442606);
    MKMapCamera *camera = [MKMapCamera cameraLookingAtCenterCoordinate:sanFrancisco fromDistance:10000 pitch:0 heading:0];
    [self.mapView setCamera:camera animated:false];
}

//MARK: - Location Comparison

- (BOOL)location:(CLLocation *)lhs isSameAsLocation:(CLLocation *)rhs {
    return lhs.coordinate.latitude == rhs.coordinate.latitude && lhs.coordinate.longitude == rhs.coordinate.longitude;
}

@end
