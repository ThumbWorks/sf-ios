//
//  EventDataSOurce.h
//  SF iOS
//
//  Created by Amit Jain on 7/29/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Event.h"

NS_ASSUME_NONNULL_BEGIN

@class EventDataSource;

@protocol EventDataSourceDelegate
- (void)willUpdateDataSource:(EventDataSource *)datasource;
- (void)didChangeDataSourceWithInsertions:(nullable NSArray <NSIndexPath *> *)insertions updates:(nullable NSArray <NSIndexPath *> *)updates deletions:(nullable NSArray <NSIndexPath *> *)deletions;
- (void)didFailToUpdateWithError:(NSError *)error;
@end

@interface EventDataSource : NSObject

@property (nonatomic, weak) id<EventDataSourceDelegate> delegate;
@property (nonatomic, assign) BOOL hasMoreEvents;
@property (nonatomic, readonly, assign) NSUInteger numberOfEvents;

/// Index of the next upcoming event. If not found, returns NSNotFound
@property (nonatomic, readonly, assign) NSUInteger indexOfCurrentEvent;

- (instancetype)initWithEventType:(EventType)eventType;
- (void)refresh;
- (Event *)eventAtIndex:(NSUInteger)index;

@end
NS_ASSUME_NONNULL_END
