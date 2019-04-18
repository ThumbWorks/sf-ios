//
//  GroupCollectionViewController.m
//  Coffup
//
//  Created by Roderic Campbell on 4/18/19.
//

#import <UIKit/UIKit.h>
#import "GroupCollectionViewController.h"
#import "GroupDataSource.h"
#import "Group.h"
#import "FeedProvider.h"
#import "BasicTextCollectionViewCell.h"
#import "ImageStore.h"
#import "UIImage+URL.h"

@interface GroupCollectionViewController() <UICollectionViewDelegateFlowLayout>
@property(nonatomic) id<FeedProvider> dataSource;
@property(nonatomic) UICollectionView *collectionView;
@property(nonatomic) ImageStore *cache;
@property (nonatomic) NSOperationQueue *imageFetchQueue;
@end

@implementation GroupCollectionViewController

- (instancetype)initWithDataSource:(id<FeedProvider>)dataSource collectionView:(UICollectionView *)collectionView {
    self = [super init];
    if (self) {
        // set the delegate outside of this scope probably
        _dataSource = dataSource;
        _collectionView = collectionView;
        _imageFetchQueue = [[NSOperationQueue alloc] init];
    }
    return self;
}

- (void)didChangeDataSourceWithInsertions:(nullable NSArray<NSIndexPath *> *)insertions updates:(nullable NSArray<NSIndexPath *> *)updates deletions:(nullable NSArray<NSIndexPath *> *)deletions {
    [self.collectionView performBatchUpdates:^{
        [self.collectionView insertItemsAtIndexPaths:insertions];
        [self.collectionView reloadItemsAtIndexPaths:updates];
        [self.collectionView deleteItemsAtIndexPaths:deletions];
    } completion:^(BOOL finished) {
        NSLog(@"done");
    }];
}

- (void)didFailToUpdateWithError:(NSError * _Nonnull)error {
    NSLog(@"we got an error %@", [error localizedDescription]);
}

- (void)willUpdateDataSource:(nonnull id<FeedProvider>)datasource {
    // no op
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    Group *group = [((GroupDataSource *)self.dataSource) groupAtIndex:indexPath.row];
    UIFont *font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    CGSize size = [group.name sizeWithAttributes:@{NSFontAttributeName:font}];
    NSLog(@"Size %@", NSStringFromCGSize(size));
    return CGSizeMake(size.width + 10, size.height + 10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 8.0;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    BasicTextCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[BasicTextCollectionViewCell reuseID] forIndexPath:indexPath];
    Group *group = [((GroupDataSource *)self.dataSource) groupAtIndex:indexPath.row];
    [cell updateWithTitle:group.name];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.numberOfItems;
}

@end
