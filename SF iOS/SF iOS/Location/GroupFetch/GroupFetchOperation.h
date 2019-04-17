//
//  GroupFetchOperation.h
//  Coffup
//
//  Created by Roderic Campbell on 4/17/19.
//

#import "HTTPRequestAsyncOperation.h"
#import "GroupCompletion.h"

NS_ASSUME_NONNULL_BEGIN

@interface GroupFetchOperation : HTTPRequestAsyncOperation
- (instancetype)initWithCompletionHandler:(GroupCompletion)completionHandler;
@end

NS_ASSUME_NONNULL_END
