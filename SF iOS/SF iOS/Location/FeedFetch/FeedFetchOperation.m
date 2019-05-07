//
//  FeedFetchOperation.m
//  SF iOS
//
//  Created by Roderic Campbell on 3/27/19.
//

#import "FeedFetchOperation.h"
@implementation FeedFetchOperation


- (instancetype)initWithURLString:(NSString *)urlString completionHandler:(FeedCompletion)completionHandler {
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    request.HTTPMethod = @"GET";
    [request addValue:@"en_US" forHTTPHeaderField:@"Accept-Language"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    return [super initWithRequest:request completionHandler:^(NSDictionary * _Nullable json, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error || !json) {
            completionHandler(nil, error);
            return;
        }
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (httpResponse.statusCode == 404) {

            NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"Address not found on server"};
            NSError *error = [[NSError alloc] initWithDomain:@"SFIOSCoffeeErrorDomain"
                                                        code:9999
                                                    userInfo:userInfo];
            completionHandler(nil, error);
            return;
        }

        completionHandler(json, nil);
    }];

}

@end
