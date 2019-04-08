//
//  DirectionsRequest.h
//  SF iOS
//
//  Created by Amit Jain on 8/5/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TransportType.h"
@import CoreLocation;

NS_ASSUME_NONNULL_BEGIN
@interface DirectionsRequest : NSObject

+ (void)requestDirectionsToLocation:(CLLocation *)destination withName:(NSString *)name usingTransportType:(TransportType)transportType completion:(void (^)(BOOL success))completion;

@end
NS_ASSUME_NONNULL_END
