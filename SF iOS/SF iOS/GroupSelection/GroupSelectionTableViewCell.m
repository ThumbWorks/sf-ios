//
//  GroupSelectionTableViewCell.m
//  Coffup
//
//  Created by Roderic Campbell on 4/18/19.
//

#import "GroupSelectionTableViewCell.h"
#import "BasicTextCollectionViewCell.h"

@interface GroupSelectionTableViewCell()
@property (nonatomic) UICollectionView *collectionView;
@end

@implementation GroupSelectionTableViewCell

- (void)setupConstraints {
    [self.collectionView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant: 20].active = true;
    [self.collectionView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant: -20].active = true;
    [self.collectionView.leftAnchor constraintEqualToAnchor:self.contentView.leftAnchor].active = true;
    [self.collectionView.rightAnchor constraintEqualToAnchor:self.contentView.rightAnchor].active = true;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20);
        layout.minimumInteritemSpacing = 8.0;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                             collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsHorizontalScrollIndicator = false;
        _collectionView.translatesAutoresizingMaskIntoConstraints = false;
        [self.contentView addSubview:_collectionView];
        [self setupConstraints];
        [_collectionView registerClass:[BasicTextCollectionViewCell class]
            forCellWithReuseIdentifier:[BasicTextCollectionViewCell reuseID]];
    }
    return self;
}

@end
