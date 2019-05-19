//
//  Styleable.h
//  Coffup
//
//  Created by Zachary Drayer on 5/18/19.
//

#import <Foundation/Foundation.h>

@protocol Style;


@protocol Styleable <NSObject>

- (void)applyStyle:(id<Style>)style;

@end
