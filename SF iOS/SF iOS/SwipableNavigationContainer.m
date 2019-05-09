//
//  SwipableNavigationContainer.m
//  SF iOS
//
//  Created by Zachary Drayer on 4/10/19.
//

#import "SwipableNavigationContainer.h"
#import "EventDataSource.h"
#import "EventsFeedViewController.h"
#import "EventsFeedTableView.h"
#import "SettingsViewController.h"
#import "GroupCollectionViewController.h"
#import "GroupDataSource.h"
#import "NSUserDefaults+Settings.h"
#import "Group.h"

// TODO copy pasted
#define kSEARCHBARHEIGHT 32

@interface SwipableNavigationContainer () <UIPageViewControllerDataSource, GroupCollectionViewControllerDelegate>

@property (nonatomic) EventDataSource *dataSource;
@property (nonatomic) UIPageViewController *pageViewController;
@property (nonatomic) UINavigationController *mainNav;
@property (nonatomic, copy) NSArray *pageViewControllers;
@end

@implementation SwipableNavigationContainer

- (instancetype)init {
    self = [super init];
    NSAssert(self != nil, @"-[super init] should never return nil");

    CGRect bounds = [[UIScreen mainScreen] bounds];
    _window = [[UIWindow alloc] initWithFrame:bounds];
    _window.backgroundColor = [UIColor whiteColor];

    _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                          navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                        options:@{}];
    _pageViewController.doubleSided = YES;
    _pageViewController.dataSource = self;

    GroupDataSource *groupDataSource = [[GroupDataSource alloc] init];
    GroupCollectionViewController *groupViewController = [[GroupCollectionViewController alloc] initWithDataSource:groupDataSource];
    groupDataSource.delegate = groupViewController;
    groupViewController.selectionDelegate = self;

    self.mainNav = [[UINavigationController alloc] init];

    NSArray <UIViewController *> *viewControllers;
    NSString *groupID = [[NSUserDefaults standardUserDefaults] lastViewedGroupID];
    if (groupID) {
        Group *lastSelectedGroup = [groupDataSource groupWithID:groupID];
        UIViewController *listViewController = [self viewControllerForGroup:lastSelectedGroup];
        viewControllers = @[groupViewController, listViewController];
    } else {
        viewControllers = @[groupViewController];
    }

    [self.mainNav setViewControllers:viewControllers];
    self.mainNav.navigationBar.tintColor = [UIColor blackColor];
    [self.mainNav setNavigationBarHidden:false animated:false];
    [self.mainNav.navigationBar setPrefersLargeTitles:true];
    
    [_pageViewController setViewControllers:@[self.mainNav]
                                  direction:UIPageViewControllerNavigationDirectionForward
                                   animated:NO
                                 completion:nil];

    _pageViewControllers = @[
        [SettingsViewController new],
        self.mainNav
    ];

    _window.rootViewController = _pageViewController;

    return self;
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger index = [self.pageViewControllers indexOfObject:viewController];
    if (index == 0) {
        return nil;
    }

    return self.pageViewControllers[index - 1];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger index = [self.pageViewControllers indexOfObject:viewController];
    if (index == (self.pageViewControllers.count - 1)) {
        return nil;
    }

    return self.pageViewControllers[index + 1];
}

- (void)controller:(nonnull GroupCollectionViewController *)controller tappedGroup:(nonnull Group *)group {
     [self.mainNav pushViewController:[self viewControllerForGroup:group]
                            animated:true];
}

- (UIViewController *)viewControllerForGroup:(Group *)group {
    UITableView *tableView = [[EventsFeedTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    EventDataSource *dataSource = [[EventDataSource alloc] initWithGroup:group];
    [dataSource refresh];
    return [[EventsFeedViewController alloc] initWithDataSource:dataSource
                                                      tableView:tableView];
}
@end
