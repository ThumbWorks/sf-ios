//
//  GroupSelectionTableViewCell.m
//  Coffup
//
//  Created by Roderic Campbell on 4/18/19.
//

#import "GroupSelectionTableViewCell.h"
#import "ImageBasedCollectionViewCell.h"

@interface GroupSelectionTableViewCell()
@property (nonatomic) UICollectionView *collectionView;
@end

@implementation GroupSelectionTableViewCell

- (instancetype)init {
    self = [super init];
    if (self) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero];
        _collectionView.translatesAutoresizingMaskIntoConstraints = false;
        [self.contentView addSubview:_collectionView];
        [_collectionView.topAnchor constraintGreaterThanOrEqualToAnchor:self.contentView.topAnchor].active = true;
        [_collectionView.bottomAnchor constraintGreaterThanOrEqualToAnchor:self.contentView.bottomAnchor].active = true;
        [_collectionView.leftAnchor constraintGreaterThanOrEqualToAnchor:self.contentView.leftAnchor].active = true;
        [_collectionView.rightAnchor constraintGreaterThanOrEqualToAnchor:self.contentView.rightAnchor].active = true;
        [_collectionView registerClass:[ImageBasedCollectionViewCell class] forCellWithReuseIdentifier:[ImageBasedCollectionViewCell reuseID]];
    }
    return self;
}

@end
