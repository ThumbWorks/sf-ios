//
//  Group.h
//  Coffup
//
//  Created by Roderic Campbell on 4/17/19.
//

#import "RLMObject.h"
#import <Realm/Realm.h>
NS_ASSUME_NONNULL_BEGIN

@interface Group : RLMObject

@property (nonatomic, nonnull) NSString *groupID;
@property (nonatomic, nonnull) NSString *urlString;
@property (nonatomic, nonnull) NSString *name;
@property (nonatomic, nullable) NSString *imageURLString;

- (instancetype)initWithDictionary:(NSDictionary *)groupDict;
@end

NS_ASSUME_NONNULL_END
