//
//  UIActivityViewController+Utilities.m
//  Coffup
//
//  Created by Jerry Tung on 5/17/19.
//

#import "UIActivityViewController+Utilities.h"
#import <Foundation/Foundation.h>

@implementation UIActivityViewController(Utilities)

- (UIActivityViewController*)shareApp {
    NSString *itunesURL = @"https://itunes.apple.com/us/app/coffee-coffee-coffee/id1458031604?mt=8";
    
    NSString *text = [NSString stringWithFormat:NSLocalizedString(@"Download the Coffee Coffee Coffee app:", @"Download the Coffee Coffee Coffee app:")];
    
    NSArray *activityItems = @[text, itunesURL];

    return [self initWithActivityItems:activityItems applicationActivities:nil];
}


@end
