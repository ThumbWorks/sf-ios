//
//  EventDataSOurce.h
//  SF iOS
//
//  Created by Amit Jain on 7/29/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Event.h"
#import "FeedProvider.h"
#import "FeedProviderDelegate.h"
@class EventDataSource;
@class Group;

NS_ASSUME_NONNULL_BEGIN

@interface EventDataSource : NSObject <FeedProvider>

@property (nonatomic, weak) id<FeedProviderDelegate> delegate;
@property (nonatomic) Group *group;

/// Setting the searchQuery will filter events by Event.name
@property (nonatomic, copy) NSString *searchQuery;

/// Index of the next upcoming event. If not found, returns NSNotFound
@property (nonatomic, readonly, assign) NSUInteger indexOfCurrentEvent;

- (Event *)eventAtIndex:(NSUInteger)index;
- (RLMResults<Event *> *)filterEventsWithSearchTerm:(NSString *)searchTerm;

- (id)initWithGroup:(Group *)group;

- (void)refresh;

@end
NS_ASSUME_NONNULL_END
