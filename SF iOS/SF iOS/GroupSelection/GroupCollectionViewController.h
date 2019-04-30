//
//  GroupCollectionViewController.h
//  Coffup
//
//  Created by Roderic Campbell on 4/18/19.
//

#import <Foundation/Foundation.h>
#import "FeedProvider.h"
#import "FeedProviderDelegate.h"
@class Group;
@class GroupCollectionViewController;

NS_ASSUME_NONNULL_BEGIN

@protocol GroupCollectionViewControllerDelegate <NSObject>

- (void)controller:(GroupCollectionViewController *)controller tappedGroup:(Group *)group;

@end

@interface GroupCollectionViewController : NSObject <FeedProviderDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
- (instancetype)initWithDataSource:(id<FeedProvider>)dataSource collectionView:(UICollectionView *)collectionView;
@property (nonatomic, weak) id<GroupCollectionViewControllerDelegate> selectionDelegate;

@end

NS_ASSUME_NONNULL_END
