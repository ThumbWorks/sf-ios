//
//  DataSourceDelegate.h
//  SF iOS
//
//  Created by Roderic Campbell on 4/17/19.
//

#ifndef DataSourceDelegate_h
#define DataSourceDelegate_h

#import "FeedProvider.h"

@protocol FeedProviderDelegate
- (void)willUpdateDataSource:(nonnull id<FeedProvider> )datasource;

- (void)didChangeDataSource:(nonnull id<FeedProvider> )datasource
             withInsertions:(nullable NSArray <NSIndexPath *> *)insertions
                    updates:(nullable NSArray <NSIndexPath *> *)updates
                  deletions:(nullable NSArray <NSIndexPath *> *)deletions;

- (void)didFailToUpdateDataSource:(nonnull id<FeedProvider> )datasource
                        withError:(NSError *_Nonnull)error;
@end

#endif /* DataSourceDelegate_h */
