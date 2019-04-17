//
//  Group.h
//  Coffup
//
//  Created by Roderic Campbell on 4/17/19.
//

#import "RLMObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface Group : RLMObject

@property (nonatomic) NSString *groupID;
@property (nonatomic) NSString *slug;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *imageURLString;

- (instancetype)initWithDictionary:(NSDictionary *)groupDict;
@end

NS_ASSUME_NONNULL_END
