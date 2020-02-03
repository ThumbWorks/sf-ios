//
//  TravelTime.m
//  SF iOS
//
//  Created by Amit Jain on 8/3/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import "TravelTime.h"
#import "NSDate+Utilities.h"

@implementation TravelTime

- (instancetype)initWithTransportType:(TransportType)transportType travelTime:(NSTimeInterval)travelTime {
    if (self = [super init]) {
        self.transportType = transportType;
        self.travelTime = travelTime;
        
        switch (self.transportType) {
            case TransportTypeTransit:
                self.icon = [UIImage imageNamed:@"icon-transport-type-transit"];
                break;
                
            case TransportTypeWalking:
                self.icon = [UIImage imageNamed:@"icon-transport-type-walking"];
                break;
                
            case TransportTypeAutomobile:
                self.icon = [UIImage imageNamed:@"icon-transport-type-automobile"];
                break;
                
            case TransportTypeUber:
                self.icon = [UIImage imageNamed:@"icon-transport-type-uber"];
                break;
                
            case TransportTypeLyft:
                self.icon = [UIImage imageNamed:@"icon-transport-type-lyft"];
                break;
                
            default:
                break;
        }
    }
    
    return self;
}

- (instancetype)initWithMKDirectionsTransportType:(MKDirectionsTransportType)mkTransportType travelTime:(NSTimeInterval)travelTime {
    TransportType transportType;
    switch (mkTransportType) {
        case MKDirectionsTransportTypeTransit:
            transportType = TransportTypeTransit;
            break;
            
        case MKDirectionsTransportTypeWalking:
            transportType = TransportTypeWalking;
            break;
        
        case MKDirectionsTransportTypeAutomobile:
            transportType = TransportTypeAutomobile;
            break;
            
        default:
            NSAssert(false, @"Unsupported transport type: %lu", mkTransportType);
            transportType = INT_MAX;
            break;
    }
    
    return [self initWithTransportType:transportType travelTime:travelTime];
}

- (NSString *)travelTimeEstimateString {
    if (self.travelTime < 0) {
        return @"—";
    }
    return [NSDate abbreviatedTimeIntervalForTimeInterval:self.travelTime];
}

@end
