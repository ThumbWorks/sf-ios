//
//  GroupAndFeedLoadingCoordinator.h
//  Coffup
//
//  Created by Roderic Campbell on 5/8/19.
//

#import <Foundation/Foundation.h>
#import "FeedProviderDelegate.h"
#import <UIKit/UIKit.h>

@class GroupDataSource;
@class EventsFeedViewController;

NS_ASSUME_NONNULL_BEGIN

@interface GroupAndFeedLoadingCoordinator : NSObject <FeedProviderDelegate>
- (instancetype)initWithGroupDataSource:(GroupDataSource *)groupDataSource tableView:(UITableView *)tableView feedViewController:(EventsFeedViewController *)eventsFeedViewController;
@end

NS_ASSUME_NONNULL_END
