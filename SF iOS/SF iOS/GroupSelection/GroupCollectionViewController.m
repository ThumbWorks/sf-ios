//
//  GroupCollectionViewController.m
//  Coffup
//
//  Created by Roderic Campbell on 4/18/19.
//

#import <UIKit/UIKit.h>
#import "FeedProvider.h"
#import "Group.h"
#import "GroupCollectionView.h"
#import "GroupCollectionViewController.h"
#import "GroupDataSource.h"
#import "ImageBasedCollectionViewCell.h"
#import "ImageStore.h"
#import "Style.h"
#import "UIActivityViewController+Utilities.h"
#import "UIImage+URL.h"
#import "UIViewController+ErrorHandling.h"

@interface GroupCollectionViewController() <UICollectionViewDelegateFlowLayout>
@property(nonatomic) id<FeedProvider> dataSource;
@property(nonatomic) GroupCollectionView *collectionView;
@property(nonatomic) ImageStore *cache;
@property (nonatomic) NSOperationQueue *imageFetchQueue;
@property (nonatomic) id<Style> style;
@end

@implementation GroupCollectionViewController

- (instancetype)initWithDataSource:(id<FeedProvider>)dataSource {
    self = [super init];
    if (self) {
        // set the delegate outside of this scope probably
        _dataSource = dataSource;
        _cache = [[ImageStore alloc] init];
        _collectionView = [GroupCollectionView view];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _imageFetchQueue = [[NSOperationQueue alloc] init];
        self.title = NSLocalizedString(@"Groups", @"Groups view title");
        [_collectionView registerClass:[ImageBasedCollectionViewCell class]
            forCellWithReuseIdentifier:[ImageBasedCollectionViewCell reuseID]];
    }
    return self;
}

- (void)loadView {
    self.view = self.collectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                                           target:self
                                                                                           action:@selector(share)];
}

- (void)share {
    UIActivityViewController *shareSheet = [[UIActivityViewController alloc] shareApp];
    
    [self presentViewController:shareSheet animated:true completion:nil];
}

// MARK: - FeedProviderDelegate
- (void)didChangeDataSource:(nonnull id<FeedProvider>)datasource withInsertions:(nullable NSArray<NSIndexPath *> *)insertions updates:(nullable NSArray<NSIndexPath *> *)updates deletions:(nullable NSArray<NSIndexPath *> *)deletions {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView performBatchUpdates:^{
            [self.collectionView insertItemsAtIndexPaths:insertions];
            [self.collectionView reloadItemsAtIndexPaths:updates];
            [self.collectionView deleteItemsAtIndexPaths:deletions];
        } completion:nil];
    });
}

- (void)didFailToUpdateDataSource:(nonnull id<FeedProvider>)datasource withError:(NSError * _Nonnull)error {
    [self handleError:error];
}

- (void)willUpdateDataSource:(nonnull id<FeedProvider>)datasource {
    // no op
}

// MARK: - UICollectionView
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(collectionView.bounds.size.width / 2 - 20, 200);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    Group *group = [((GroupDataSource *)self.dataSource) groupAtIndex:indexPath.row];
    [self.selectionDelegate controller:self tappedGroup:group];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 8.0;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ImageBasedCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[ImageBasedCollectionViewCell reuseID] forIndexPath:indexPath];
    Group *group = [((GroupDataSource *)self.dataSource) groupAtIndex:indexPath.row];
    UIImage *image = [self.cache imageForKey:group.imageURLString];
    if (image) {
        [cell updateWithImage:image title:group.name];
    } else {
        __weak typeof(self) welf = self;

        [UIImage
         fetchImageFromURL:[NSURL URLWithString:group.imageURLString]
         onQueue: self.imageFetchQueue
         withCompletionHandler:^(UIImage * _Nullable image, NSError * _Nullable error) {
             if (!image || error) {
                 NSLog(@"Error decoding image: %@", error);
                 return;
             }
             [welf.cache storeImage:image forKey:group.imageURLString];

             // Fetch the cell again, if it exists as the original instance of cell might have been
             // dequeued by now. If the cell does not exist, setting the image will silently fail.
             ImageBasedCollectionViewCell *fetchedCell = (ImageBasedCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
             [fetchedCell updateWithImage:image title:group.name];
         }];
    }
	[cell applyStyle:self.style];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.numberOfItems;
}

#pragma mark - Styleable

- (void)applyStyle:(id<Style>)style {
	self.style = style;
	self.collectionView.backgroundColor = self.style.colors.backgroundColor;

	[self.collectionView reloadData];
}

@end
