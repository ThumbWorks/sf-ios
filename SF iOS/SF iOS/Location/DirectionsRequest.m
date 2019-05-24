//
//  DirectionsRequest.m
//  SF iOS
//
//  Created by Amit Jain on 8/5/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import "DirectionsRequest.h"
#import "Location.h"
#import "SecretsStore.h"
#import "NSUserDefaults+Settings.h"
@import MapKit;


static NSString *const DirectionsRequestGoogleMapsDirectionsModeFromMKLaunchOptionsDirectionsMode(NSString *const directionsMode) {
    // gmaps constants from https://developers.google.com/maps/documentation/urls/ios-urlscheme
    if ([directionsMode isEqualToString:MKLaunchOptionsDirectionsModeDriving]) {
        return @"driving";
    }

    if ([directionsMode isEqualToString:MKLaunchOptionsDirectionsModeWalking]) {
        return @"walking";
    }

    if ([directionsMode isEqualToString:MKLaunchOptionsDirectionsModeTransit]) {
        return @"transit";
    }

    return @"";
};


@implementation DirectionsRequest

+ (void)requestDirectionsToLocation:(Location *)location withName:(NSString *)name usingTransportType:(TransportType)transportType completion:(void (^)(BOOL success))completion {
    switch (transportType) {
        case TransportTypeTransit:
            [self requestDirectionsToLocation:location withName:name usingMode:MKLaunchOptionsDirectionsModeTransit completion:completion];
            break;
            
        case TransportTypeAutomobile:
            [self requestDirectionsToLocation:location withName:name usingMode:MKLaunchOptionsDirectionsModeDriving completion:completion];
            break;
            
        case TransportTypeWalking:
            [self requestDirectionsToLocation:location withName:name usingMode:MKLaunchOptionsDirectionsModeWalking completion:completion];
            break;
            
        case TransportTypeUber:
            [self requestUberRideToLocation:location withName:name];
            break;
            
        case TransportTypeLyft:
            [self requestLyftRideToLocation:location];
            break;
            
        default:
            break;
    }
}

+ (void)requestDirectionsToLocation:(Location *)location withName:(NSString *)name usingMode:(NSString *)mode completion:(void (^)(BOOL success))completion {
    switch (NSUserDefaults.standardUserDefaults.directionsProvider) {
        case SettingsDirectionProviderApple:
            [self requestAppleMapsDirectionsToLocation:location withName:name usingMode:mode completion:completion];
            break;
        case SettingsDirectionProviderGoogle:
            [self requestGoogleMapsDirectionsToLocation:location withName:name usingMode:mode completion:completion];
            break;
    }
}

+ (void)requestAppleMapsDirectionsToLocation:(Location *)location withName:(NSString *)name usingMode:(NSString *)mode completion:(void (^)(BOOL success))completion {
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:location.location.coordinate];
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    mapItem.name = name;
    completion([mapItem openInMapsWithLaunchOptions:@{MKLaunchOptionsDirectionsModeKey : mode}]);

}

+ (void)requestGoogleMapsDirectionsToLocation:(Location *)location withName:(NSString *)name usingMode:(NSString *)mode completion:(void (^)(BOOL success))completion {
    NSURLComponents *components = [[NSURLComponents alloc] init];
    components.scheme = @"comgooglemapsurl";
    components.queryItems = @[
        [NSURLQueryItem queryItemWithName:@"directionsmode" value:DirectionsRequestGoogleMapsDirectionsModeFromMKLaunchOptionsDirectionsMode(mode)],
        [NSURLQueryItem queryItemWithName:@"daddr" value:[NSString stringWithFormat:@"%@ %@", name, location.streetAddress]],
        [NSURLQueryItem queryItemWithName:@"center" value:[NSString stringWithFormat:@"%.4f,%.4f", location.location.coordinate.latitude, location.location.coordinate.longitude]]
    ];

    [[UIApplication sharedApplication] openURL:components.URL options:@{} completionHandler:completion];
}

+ (void)requestUberRideToLocation:(Location *)location withName:(NSString *)name {
    SecretsStore *store = [[SecretsStore alloc] init];
    NSString *clientID = store.uberClientID;
    NSString *escapedName = [name stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
    
    // https://stackoverflow.com/questions/26049950/uber-deeplinking-on-ios
    NSString *query = [NSString stringWithFormat:@"?client_id=%@&action=setPickup&pickup=my_location&dropoff[latitude]=%f&dropoff[longitude]=%f&dropoff[nickname]=%@", clientID, location.location.coordinate.latitude, location.location.coordinate.longitude, escapedName];
    
    [self requestRideWithURLScheme:@"uber://" httpHost:@"https://m.uber.com/ul/" queryFragment:query];
}

+ (void)requestLyftRideToLocation:(Location *)location {
    SecretsStore *store = [[SecretsStore alloc] init];
    NSString *clientID = store.lyftClientID;
    
    NSString *query = [NSString stringWithFormat:@"?id=lyft&partner=%@&destination[latitude]=%f&destination[longitude]=%f", clientID, location.location.coordinate.latitude, location.location.coordinate.longitude];
    
    [self requestRideWithURLScheme:@"lyft://ridetype" httpHost:@"https://www.lyft.com/ride" queryFragment:query];
}

+ (void)requestRideWithURLScheme:(NSString *)urlScheme httpHost:(NSString *)httpHost queryFragment:(NSString *)query {
    NSString *path;
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlScheme]]) {
        path = [NSString stringWithFormat:@"%@%@", urlScheme, query];
    } else {
        path = [NSString stringWithFormat:@"%@%@", httpHost, query];
    }
    
    NSURL *url = [NSURL URLWithString:path];
    NSAssert(url != nil, @"Failed to construct URL from path: %@", path);
    
    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
}

@end

