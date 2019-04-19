//
//  BasicTextCollectionViewCell.m
//  Coffup
//
//  Created by Roderic Campbell on 4/18/19.
//

#import "BasicTextCollectionViewCell.h"

@interface BasicTextCollectionViewCell()
@property (nonatomic) UILabel *nameLabel;
@property (nonatomic) UIView *shadowView;
@end

@implementation BasicTextCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
        [self setupConstraints];
    }
    return self;
}

+ (UIFont *)labelFont {
    return [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
}

- (void)setupViews {
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _nameLabel.translatesAutoresizingMaskIntoConstraints = false;
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.textColor = UIColor.blackColor;
    _nameLabel.backgroundColor = UIColor.whiteColor;
    _nameLabel.font = [BasicTextCollectionViewCell labelFont];

    self.shadowView = [UIView new];
    _shadowView.backgroundColor = [UIColor whiteColor];
    _shadowView.layer.cornerRadius = 15;
    _shadowView.layer.shadowColor = [UIColor blackColor].CGColor;
    _shadowView.layer.shadowOpacity = 0.22;
    _shadowView.layer.shadowOffset = CGSizeMake(0, 2);
    _shadowView.clipsToBounds = false;
    _shadowView.translatesAutoresizingMaskIntoConstraints = false;
    [self.contentView addSubview:self.shadowView];
    [self.contentView addSubview:self.nameLabel];
}

- (void)setupConstraints {
    [self.shadowView.topAnchor constraintEqualToAnchor:self.nameLabel.topAnchor constant: -5].active = true;
    [self.shadowView.bottomAnchor constraintEqualToAnchor:self.nameLabel.bottomAnchor constant: 5].active = true;
    [self.shadowView.leftAnchor constraintEqualToAnchor:self.nameLabel.leftAnchor constant: -15].active = true;
    [self.shadowView.rightAnchor constraintEqualToAnchor:self.nameLabel.rightAnchor constant: 15].active = true;

    [self.nameLabel.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor].active = true;
    [self.nameLabel.centerXAnchor constraintEqualToAnchor:self.contentView.centerXAnchor].active = true;
}

- (void)updateWithTitle:(NSString *)title {
    self.nameLabel.text = title;
}

+ (NSString *)reuseID {
    return NSStringFromClass([self class]);
}
@end
