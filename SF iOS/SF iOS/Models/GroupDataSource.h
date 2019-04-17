//
//  GroupDataSource.h
//  Coffup
//
//  Created by Roderic Campbell on 4/17/19.
//

#import <Foundation/Foundation.h>
#import "FeedProvider.h"
#import "FeedProviderDelegate.h"
@class Group;

NS_ASSUME_NONNULL_BEGIN

@interface GroupDataSource : NSObject <FeedProvider>
@property (nonatomic, weak) id<FeedProviderDelegate> delegate;
- (Group *)groupAtIndex:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
