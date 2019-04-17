//
//  GroupFetchService.h
//  Coffup
//
//  Created by Roderic Campbell on 4/17/19.
//

#import <Foundation/Foundation.h>
@class Group;

NS_ASSUME_NONNULL_BEGIN

@interface GroupFetchService : NSObject

typedef void(^GroupFetchCompletionHandler)(NSArray<Group *> *feedFetchItems, NSError *_Nullable error);
-(void)getGroupsWithHandler:(GroupFetchCompletionHandler)completionHandler;

@end

NS_ASSUME_NONNULL_END
