//
//  GroupCollectionViewController.h
//  Coffup
//
//  Created by Roderic Campbell on 4/18/19.
//

#import <Foundation/Foundation.h>
#import "FeedProvider.h"
#import "FeedProviderDelegate.h"
NS_ASSUME_NONNULL_BEGIN

@interface GroupCollectionViewController : NSObject <FeedProviderDelegate, UICollectionViewDataSource>
- (instancetype)initWithDataSource:(id<FeedProvider>)dataSource collectionView:(UICollectionView *)collectionView;
@end

NS_ASSUME_NONNULL_END
