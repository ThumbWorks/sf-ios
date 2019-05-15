//
//  EventsFeedViewController.m
//  SF iOS
//
//  Created by Amit Jain on 7/31/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import "EventsFeedViewController.h"
#import "EventDetailsViewController.h"
#import "FeedItemCell.h"
#import "FeedItem.h"
#import "UserLocation.h"
#import "UIImage+URL.h"
#import "ImageStore.h"
#import "NSUserDefaults+Settings.h"
#import <UserNotifications/UserNotifications.h>
#import "ImageBasedCollectionViewCell.h"
#import "EventDataSource.h"
#import "Group.h"
#import "UIViewController+ErrorHandling.h"
#import "EventFeedDelegate.h"

NS_ASSUME_NONNULL_BEGIN
@interface EventsFeedViewController () <UITableViewDataSource, UITableViewDelegate, UIViewControllerPreviewingDelegate, UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating>

@property (nonatomic, nonnull) EventDataSource *dataSource;
@property (nonatomic, nonnull) EventFeedDelegate *feedDelegate;
@property (nonatomic) UITableView *tableView;
@property (nonatomic, assign) BOOL firstLoad;
@property (nonatomic) ImageStore *imageStore;
@property (nonatomic) NSOperationQueue *imageFetchQueue;
@property (nullable, nonatomic) UserLocation *userLocationService;
@property (nonatomic) UIView *noResultsView;
@property (nonatomic) UIButton *notificationSettingButton;
@property (nonatomic) UISearchController *searchController;

@end
NS_ASSUME_NONNULL_END

@implementation EventsFeedViewController

- (instancetype)initWithDataSource:(EventDataSource *)eventDataSource tableView:(UITableView *)tableView {
    if (self = [super initWithNibName:nil bundle:nil]) {
        self.feedDelegate = [[EventFeedDelegate alloc] initWithTableView:tableView];
        eventDataSource.delegate = self.feedDelegate;
        self.dataSource = eventDataSource;
        self.userLocationService = [UserLocation new];
        self.imageFetchQueue = [[NSOperationQueue alloc] init];
        self.imageFetchQueue.name = @"Image Fetch Queue";
        self.imageStore = [[ImageStore alloc] init];
        self.firstLoad = self.dataSource.numberOfItems == 0;
        self.tableView = tableView;
        tableView.delegate = self;
        tableView.dataSource = self;
    }
    
    return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style {
    NSAssert(false, @"Use -initWithDataSource");
    self = [self initWithDataSource:[EventDataSource new] tableView:[UITableView new]];
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    NSAssert(false, @"Use -initWithDataSource");
    self = [self initWithDataSource:[EventDataSource new] tableView:[UITableView new]];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    NSAssert(false, @"Use -initWithDataSource");
    self = [self initWithDataSource:[EventDataSource new] tableView:[UITableView new]];
    return self;
}

- (void)setupNotificationsButton {
    UIImage *unsubscribedImage = [UIImage imageNamed:@"NotificationsEnable"];
    UIImage *subscribedImage = [UIImage imageNamed:@"NotificationsDisable"];
    self.notificationSettingButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.notificationSettingButton addTarget:self
                                       action:@selector(notificationTapped:)
                             forControlEvents:UIControlEventTouchUpInside];
    [self.notificationSettingButton setImage:unsubscribedImage forState:UIControlStateNormal];
    [self.notificationSettingButton setImage:subscribedImage forState:UIControlStateSelected];

    self.notificationSettingButton.translatesAutoresizingMaskIntoConstraints = false;
    [self.view addSubview:self.notificationSettingButton];

    // safeAreaLayoutGuide is giving different results between pre-iPhone X and iPhone X and later devices
    [self.notificationSettingButton.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor
                                                                constant:-18].active = true;
    [self.notificationSettingButton.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor
                                                                   constant:-18].active = true;
    [self.notificationSettingButton.heightAnchor constraintEqualToConstant:53].active = true;
    [self.notificationSettingButton.widthAnchor constraintEqualToConstant:53].active = true;
    [self updateNotificationButton];
}

