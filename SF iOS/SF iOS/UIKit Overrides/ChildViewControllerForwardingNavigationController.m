//
//  ChildViewControllerForwardingNavigationController.m
//  Coffup
//
//  Created by Zachary Drayer on 5/18/19.
//

#import "ChildViewControllerForwardingNavigationController.h"

@interface ChildViewControllerForwardingNavigationController ()

@property (nonatomic) id<Style> style;

@end

@implementation ChildViewControllerForwardingNavigationController

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

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
	if ([viewController conformsToProtocol:@protocol(Styleable)]) {
		[self applyStyle:self.style toViewControllers:@[ viewController ]];
	}

	[super pushViewController:viewController animated:animated];
}

- (void)setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers {
	NSArray <__kindof UIViewController *> *diff = [viewControllers filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary<NSString *,id> *_) {
		return ![self.viewControllers containsObject:evaluatedObject] && [evaluatedObject conformsToProtocol:@protocol(Styleable)];
	}]];

	[self applyStyle:self.style toViewControllers:diff];

	[super setViewControllers:viewControllers];
}

- (void)applyStyle:(id<Style>)style toViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers {
	for (id<Styleable> styleableViewController in viewControllers) {
		[styleableViewController applyStyle:style];
	}
}

@end
