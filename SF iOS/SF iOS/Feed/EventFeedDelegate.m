//
//  EventFeedDelegate.m
//  Coffup
//
//  Created by Roderic Campbell on 5/8/19.
//

#import "EventFeedDelegate.h"
#import "EventDataSource.h"

@interface EventFeedDelegate()
@property (nonatomic) UITableView *tableView;
@end

@implementation EventFeedDelegate
- (instancetype)initWithTableView:(UITableView *)tableView {
    if (self = [super init]) {
        self.tableView = tableView;
    }
    return self;
}

- (void)willUpdateDataSource:(id<FeedProvider>)datasource {
    [self.tableView.refreshControl beginRefreshing];
}

- (void)didChangeDataSource:(id<FeedProvider>)datasource
             withInsertions:(nullable NSArray<NSIndexPath *> *)insertions
                    updates:(nullable NSArray<NSIndexPath *> *)updates
                  deletions:(nullable NSArray<NSIndexPath *> *)deletions {

    EventDataSource *eventDataSource = (EventDataSource *)datasource;
    // Don’t crash the app by modifying the table while the user is searching
    if (eventDataSource.searchQuery.length > 0) { return; }

    // Otherwise update on changes
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView.refreshControl endRefreshing];
        //            [self updateNotificationButton];
        if (!insertions && !updates && !deletions) {
            [self.tableView reloadData];
            NSIndexPath *nextEventIndexPath = [NSIndexPath indexPathForRow:eventDataSource.indexOfCurrentEvent
                                                                 inSection:0];
            [self.tableView scrollToRowAtIndexPath:nextEventIndexPath
                                  atScrollPosition:UITableViewScrollPositionTop
                                          animated:true];
            return;
        }

        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:deletions
                              withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView insertRowsAtIndexPaths:insertions
                              withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView reloadRowsAtIndexPaths:updates
                              withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
        [self.tableView.refreshControl endRefreshing];

    });

}

- (void)didFailToUpdateDataSource:(id<FeedProvider>)datasource withError:(NSError *)error {
    [self.tableView.refreshControl endRefreshing];
}
@end
