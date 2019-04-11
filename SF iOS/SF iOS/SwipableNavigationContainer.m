//
//  SwipableNavigationContainer.m
//  SF iOS
//
//  Created by Zachary Drayer on 4/10/19.
//

#import "SwipableNavigationContainer.h"
#import "EventDataSource.h"
#import "EventsFeedViewController.h"
#import "SettingsViewController.h"

@interface SwipableNavigationContainer () <UIPageViewControllerDataSource>

@property (nonatomic) EventDataSource *dataSource;
@property (nonatomic) UIPageViewController *pageViewController;
@property (nonatomic, copy) NSArray *pageViewControllers;

@end

@implementation SwipableNavigationContainer

- (instancetype)init {
    self = [super init];
    NSAssert(self != nil, @"-[super init] should never return nil");

    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _window.backgroundColor = [UIColor whiteColor];

    _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                          navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                        options:@{}];
    _pageViewController.doubleSided = YES;
    _pageViewController.dataSource = self;

    EventDataSource *datasource = [[EventDataSource alloc] initWithEventType:EventTypeSFCoffee];
    EventsFeedViewController *feedController = [[EventsFeedViewController alloc] initWithDataSource:datasource];

    [_pageViewController setViewControllers:@[ feedController ] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];

    _pageViewControllers = @[
        [[SettingsViewController alloc] init],
        feedController
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

@end
