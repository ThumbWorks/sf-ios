//
//  GroupCollectionView.m
//  Coffup
//
//  Created by Roderic Campbell on 5/8/19.
//

#import "GroupCollectionView.h"

@implementation GroupCollectionView

+ (GroupCollectionView *)view {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20);
    layout.minimumInteritemSpacing = 8.0;

    GroupCollectionView *view = [[self alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    view.backgroundColor = [UIColor whiteColor];
    view.showsHorizontalScrollIndicator = false;
    view.translatesAutoresizingMaskIntoConstraints = false;

    return view;
}

@end
