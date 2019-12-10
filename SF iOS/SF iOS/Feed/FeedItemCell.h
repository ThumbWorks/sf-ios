//
//  FeedItemCell.h
//  SF iOS
//
//  Created by Amit Jain on 7/31/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedItem.h"
#import "Styleable.h"
#import "AnimationHelper.h"

NS_ASSUME_NONNULL_BEGIN

@interface FeedItemCell : UITableViewCell <Styleable>

@property (readonly, assign, nonatomic) CGRect contentFrame;
@property (readonly, assign, nonatomic) CGSize coverImageSize;

- (void)configureWithFeedItem:(FeedItem *)item;
- (void)setCoverToImage:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
