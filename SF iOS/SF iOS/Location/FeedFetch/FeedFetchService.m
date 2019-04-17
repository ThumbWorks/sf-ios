//
//  FeedFetchService.m
//  SF iOS
//
//  Created by Roderic Campbell on 3/27/19.
//

#import "FeedFetchService.h"
#import "FeedFetchOperation.h"
#import "Event.h"

@interface FeedFetchService ()
@property (nonatomic) NSOperationQueue *feedFetchQueue;
@end

@implementation FeedFetchService

- (instancetype)init {
    if (self = [super init]) {
        self.feedFetchQueue = [NSOperationQueue new];
    }
    return self;
}

-(void)getFeedWithHandler:(FeedFetchCompletionHandler)completionHandler {
    FeedFetchOperation *operation = [[FeedFetchOperation alloc] initWithCompletionHandler:^(NSArray<NSDictionary *> *feed, NSError *_Nullable error) {
        NSMutableArray<Event *> *events = [[NSMutableArray alloc] initWithCapacity:feed.count];
        for (NSDictionary *dict in feed) {
            [events addObject:[[Event alloc] initWithDictionary:dict]];
        }
        completionHandler(events, error);
    }];
    [self.feedFetchQueue addOperation:operation];
}

@end
