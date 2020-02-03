//
//  TravelTimeService.m
//  SF iOS
//
//  Created by Amit Jain on 8/3/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import "TravelTimeService.h"
#import "AsyncBlockOperation.h"
#import "UberTravelTimeEstimateOperation.h"
#import "LyftTravelTimeEstimateOperation.h"
@import MapKit;

@interface TravelTimeService ()

@property (nonatomic) NSOperationQueue *travelTimeCalculationQueue;

@end

@implementation TravelTimeService

- (instancetype)init {
    if (self = [super init]) {
        self.travelTimeCalculationQueue = [NSOperationQueue new];
    }
    return self;
}

- (void)calculateTravelTimesFromLocation:(CLLocation *)sourceLocation toLocation:(CLLocation *)destinationLocation withCompletionHandler:(TravelTimeCompletionHandler)completionHandler {
    [self.travelTimeCalculationQueue cancelAllOperations];
    
    __block NSMutableArray<TravelTime *> *travelTimes = [NSMutableArray new];
    
    MKDirectionsRequest *transitRequest = [self requestFromLocation:sourceLocation toLocation:destinationLocation usingTransporationType:MKDirectionsTransportTypeTransit];
    MKDirectionsRequest *walkingRequest = [self requestFromLocation:sourceLocation toLocation:destinationLocation usingTransporationType:MKDirectionsTransportTypeWalking];
    MKDirectionsRequest *drivingRequest = [self requestFromLocation:sourceLocation toLocation:destinationLocation usingTransporationType:MKDirectionsTransportTypeAutomobile];
    NSArray *requests = @[transitRequest, walkingRequest, drivingRequest];
    
    NSOperation *completionOperation = [NSBlockOperation blockOperationWithBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [travelTimes sortUsingComparator:^NSComparisonResult(TravelTime *_Nonnull obj1, TravelTime *_Nonnull obj2) {
                return obj1.travelTime > obj2.travelTime;
            }];
            completionHandler(travelTimes);
        });
    }];
    
    for (MKDirectionsRequest *request in requests) {
        AsyncOperation *travelTimeCalculation = [self travelTimeCalculationWithRequest:request completionHandler:^(TravelTime * _Nullable travelTime) {
            if (travelTime) {
                [travelTimes addObject:travelTime];
            }
        }];
        [completionOperation addDependency:travelTimeCalculation];
        [self.travelTimeCalculationQueue addOperation:travelTimeCalculation];
    }
    
    UberTravelTimeEstimateOperation *uberTimeCalculation = [[UberTravelTimeEstimateOperation alloc] initWithSourceLocation:sourceLocation destinationLocation:destinationLocation completionHandler:^(TravelTime * _Nullable travelTime, NSError * _Nullable error) {
        if (!travelTime) {
            NSLog(@"Could not retrieve uber travel time: %@", error);
            return;
        }
        [travelTimes addObject:travelTime];
    }];
    [completionOperation addDependency:uberTimeCalculation];
    [self.travelTimeCalculationQueue addOperation:uberTimeCalculation];

    // Temporarily remove Lyft since they changed their rules and regulations apparently. We need to get approved
//    LyftTravelTimeEstimateOperation *lyftTimeCalculation = [[LyftTravelTimeEstimateOperation alloc] initWithSourceLocation:sourceLocation destinationLocation:destinationLocation completionHandler:^(TravelTime * _Nullable travelTime, NSError * _Nullable error) {
//        if (!travelTime) {
//            NSLog(@"Could not retrieve lyft travel time: %@", error);
//            return;
//        }
//        [travelTimes addObject:travelTime];
//    }];
//    [completionOperation addDependency:lyftTimeCalculation];
//    [self.travelTimeCalculationQueue addOperation:lyftTimeCalculation];

    [self.travelTimeCalculationQueue addOperation:completionOperation];
}

- (MKDirectionsRequest *)requestFromLocation:(CLLocation *)sourceLocation toLocation:(CLLocation *)destinationLocation usingTransporationType:(MKDirectionsTransportType)transportationType {
    MKDirectionsRequest *request = [MKDirectionsRequest new];
    request.source = [[MKMapItem alloc] initWithPlacemark: [[MKPlacemark alloc] initWithCoordinate:sourceLocation.coordinate]];
    request.destination = [[MKMapItem alloc] initWithPlacemark: [[MKPlacemark alloc] initWithCoordinate:destinationLocation.coordinate]];
    request.requestsAlternateRoutes = false;
    request.transportType = transportationType;
    return request;
}

- (AsyncBlockOperation *)travelTimeCalculationWithRequest:(MKDirectionsRequest *)request completionHandler:(void(^)(TravelTime * _Nullable travelTime))resultHandler {
    return [[AsyncBlockOperation alloc] initWithAsyncBlock:^(dispatch_block_t  _Nonnull completionHandler) {
        MKDirections *direction = [[MKDirections alloc] initWithRequest:request];
        [direction calculateETAWithCompletionHandler:^(MKETAResponse * _Nullable response, NSError * _Nullable error) {
            NSTimeInterval travelTime;
            if (!response) {
                NSLog(@"Could not get travel time for request:\n%@\n%@", request, error);
                travelTime = -1;
            } else {
                travelTime = response.expectedTravelTime;
            }
            TravelTime *result = [[TravelTime alloc] initWithMKDirectionsTransportType:request.transportType travelTime:travelTime];
            resultHandler(result);
            completionHandler();
        }];
    }];
}

@end
