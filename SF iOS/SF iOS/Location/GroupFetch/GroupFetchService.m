//
//  GroupFetchService.m
//  Coffup
//
//  Created by Roderic Campbell on 4/17/19.
//

#import "GroupFetchService.h"
#import "GroupFetchOperation.h"
#import "Group.h"

@interface GroupFetchService ()
@property (nonatomic) NSOperationQueue *groupFetchQueue;
@end
@implementation GroupFetchService

- (instancetype)init {
    if (self = [super init]) {
        self.groupFetchQueue = [NSOperationQueue new];
    }
    return self;
}

-(void)getGroupsWithHandler:(GroupFetchCompletionHandler)completionHandler {
    GroupFetchOperation *operation = [[GroupFetchOperation alloc] initWithCompletionHandler:^(NSArray<NSDictionary *> *feed, NSError *_Nullable error) {
        NSMutableArray<Group *> *events = [[NSMutableArray alloc] initWithCapacity:feed.count];
        for (NSDictionary *dict in feed) {
            [events addObject:[[Group alloc] initWithDictionary:dict]];
        }
        completionHandler(events, error);
    }];
    [self.groupFetchQueue addOperation:operation];
}
@end
