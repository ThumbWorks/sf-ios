//
//  ImageBasedCollectionViewCell.h
//  Coffup
//
//  Created by Roderic Campbell on 4/17/19.
//

#import <UIKit/UIKit.h>
#import "Styleable.h"

NS_ASSUME_NONNULL_BEGIN

@interface ImageBasedCollectionViewCell : UICollectionViewCell <Styleable>
- (void)updateWithImage:(UIImage *)image title:(NSString *)title;
+ (NSString *)reuseID;

@end

NS_ASSUME_NONNULL_END
