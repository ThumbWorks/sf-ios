//
//  EventFeedDelegate.h
//  Coffup
//
//  Created by Roderic Campbell on 5/8/19.
//

#import <Foundation/Foundation.h>
#import "FeedProviderDelegate.h"
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface EventFeedDelegate : NSObject <FeedProviderDelegate>
- (instancetype)initWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
