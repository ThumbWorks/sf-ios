//
//  BasicTextCollectionViewCell.h
//  Coffup
//
//  Created by Roderic Campbell on 4/18/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BasicTextCollectionViewCell : UICollectionViewCell
+ (NSString *)reuseID;
- (void)updateWithTitle:(NSString *)title;
@end

NS_ASSUME_NONNULL_END
