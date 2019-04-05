//
//  Location.h
//  SF iOS
//
//  Created by Amit Jain on 7/28/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

@import CoreLocation;

NS_ASSUME_NONNULL_BEGIN
@interface Location : RLMObject

@property (nonatomic) NSString *streetAddress;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

- (CLLocation *)location;
@end
NS_ASSUME_NONNULL_END
