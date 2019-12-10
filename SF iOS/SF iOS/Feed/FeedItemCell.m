//
//  FeedItemCell.m
//  SF iOS
//
//  Created by Amit Jain on 7/31/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import "FeedItemCell.h"
#import "Style.h"
#import "UIStackView+ConvenienceInitializer.h"

static const CGFloat kDepressedShadowRadius = 8.0f;

NS_ASSUME_NONNULL_BEGIN
@interface FeedItemCell ()

@property (nonatomic) UIStackView *containerStack;
@property (nonatomic) UIView *detailStackContainer;
@property (nonatomic) UILabel *timeLabel;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *subtitleLabel;
@property (nonatomic) UIStackView *itemImageStack;
@property (nonatomic) UIImageView *coverImageView;

@property (nonatomic) BOOL isActive;

@end
NS_ASSUME_NONNULL_END

@implementation FeedItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (CGRect)contentFrame {
    UIView *superView = [self superview];
    if (!superView) {
        return CGRectZero;
    }

    // Return a frame that is based on the bounds and center (since the transform is not identity, you cannot base this on the frame)
    // "When the value of this property is anything other than the identity transform, the value in the frame property is undefined and should be ignored." - https://developer.apple.com/documentation/uikit/uiview/1622459-transform?language=objc
    // And also account for the shadow radius and offset
    const CGPoint center = CGPointMake(self.detailStackContainer.center.x, self.detailStackContainer.center.y + kDepressedShadowRadius);
    const CGFloat width = self.detailStackContainer.bounds.size.width + (kDepressedShadowRadius * 2.0);
    const CGFloat height = self.detailStackContainer.bounds.size.height + (kDepressedShadowRadius * 2.0);
    const CGRect newRect = CGRectMake(center.x - (width / 2.0), center.y - (height / 2.0), width, height);
    return [superView convertRect:newRect fromView:self.containerStack];
}

- (CGSize)coverImageSize {
    return self.itemImageStack.bounds.size;
}

//MARK: - Configuration

- (void)configureWithFeedItem:(FeedItem *)item {
	self.isActive = item.isActive;
    self.timeLabel.text = item.dateString;

    self.titleLabel.text = item.title;
    self.subtitleLabel.attributedText = item.subtitle;
}

- (void)setCoverToImage:(UIImage *)image {
    self.coverImageView.image = image;
}

//MARK: - Setup

- (void)setup {
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    [self setupContainerStack];
    
    self.timeLabel = [UILabel new];
    [self.timeLabel setTranslatesAutoresizingMaskIntoConstraints:false];
    [self.containerStack addArrangedSubview:self.timeLabel];
    
    [self setupDetailsStack];
}

- (void)setupContainerStack {
  self.containerStack = [[UIStackView alloc]
      initWithArrangedSubviews:nil
                          axis:UILayoutConstraintAxisVertical
                  distribution:UIStackViewDistributionFill
                     alignment:UIStackViewAlignmentFill
                       spacing:13
                       margins:UIEdgeInsetsMake(0, 20, 40, 20)];
  [self.contentView addSubview:self.containerStack];
  [self.containerStack setTranslatesAutoresizingMaskIntoConstraints:false];
  [[self.containerStack.leftAnchor
      constraintEqualToAnchor:self.contentView.leftAnchor] setActive:true];
  [[self.containerStack.rightAnchor
      constraintEqualToAnchor:self.contentView.rightAnchor] setActive:true];
  [[self.containerStack.topAnchor
      constraintEqualToAnchor:self.contentView.topAnchor] setActive:true];
  [[self.containerStack.bottomAnchor
      constraintEqualToAnchor:self.contentView.bottomAnchor] setActive:true];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.coverImageView.image = nil;
}

