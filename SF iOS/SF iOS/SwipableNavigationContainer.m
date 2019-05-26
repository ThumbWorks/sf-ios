//
//  SwipableNavigationContainer.m
//  SF iOS
//
//  Created by Zachary Drayer on 4/10/19.
//

#import "SwipableNavigationContainer.h"

#import "AffogatoStyle.h"
#import "ChildViewControllerForwardingNavigationController.h"
#import "ChildViewControllerForwardingPageViewController.h"
#import "EspressoStyle.h"
#import "EventDataSource.h"
#import "EventsFeedViewController.h"
#import "EventsFeedTableView.h"
#import "Group.h"
#import "GroupCollectionViewController.h"
#import "GroupDataSource.h"
#import "MochaStyle.h"
#import "SettingsViewController.h"
#import "Styleable.h"
#import "NSUserDefaults+Settings.h"

@interface SwipableNavigationContainer () <UINavigationControllerDelegate, UIPageViewControllerDataSource, GroupCollectionViewControllerDelegate>

@property (nonatomic) EventDataSource *dataSource;
@property (nonatomic) UIPageViewController *pageViewController;
@property (nonatomic) UINavigationController *navigationController;
@property (nonatomic, copy) NSArray *pageViewControllers;
@end

@implementation SwipableNavigationContainer

- (instancetype)init {
    self = [super init];
    NSAssert(self != nil, @"-[super init] should never return nil");

    CGRect bounds = [[UIScreen mainScreen] bounds];
    _window = [[UIWindow alloc] initWithFrame:bounds];

    GroupDataSource *groupDataSource = [[GroupDataSource alloc] init];
    GroupCollectionViewController *groupViewController = [[GroupCollectionViewController alloc] initWithDataSource:groupDataSource];
    groupDataSource.delegate = groupViewController;
    groupViewController.selectionDelegate = self;

	_navigationController = [[ChildViewControllerForwardingNavigationController alloc] initWithRootViewController:groupViewController];
	_navigationController.delegate = self;

	NSString *groupID = [[NSUserDefaults standardUserDefaults] lastViewedGroupID];
	if (groupID) {
		Group *lastSelectedGroup = [groupDataSource groupWithID:groupID];
		UIViewController *listViewController = [self viewControllerForGroup:lastSelectedGroup];
		[_navigationController presentViewController:listViewController animated:NO completion:nil];
	}

	_navigationController.navigationBar.prefersLargeTitles = YES;
	[_navigationController setNavigationBarHidden:NO animated:NO];

	_pageViewController = [[ChildViewControllerForwardingPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
																					 navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
																								   options:@{}];
	_pageViewController.doubleSided = YES;
	_pageViewController.dataSource = self;
    [_pageViewController setViewControllers:@[ _navigationController ]
                                  direction:UIPageViewControllerNavigationDirectionForward
                                   animated:NO
                                 completion:nil];
	_pageViewControllers = @[ [[SettingsViewController alloc] init], _navigationController ];

	id<Style> style = [self _styleFromIdentifier:NSUserDefaults.standardUserDefaults.activeStyleIdentifier];
	_window.backgroundColor = style.colors.backgroundColor;
	_window.tintColor = style.colors.tintColor;
	[self _applyStyle:style toViewControllers:@[ _pageViewController, _navigationController ]];

    _window.rootViewController = _pageViewController;

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDefaultsDidChange:) name:NSUserDefaultsDidChangeNotification object:nil];

    return self;
}

#pragma mark - NSNotifications

- (void)userDefaultsDidChange:(NSNotification *)notification {
	id<Style> style = [self _styleFromIdentifier:NSUserDefaults.standardUserDefaults.activeStyleIdentifier];
	self.window.backgroundColor = style.colors.backgroundColor;
	self.window.tintColor = style.colors.tintColor;
	[self _applyStyle:style toViewControllers:@[ self.pageViewController, self.navigationController ]];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
	id<Style> style = [self _styleFromIdentifier:NSUserDefaults.standardUserDefaults.activeStyleIdentifier];
	[self _applyStyle:style toViewControllers:@[ viewController ]];
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger index = [self.pageViewControllers indexOfObject:viewController];
    if (index == 0) {
        return nil;
    }

    UIViewController *previousViewController = self.pageViewControllers[index - 1];
	id<Style> style = [self _styleFromIdentifier:NSUserDefaults.standardUserDefaults.activeStyleIdentifier];

	[self _applyStyle:style toViewControllers:@[ previousViewController ]];

	return previousViewController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger index = [self.pageViewControllers indexOfObject:viewController];
    if (index == (self.pageViewControllers.count - 1)) {
        return nil;
    }

	UIViewController *nextViewController = self.pageViewControllers[index + 1];
	id<Style> style = [self _styleFromIdentifier:NSUserDefaults.standardUserDefaults.activeStyleIdentifier];

	[self _applyStyle:style toViewControllers:@[ nextViewController ]];

	return nextViewController;
}

#pragma mark - Groups

- (void)controller:(nonnull GroupCollectionViewController *)controller tappedGroup:(nonnull Group *)group {
	[self.navigationController presentViewController:[self viewControllerForGroup:group] animated:YES completion:nil];
}

- (UIViewController *)viewControllerForGroup:(Group *)group {
    UITableView *tableView = [[EventsFeedTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    EventDataSource *dataSource = [[EventDataSource alloc] initWithGroup:group];
    [dataSource refresh];

    EventsFeedViewController *eventsFeedViewController = [[EventsFeedViewController alloc] initWithDataSource:dataSource
																									tableView:tableView];
	eventsFeedViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismiss:)];
    ChildViewControllerForwardingNavigationController *navigationController = [[ChildViewControllerForwardingNavigationController alloc] initWithRootViewController:eventsFeedViewController];
    navigationController.delegate = self;
    navigationController.navigationBar.prefersLargeTitles = true;
    return navigationController;
}

- (void)dismiss:(nullable id)sender {
	[self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -

- (id<Style>)_styleFromIdentifier:(NSString *)identifier {
	if ([identifier isEqualToString:EspressoStyle.identifier]) {
		return [[EspressoStyle alloc] init];
	}

	if ([identifier isEqualToString:AffogatoStyle.identifier]) {
		return [[AffogatoStyle alloc] init];
	}

	if ([identifier isEqualToString:MochaStyle.identifier]) {
		return [[MochaStyle alloc] init];
	}

	// If no style is selected, fall back to looking at the interface style if possible (>= iOS 12).
	if (@available(iOS 12.0, *)) {
		if (self.window.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
			return [[MochaStyle alloc] init];
		}
	}

	return [[AffogatoStyle alloc] init];
}

- (void)_applyStyle:(id<Style>)style toViewControllers:(NSArray<UIViewController *> *)viewControllers {
	for (UIViewController *viewController in viewControllers) {
		if (![viewController conformsToProtocol:@protocol(Styleable)]) {
			continue;
		}

		id<Styleable> styleable = (id<Styleable>)viewController;
		[styleable applyStyle:style];
	}
}

@end
