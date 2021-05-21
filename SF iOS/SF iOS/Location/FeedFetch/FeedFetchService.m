//
//  FeedFetchService.m
//  SF iOS
//
//  Created by Roderic Campbell on 3/27/19.
//

#import "FeedFetchService.h"
#import "FeedFetchOperation.h"
#import "Event.h"
#import "NSDate+Utilities.h"

@interface FeedFetchService ()
@property (nonatomic) NSOperationQueue *feedFetchQueue;
@property (nonatomic) NSString *urlString;
@end

@implementation FeedFetchService

- (id)initWithGroupID:(NSString *)feedID {
    if (self = [super init]) {
        self.feedFetchQueue = [NSOperationQueue new];
        self.urlString = [NSString
                          stringWithFormat:@"https://coffeecoffeecoffee.coffee/api/groups/%@/events", feedID];
    }
    return self;
}

-(void)getFeedWithHandler:(FeedFetchCompletionHandler)completionHandler {
    FeedFetchOperation *operation = [[FeedFetchOperation alloc] initWithURLString:self.urlString
                                                                completionHandler:^(NSArray<NSDictionary *> *feed,
                                                                                    NSError *_Nullable error) {
        NSMutableArray<Event *> *events = [[NSMutableArray alloc] initWithCapacity:feed.count];
        for (NSDictionary *dict in feed) {
            [events addObject:[[Event alloc] initWithDictionary:dict dateFormatter:[NSDate formatter]]];
        }
        completionHandler(events, error);
    }];
    [self.feedFetchQueue addOperation:operation];
}

@end