- (void)setupDetailsStack {
    CGFloat cornerRadius = 15;

	self.coverImageView = [UIImageView new];
    self.coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.coverImageView.layer.cornerRadius = cornerRadius;
	self.coverImageView.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;

    self.coverImageView.clipsToBounds = true;
    self.coverImageView.translatesAutoresizingMaskIntoConstraints = false;
    [self.coverImageView setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisVertical];

    self.itemImageStack = [[UIStackView alloc]
        initWithArrangedSubviews:@[ self.coverImageView ]
                            axis:UILayoutConstraintAxisVertical
                    distribution:UIStackViewDistributionFill
                       alignment:UIStackViewAlignmentFill
                         spacing:0
                         margins:UIEdgeInsetsZero];
    self.itemImageStack.translatesAutoresizingMaskIntoConstraints = false;
    
    self.titleLabel = [UILabel new];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = false;
    self.titleLabel.numberOfLines = 0;
    
    self.subtitleLabel = [UILabel new];
    self.subtitleLabel.numberOfLines = 2;
    self.subtitleLabel.translatesAutoresizingMaskIntoConstraints = false;

    UIStackView *titleStack = [[UIStackView alloc]
        initWithArrangedSubviews:@[ self.titleLabel, self.subtitleLabel ]
                            axis:UILayoutConstraintAxisVertical
                    distribution:UIStackViewDistributionEqualSpacing
                       alignment:UIStackViewAlignmentLeading
                         spacing:6
                         margins:UIEdgeInsetsMake(19, 19, 19, 19)];
    [titleStack
     setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh
     forAxis:UILayoutConstraintAxisVertical];

    UIStackView *detailsStack = [[UIStackView alloc]
        initWithArrangedSubviews:@[ self.itemImageStack, titleStack ]
                            axis:UILayoutConstraintAxisVertical
                    distribution:UIStackViewDistributionFill
                       alignment:UIStackViewAlignmentFill
                         spacing:0
                         margins:UIEdgeInsetsZero];
    detailsStack.translatesAutoresizingMaskIntoConstraints = false;
    
    self.detailStackContainer = [UIView new];
    self.detailStackContainer.layer.cornerRadius = 15;
	self.detailStackContainer.layer.shadowOpacity = 0.35;
    self.detailStackContainer.clipsToBounds = false;
    self.detailStackContainer.translatesAutoresizingMaskIntoConstraints = false;
    [self.detailStackContainer addSubview:detailsStack];
    [NSLayoutConstraint activateConstraints:
     @[
       [detailsStack.leftAnchor constraintEqualToAnchor:self.detailStackContainer.leftAnchor],
       [detailsStack.rightAnchor constraintEqualToAnchor:self.detailStackContainer.rightAnchor],
       [detailsStack.topAnchor constraintEqualToAnchor:self.detailStackContainer.topAnchor],
       [detailsStack.bottomAnchor constraintEqualToAnchor:self.detailStackContainer.bottomAnchor]
       ]
     ];
    
    [self.containerStack addArrangedSubview:self.detailStackContainer];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    AnimationHelper *animator = [AnimationHelper alloc];
    [animator transformSelected:self.detailStackContainer.layer highlighted:highlighted];
}

- (void)applyStyle:(id<Style>)style {
	self.contentView.backgroundColor = style.colors.backgroundColor;

	if (self.isActive) {
		self.titleLabel.textColor = style.colors.primaryTextColor;
		self.timeLabel.textColor = style.colors.primaryTextColor;
	} else {
		self.titleLabel.textColor = style.colors.inactiveTextColor;
		self.timeLabel.textColor = style.colors.inactiveTextColor;
	}

	self.coverImageView.backgroundColor = style.colors.loadingColor;
	self.subtitleLabel.textColor = style.colors.secondaryTextColor;
	self.detailStackContainer.backgroundColor = style.colors.backgroundColor;
	self.detailStackContainer.layer.shadowColor = style.colors.shadowColor.CGColor;

	self.timeLabel.font = style.fonts.primaryFont;
	self.titleLabel.font = style.fonts.secondaryFont;
	self.subtitleLabel.font = style.fonts.subtitleFont;
}

@end
