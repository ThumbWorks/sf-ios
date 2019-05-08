//
//  GroupAndFeedLoadingCoordinator.m
//  Coffup
//
//  Created by Roderic Campbell on 5/8/19.
//

#import "GroupAndFeedLoadingCoordinator.h"
#import <UIKit/UIKit.h>
#import "Group.h"
#import "GroupDataSource.h"
#import "EventDataSource.h"
#import "EventsFeedViewController.h"

@interface GroupAndFeedLoadingCoordinator()
@property (nonatomic) UITableView *tableView;
@property (nonatomic) GroupDataSource *groupDataSource;
@property (nonatomic) EventDataSource *eventDataSource;
@property (nonatomic) EventsFeedViewController *eventsFeedViewController;
@end

@implementation GroupAndFeedLoadingCoordinator

- (instancetype)initWithGroupDataSource:(GroupDataSource *)groupDataSource tableView:(UITableView *)tableView feedViewController:(EventsFeedViewController *)eventsFeedViewController {
    if (self == [super init]) {
        _groupDataSource = groupDataSource;
        _tableView = tableView;
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

    if (datasource == self.groupDataSource) {
        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.groupButton setHidden:false];
//            [self updateNotificationButton];
            [self.tableView.refreshControl endRefreshing];
        });
        if (!insertions && !updates && !deletions) {
            NSLog(@"Empty update");
            return;
        }
        Group *group = [self.groupDataSource selectedGroup];
        if (!group) {
            group = [self.groupDataSource groupAtIndex:0];
            [self.groupDataSource selectGroup:group];
        }
        [self.eventsFeedViewController updateWithGroup:group];
    } else if (datasource == self.eventDataSource) {
        // Don’t crash the app by modifying the table while the user is searching
        if (self.eventDataSource.searchQuery.length > 0) { return; }

        // Otherwise update on changes
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.refreshControl endRefreshing];
//            [self updateNotificationButton];
            if (!insertions && !updates && !deletions) {
                NSLog(@"Empty update");
                [self.tableView reloadData];
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
}

- (void)didFailToUpdateDataSource:(id<FeedProvider>)datasource withError:(NSError *)error {
    if (datasource == self.groupDataSource) {

    } else if (datasource == self.eventDataSource) {
        [self.tableView.refreshControl endRefreshing];
    }
}
@end
