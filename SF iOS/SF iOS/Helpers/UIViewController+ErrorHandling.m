//
//  UIViewController+errorHandling.m
//  Coffup
//
//  Created by Roderic Campbell on 5/8/19.
//

#import "UIViewController+ErrorHandling.h"

@implementation UIViewController (ErrorHandling)

- (void)handleError:(NSError *)error {
    NSLog(@"Error fetching events: %@", error);
    NSString *errorTitle = NSLocalizedString(@"Error Fetching Events",
                                             @"Title label for when a fetch from the network failed");
    NSString *errorMessage = NSLocalizedString(@"There was an error fetching events. Please try again",
                                               @"Title message body for when a fetch from the network failed");
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:errorTitle
                                message:errorMessage
                                preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:true completion:nil];
    }];
    [alert addAction:okAction];

    [self presentViewController:alert animated:true completion:nil];
}
@end
