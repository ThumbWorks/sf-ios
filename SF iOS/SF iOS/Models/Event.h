//
//  Event.h
//  SF iOS
//
//  Created by Amit Jain on 7/29/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>
#import "EventType.h"
@import UIKit;
@class Venue;
@class Location;

NS_ASSUME_NONNULL_BEGIN
@interface Event : RLMObject

@property (nonatomic, assign) NSInteger type;
@property (nonatomic) NSDate* date;
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic) Venue *venue;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *eventID;
@property (nullable, nonatomic, readonly) UIImage *annotationImage;
@property (nonatomic, readonly) NSDate *endDate;
@property (nonatomic, readonly, assign) BOOL isActive;
@property (nullable, nonatomic) NSString *imageFileURLString;

@property (nonatomic, readonly) NSString *venueName;
@property (nonatomic, readonly) Location *location;

- (instancetype)initWithDictionary:(NSDictionary *)record;

- (nullable NSURL *)imageFileURL;
- (nullable NSURL *)venueURL;
@end
NS_ASSUME_NONNULL_END
