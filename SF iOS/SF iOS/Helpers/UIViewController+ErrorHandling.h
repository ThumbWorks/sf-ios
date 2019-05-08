//
//  UIViewController+ErrorHandling.h
//  Coffup
//
//  Created by Roderic Campbell on 5/8/19.
//

#import <UIKit/UIKit.h>
#import "UIViewController+ErrorHandling.h"
NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (ErrorHandling)
- (void)handleError:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
