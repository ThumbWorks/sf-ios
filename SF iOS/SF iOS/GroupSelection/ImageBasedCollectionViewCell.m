//
//  ImageBasedCollectionViewCell.m
//  Coffup
//
//  Created by Roderic Campbell on 4/17/19.
//

#import "ImageBasedCollectionViewCell.h"
#import "Group.h"
#import "UIColor+SFiOSColors.h"

@interface ImageBasedCollectionViewCell()
@property (nonatomic) UIImageView *imageView;
@property (nonatomic) UILabel *nameLabel;
@property (nonatomic) UIView *shadowView;
@end

@implementation ImageBasedCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
        [self setupConstraints];
    }
    return self;
}

+ (UIFont *)labelFont {
    return [UIFont preferredFontForTextStyle:UIFontTextStyleTitle3];
}

- (void)setupViews {
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _imageView.translatesAutoresizingMaskIntoConstraints = false;
    _imageView.backgroundColor = [UIColor alabaster];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.layer.cornerRadius = 15;
    _imageView.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
    _imageView.layer.masksToBounds = true;

    self.shadowView = [UIView new];
    _shadowView.backgroundColor = [UIColor whiteColor];
    _shadowView.layer.cornerRadius = 15;
    _shadowView.layer.shadowColor = [UIColor blackColor].CGColor;
    _shadowView.layer.shadowOpacity = 0.22;
    _shadowView.layer.shadowRadius = 8;
    _shadowView.clipsToBounds = false;
    _shadowView.layer.shadowOffset = CGSizeMake(0, 4);
    _shadowView.translatesAutoresizingMaskIntoConstraints = false;
    [self.contentView addSubview:self.shadowView];

    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _nameLabel.translatesAutoresizingMaskIntoConstraints = false;
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.textColor = [UIColor blackColor];
    _nameLabel.backgroundColor = [UIColor whiteColor];
    _nameLabel.font = [ImageBasedCollectionViewCell labelFont];
    _nameLabel.layer.maskedCorners = kCALayerMinXMaxYCorner | kCALayerMaxXMaxYCorner;
    _nameLabel.layer.masksToBounds = true;
    _nameLabel.layer.cornerRadius = 15;
    _nameLabel.numberOfLines = 0;

    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.nameLabel];

    self.contentView.clipsToBounds = false;
}

- (void)setupConstraints {
    [NSLayoutConstraint activateConstraints:
     @[
       [self.imageView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor],
       [self.imageView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-44],
       [self.imageView.leftAnchor constraintEqualToAnchor:self.contentView.leftAnchor],
       [self.imageView.rightAnchor constraintEqualToAnchor:self.contentView.rightAnchor],

       [self.nameLabel.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor],
       [self.nameLabel.leftAnchor constraintEqualToAnchor:self.contentView.leftAnchor],
       [self.nameLabel.rightAnchor constraintEqualToAnchor:self.contentView.rightAnchor],
       [self.nameLabel.heightAnchor constraintGreaterThanOrEqualToConstant:44],

       [self.shadowView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor],
       [self.shadowView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor],
       [self.shadowView.leftAnchor constraintEqualToAnchor:self.contentView.leftAnchor],
       [self.shadowView.rightAnchor constraintEqualToAnchor:self.contentView.rightAnchor]
       ]
     ];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.imageView.image = nil;
    self.nameLabel.text = nil;
}

- (void)updateWithImage:(UIImage *)image title:(NSString *)title {
    self.imageView.image = image;
    self.nameLabel.text = title;
}

+ (NSString *)reuseID {
    return NSStringFromClass([self class]);
}
@end