- (void)notificationTapped:(UIButton *)button {
    NSString *groupID = self.dataSource.groupID;
    BOOL isNotificationSet = [[NSUserDefaults standardUserDefaults] notificationSettingForGroupWithID:groupID];
    NSString *buttonTitle;
    if (isNotificationSet) {
        buttonTitle = NSLocalizedString(@"Turn off notifications",
                                        @"Turn off notifications action sheet button");
    } else {
        buttonTitle = NSLocalizedString(@"Turn on notifications",
                                        @"Turn on notifications action sheet button");
    }
    NSString *cancelButtonTitle = NSLocalizedString(@"Cancel", @"Cancel");
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    __weak typeof(self) welf = self;
    void (^notificationsPreferenceChangeTapped)(UIAlertAction * _Nonnull) = ^void(UIAlertAction * _Nonnull action) {

        // if notifications are turned on, set them to off
        if (isNotificationSet) {
            [[NSUserDefaults standardUserDefaults] setNotificationSetting:FALSE
                                                                 forGroupWithID:groupID];
            [self updateNotificationButton];
        }
        // if notifications are turned off, request permissions
        // only if they are granted do we update the setting
        else {
            UNUserNotificationCenter *notificationCenter = [UNUserNotificationCenter currentNotificationCenter];
            UNAuthorizationOptions options = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;

            [notificationCenter requestAuthorizationWithOptions:options
                                              completionHandler:^(BOOL granted, NSError *error){
                                                  if (error) {
                                                      [welf handleError:error];
                                                      NSLog(@"Error %@", error);
                                                      return;
                                                  }
                                                  // if they've granted perms, update the setting, notify UI
                                                  if (granted) {
                                                      // This hits UI and accesses a main thread group object so we must dispatch on main queue
                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                          NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                                          [defaults setNotificationSetting:!isNotificationSet
                                                                            forGroupWithID:groupID];
                                                          [welf updateNotificationButton];
                                                      });
                                                  }
                                              }];
        };
    };
    [alert addAction:[UIAlertAction actionWithTitle:buttonTitle
                                              style:UIAlertActionStyleDefault
                                            handler:notificationsPreferenceChangeTapped]];

    [alert addAction:[UIAlertAction actionWithTitle:cancelButtonTitle
                                              style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction * _Nonnull action) {
                                                  [welf updateNotificationButton];
                                              }]];
    [self presentViewController:alert animated:true completion:nil];
}

- (void)updateNotificationButton {
    NSString *groupID = self.dataSource.groupID;
    BOOL isNotificationSet = [[NSUserDefaults standardUserDefaults] notificationSettingForGroupWithID:groupID];
    [self.notificationSettingButton setSelected:isNotificationSet];
}

- (void)configureNoResultsView {
    self.noResultsView = [[UIView alloc] init];
    self.noResultsView.frame = CGRectMake(0, 0, self.tableView.frame.size.width, self.view.bounds.size.height);
    [self.noResultsView setHidden:true];
    [self.view addSubview:self.noResultsView];
    
    CGRect labelFrame = CGRectMake(0, 0, self.view.frame.size.width, 100);
    UILabel *noResultsLabel = [[UILabel alloc] initWithFrame:labelFrame];
    noResultsLabel.text = NSLocalizedString(@"No events", @"Displayed when no Event names match the given search term");
    noResultsLabel.textAlignment = NSTextAlignmentCenter;
    noResultsLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleTitle2];
    [self.noResultsView addSubview:noResultsLabel];
}

- (void)addConstraints {
    [self.tableView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = true;
    [self.tableView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = true;
    [self.tableView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = true;
    [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = true;
    [self.tableView.widthAnchor constraintEqualToAnchor:self.view.widthAnchor].active = true;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    self.title = self.dataSource.groupName;
    [self addConstraints];

    [self registerForPreviewingWithDelegate:self sourceView:self.tableView];
    
    [self setupNotificationsButton];
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.searchBar.placeholder = @"Filter";
    [self.searchController.searchBar sizeToFit];
    self.searchController.delegate = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.delegate = self;
    self.navigationItem.searchController = self.searchController;
    self.navigationItem.hidesSearchBarWhenScrolling = YES;
    self.definesPresentationContext = YES;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    
    // Content Inset was causing some jank when loading SF Coffee, others were fine.
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 16)];
    
    [self configureNoResultsView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                                           target:self
                                                                                           action:@selector(share)];

    [[NSUserDefaults standardUserDefaults] setLastViewedGroupID:self.dataSource.groupID];
}

- (void)share {
    NSString *url = [NSString stringWithFormat:@"https://coffeecoffeecoffee.coffee/%@", self.dataSource.groupID];
    NSArray *items = @[[NSURL URLWithString:url]];
    UIActivityViewController *shareSheet = [[UIActivityViewController alloc] initWithActivityItems:items
                                                                             applicationActivities:nil];
    [self presentViewController:shareSheet animated:true completion:nil];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView reloadData];
    self.tableView.refreshControl = [[UIRefreshControl alloc] init];
    [self.tableView.refreshControl addTarget:self.dataSource action:@selector(refresh) forControlEvents:UIControlEventAllEvents];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self.tableView.refreshControl endRefreshing];
    [self.imageFetchQueue cancelAllOperations];
    [super viewDidDisappear:animated];
}

//MARK: - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.numberOfItems;
}

