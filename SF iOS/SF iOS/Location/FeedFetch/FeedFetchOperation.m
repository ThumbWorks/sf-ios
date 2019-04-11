//
//  FeedFetchOperation.m
//  SF iOS
//
//  Created by Roderic Campbell on 3/27/19.
//

#import "FeedFetchOperation.h"
@implementation FeedFetchOperation


- (instancetype)initWithCompletionHandler:(FeedCompletion)completionHandler {
    NSString *endpoint = @"https://coffeecoffeecoffee.coffee/api/groups/sf-ios-coffee/events";
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:endpoint]];
    request.HTTPMethod = @"GET";
    [request addValue:@"en_US" forHTTPHeaderField:@"Accept-Language"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    return [super initWithRequest:request completionHandler:^(NSDictionary * _Nullable json, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error || !json) {
            completionHandler(nil, error);
        } else {
            completionHandler(json, nil);
        }
    }];

}

@end
