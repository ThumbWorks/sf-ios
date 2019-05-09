//
//  EventsFeedTableView.m
//  Coffup
//
//  Created by Roderic Campbell on 5/8/19.
//

#import "EventsFeedTableView.h"
#import "FeedItemCell.h"


@implementation EventsFeedTableView
static CGFloat const eventCellAspectRatio = 1.352;

- (CGFloat)cellHeight {
    return [UIScreen mainScreen].bounds.size.width * eventCellAspectRatio;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:CGRectZero style:UITableViewStylePlain]) {
        [self registerClass:[FeedItemCell class] forCellReuseIdentifier:NSStringFromClass([FeedItemCell class])];
        self.rowHeight = self.cellHeight;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableHeaderView.backgroundColor = UIColor.clearColor;
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.delaysContentTouches = NO;

        self.refreshControl = [[UIRefreshControl alloc] init];
    }
    return self;
}
@end