- (UITableViewCell *)tableView:(UITableView *)tableView eventCellAtIndexPath:(NSIndexPath *)indexPath {
    FeedItemCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(self.feedItemCellClass) forIndexPath:indexPath];
    if (!cell) {
        NSAssert(false, @"cell couldn't be dequeued");
    }

    FeedItem *item = [[FeedItem alloc] initWithEvent:[self.dataSource eventAtIndex:indexPath.row]];
    [cell configureWithFeedItem:item];

    UIImage *image = [self.imageStore imageForKey:[item.coverImageFileURL absoluteString]];
    if (image) {
        [cell setCoverToImage:image];
    } else {
        __weak typeof(self) welf = self;
        [UIImage
         fetchImageFromURL:item.coverImageFileURL
         onQueue: self.imageFetchQueue
         withCompletionHandler:^(UIImage * _Nullable image, NSError * _Nullable error) {
             if (!image || error) {
                 NSLog(@"Error decoding image: %@", error);
                 return;
             }
             [welf.imageStore storeImage:image forKey:[item.coverImageFileURL absoluteString]];

             // Fetch the cell again, if it exists as the original instance of cell might have been
             // dequeued by now. If the cell does not exist, setting the image will silently fail.
             [(FeedItemCell *)[tableView cellForRowAtIndexPath:indexPath] setCoverToImage:image];
         }];
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self tableView:tableView eventCellAtIndexPath:indexPath];
}

- (Class)feedItemCellClass {
    return [FeedItemCell class];
}

//MARK: - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.userLocationService requestLocationPermission];
    EventDetailsViewController *vc = [self eventDetailsViewControllerForEventAtIndexPath:indexPath];
    [self.navigationController pushViewController:vc animated:true];
}

- (void)handleRefresh {
    self.dataSource.searchQuery = @"";
    self.searchController.searchBar.text = @"";
    [self.tableView reloadData];
    [self handleFilterResults];
    [self.tableView.refreshControl endRefreshing];
}

//MARK: - 3D Touch Peek & Pop

- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    if (!indexPath) { return nil; }
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (!cell || ![cell isKindOfClass:[self.feedItemCellClass class]]) {
        return nil;
    }
    
    previewingContext.sourceRect = [(FeedItemCell *)cell contentFrame];
    
    return [self eventDetailsViewControllerForEventAtIndexPath:indexPath];
}

- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    [self presentViewController:viewControllerToCommit animated:true completion:nil];
}


//MARK: - Search Controller

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    self.dataSource.searchQuery = searchController.searchBar.text;
    [self.tableView reloadData];
    [self handleFilterResults];
}

//MARK: - UISearchBarDelegate
- (void)handleFilterResults {
    if (self.dataSource.numberOfItems < 1) {
        [self.noResultsView setHidden:false];
        return;
    }
    [self.noResultsView setHidden:true];
    [self.tableView.refreshControl endRefreshing];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar setText:@""];
    [searchBar setShowsCancelButton:NO];
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}


//MARK: - Details View

- (EventDetailsViewController *)eventDetailsViewControllerForEventAtIndexPath:(NSIndexPath *)indexPath {
    Event *event = [self.dataSource eventAtIndex:indexPath.row];
    return [[EventDetailsViewController alloc] initWithEvent:event groupName:self.dataSource.groupName userLocationService:self.userLocationService];
}

//MARK: - Cell Dimensions

static CGFloat const eventCellAspectRatio = 1.352;

- (CGFloat)cellHeight {
    return [UIScreen mainScreen].bounds.size.width * eventCellAspectRatio;
}

//MARK: - First Load

- (void)refresh {
    if (!self.firstLoad) {
        [self.tableView reloadData];
        return;
    }
    
    [self animateFirstLoad];
    self.firstLoad = false;
}

- (void)animateFirstLoad {
    [self.tableView reloadData];
    
    if (self.dataSource.indexOfCurrentEvent != NSNotFound) {
        NSIndexPath *nextEventIndexPath = [NSIndexPath indexPathForRow:self.dataSource.indexOfCurrentEvent inSection:0];
        [self.tableView scrollToRowAtIndexPath:nextEventIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:false];
    }
    
    NSTimeInterval stagger = 0.2;
    [self.tableView.visibleCells enumerateObjectsUsingBlock:^(__kindof UITableViewCell * _Nonnull cell, NSUInteger idx, BOOL * _Nonnull stop) {
        cell.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, [UIScreen mainScreen].bounds.size.height);
        cell.alpha = 0;
        
        [UIView
         animateWithDuration:0.8
         delay:stagger * (idx + 1)
         usingSpringWithDamping:0.8
         initialSpringVelocity:0
         options:0
         animations:^{
             cell.alpha = 1;
             cell.transform = CGAffineTransformIdentity;
         }
         completion:nil];
    }];
}

- (void)didMoveToParentViewController:(UIViewController *)parent {
    // parent is nil if this view controller was removed
    if (!parent) {
        [[NSUserDefaults standardUserDefaults] setLastViewedGroupID:nil];
    }
}
@end

