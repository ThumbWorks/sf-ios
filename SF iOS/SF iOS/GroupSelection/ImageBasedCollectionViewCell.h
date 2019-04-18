//
//  ImageBasedCollectionViewCell.h
//  Coffup
//
//  Created by Roderic Campbell on 4/17/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImageBasedCollectionViewCell : UICollectionViewCell
- (void)updateWithImage:(UIImage *)image title:(NSString *)title;
+ (NSString *)reuseID;
@end

NS_ASSUME_NONNULL_END
