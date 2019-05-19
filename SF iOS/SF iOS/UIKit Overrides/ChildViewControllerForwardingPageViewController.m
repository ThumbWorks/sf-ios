//
//  ChildViewControllerForwardingPageViewController.m
//  Coffup
//
//  Created by Zachary Drayer on 5/18/19.
//

#import "ChildViewControllerForwardingPageViewController.h"
#import "Style.h"

@interface ChildViewControllerForwardingPageViewController ()

@property (nonatomic) id<Style> style;

@end

@implementation ChildViewControllerForwardingPageViewController

- (UIViewController *)childViewControllerForStatusBarStyle {
	return self.viewControllers.lastObject;
}

- (void)applyStyle:(id<Style>)style {
	self.style = style;

	NSArray <__kindof UIViewController *> *diff = [self.viewControllers filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary<NSString *,id> *_) {
		return [evaluatedObject conformsToProtocol:@protocol(Styleable)];
	}]];

	[self applyStyle:style toViewControllers:diff];
}

- (void)setViewControllers:(nullable NSArray<UIViewController *> *)viewControllers direction:(UIPageViewControllerNavigationDirection)direction animated:(BOOL)animated completion:(void (^ __nullable)(BOOL finished))completion {
	NSArray <__kindof UIViewController *> *diff = [viewControllers filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary<NSString *,id> *_) {
		return ![self.viewControllers containsObject:evaluatedObject] && [evaluatedObject conformsToProtocol:@protocol(Styleable)];
	}]];

	[self applyStyle:self.style toViewControllers:diff];

	[super setViewControllers:viewControllers direction:direction animated:animated completion:completion];
}

- (void)applyStyle:(id<Style>)style toViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers {
	for (id<Styleable> styleableViewController in viewControllers) {
		[styleableViewController applyStyle:style];
	}
}

@end
