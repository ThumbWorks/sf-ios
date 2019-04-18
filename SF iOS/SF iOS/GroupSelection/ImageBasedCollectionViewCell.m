//
//  ImageBasedCollectionViewCell.m
//  Coffup
//
//  Created by Roderic Campbell on 4/17/19.
//

#import "ImageBasedCollectionViewCell.h"
#import "Group.h"

@interface ImageBasedCollectionViewCell()
@property (nonatomic) UIImageView *imageView;
@property (nonatomic) UILabel *nameLabel;
@end

@implementation ImageBasedCollectionViewCell

- (instancetype)init {
    self = [super init];
    if (self) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.translatesAutoresizingMaskIntoConstraints = false;

        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.translatesAutoresizingMaskIntoConstraints = false;
        _nameLabel.textAlignment = NSTextAlignmentCenter;

        [self.contentView addSubview:_imageView];
        [self.contentView addSubview:_nameLabel];

        [_imageView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor].active = true;
        [_imageView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor].active = true;
        [_imageView.leftAnchor constraintEqualToAnchor:self.contentView.leftAnchor].active = true;
        [_imageView.rightAnchor constraintEqualToAnchor:self.contentView.rightAnchor].active = true;

        [_nameLabel.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor].active = true;
        [_nameLabel.leftAnchor constraintEqualToAnchor:self.contentView.leftAnchor].active = true;
        [_nameLabel.rightAnchor constraintEqualToAnchor:self.contentView.rightAnchor].active = true;
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.imageView.image = nil;
}

- (void)updateWithImage:(UIImage *)image title:(NSString *)title {
    self.imageView.image = image;
    self.nameLabel.text = title;
}

+ (NSString *)reuseID {
    return NSStringFromClass([self class]);
}
@end
