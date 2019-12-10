//
//  ImageBasedCollectionViewCell.m
//  Coffup
//
//  Created by Roderic Campbell on 4/17/19.
//

#import "ImageBasedCollectionViewCell.h"
#import "Group.h"
#import "Style.h"

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

- (void)setupViews {
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _imageView.translatesAutoresizingMaskIntoConstraints = false;
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.layer.cornerRadius = 15;
    _imageView.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
    _imageView.layer.masksToBounds = true;

    self.shadowView = [UIView new];
    _shadowView.layer.cornerRadius = 15;
    _shadowView.layer.shadowOpacity = 0.35;
    _shadowView.layer.shadowRadius = 8;
    _shadowView.clipsToBounds = false;
    _shadowView.layer.shadowOffset = CGSizeMake(0, 4);
    _shadowView.translatesAutoresizingMaskIntoConstraints = false;
    [self.contentView addSubview:self.shadowView];

    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _nameLabel.translatesAutoresizingMaskIntoConstraints = false;
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.backgroundColor = [UIColor clearColor];
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

- (void)applyStyle:(id<Style>)style {
	self.backgroundColor = style.colors.backgroundColor;
	self.imageView.backgroundColor = style.colors.loadingColor;
	self.nameLabel.textColor = style.colors.primaryTextColor;
	self.shadowView.backgroundColor = style.colors.backgroundColor;
	self.shadowView.layer.shadowColor = style.colors.shadowColor.CGColor;

	self.nameLabel.font = style.fonts.subtitleFont;
}

- (void)setHighlighted:(BOOL)highlighted {
    AnimationHelper *animator = [AnimationHelper alloc];
    [animator transformSelected:self.layer highlighted:highlighted];
}

+ (NSString *)reuseID {
    return NSStringFromClass([self class]);
}
@end
