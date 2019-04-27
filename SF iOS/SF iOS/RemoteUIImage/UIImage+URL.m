//
//  UIImage+URL.m
//  SF iOS
//
//  Created by Amit Jain on 8/2/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import "UIImage+URL.h"
#import "NSError+Constructor.h"

@implementation UIImage (URL)

+ (void)fetchImageFromURL:(NSURL *)fileURL onQueue:(nullable NSOperationQueue *)queue withCompletionHandler:(ImageDownloadCompletionHandler)completionHandler {

    if (!queue) {
        queue = [NSOperationQueue new];
    }

    [queue addOperationWithBlock:^{
        NSURLSession *sharedSession = [NSURLSession sharedSession];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:fileURL
                                                      cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                  timeoutInterval:30];
        
        [[sharedSession dataTaskWithRequest:request
                         completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            UIImage *image = nil;
            if (data) {
                image = [UIImage imageWithData:data];
            }
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                completionHandler(image, nil);
            }];
        }] resume];
    }];
}

@end
