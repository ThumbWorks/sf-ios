//
//  Venue.h
//  SF iOS
//
//  Created by Roderic Campbell on 3/29/19.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

@class Location;

NS_ASSUME_NONNULL_BEGIN

@interface Venue : RLMObject
@property (nullable, nonatomic) NSString *venueURLString;
@property (nonatomic) Location *location;
@property (nonatomic) NSString *name;

- (id)initWithDictionary:(NSDictionary *)dict;

- (nullable NSURL *)venueURL;
@end

NS_ASSUME_NONNULL_END
