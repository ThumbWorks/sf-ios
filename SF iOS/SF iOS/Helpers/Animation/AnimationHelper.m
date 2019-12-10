//
//  AnimationHelper.m
//  Coffup
//
//  Created by Michael Miles on 12/9/19.
//

#import "AnimationHelper.h"

@implementation AnimationHelper

- (void)transformSelected:(CALayer *)layer highlighted:(BOOL)isHighlighted {
    const CATransform3D transformFromValue = layer.transform;
    const CGFloat radiusFromValue = layer.shadowRadius;
    const CGSize offsetFromValue = layer.shadowOffset;

    if (isHighlighted) {
      layer.transform = CATransform3DMakeScale(0.98, 0.98, 1.0);
      layer.shadowRadius = 4;
      layer.shadowOffset = CGSizeMake(0, 0);
    } else {
      layer.transform = CATransform3DIdentity;
      layer.shadowRadius = 8;
      layer.shadowOffset = CGSizeMake(0, 8);
    }

    [layer addAnimation:AnimationWithKeyPath(@"transform", [NSValue valueWithCATransform3D:transformFromValue]) forKey:@"transform"];
    [layer addAnimation:AnimationWithKeyPath(@"shadowRadius", @(radiusFromValue)) forKey:@"shadowRadius"];
    [layer addAnimation:AnimationWithKeyPath(@"shadowOffset", [NSValue valueWithCGSize:offsetFromValue]) forKey:@"shadowOffset"];
}

static CABasicAnimation *AnimationWithKeyPath(NSString *keyPath, NSValue *fromValue) {
  CABasicAnimation *const animation = [CABasicAnimation animationWithKeyPath:keyPath];
  animation.duration = 0.1;
  animation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.0 :0.0 :0.5 :2.0];
  animation.fromValue = fromValue;
  return animation;
}

@end
