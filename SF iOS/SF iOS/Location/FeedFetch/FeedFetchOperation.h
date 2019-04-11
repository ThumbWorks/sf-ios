//
//  FeedFetchOperation.h
//  SF iOS
//
//  Created by Roderic Campbell on 3/27/19.
//

#import "HTTPRequestAsyncOperation.h"
#import "FeedCompletion.h"

NS_ASSUME_NONNULL_BEGIN

@interface FeedFetchOperation : HTTPRequestAsyncOperation
- (instancetype)initWithCompletionHandler:(FeedCompletion)completionHandler;
@end

NS_ASSUME_NONNULL_END
