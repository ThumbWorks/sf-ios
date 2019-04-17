//
//  GroupFetchOperation.m
//  Coffup
//
//  Created by Roderic Campbell on 4/17/19.
//

#import "GroupFetchOperation.h"

@implementation GroupFetchOperation

- (instancetype)initWithCompletionHandler:(GroupCompletion)completionHandler {
    NSString *endpoint = @"https://coffeecoffeecoffee.coffee/api/groups/";
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
