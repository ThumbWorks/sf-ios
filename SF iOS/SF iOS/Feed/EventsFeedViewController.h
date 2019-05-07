//
//  EventsFeedViewController.h
//  SF iOS
//
//  Created by Amit Jain on 7/31/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventDataSource.h"

typedef NS_ENUM(NSInteger, FeedSections) {
    FeedSectionsEvents,
    FeedSectionsCount
};

NS_ASSUME_NONNULL_BEGIN
@interface EventsFeedViewController : UIViewController

- (instancetype)initWithDataSource:(EventDataSource *)dataSource NS_DESIGNATED_INITIALIZER;

@end
NS_ASSUME_NONNULL_END
