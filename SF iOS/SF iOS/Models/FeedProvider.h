//
//  FeedProvider.h
//  SF iOS
//
//  Created by Roderic Campbell on 4/17/19.
//

#ifndef FeedProvider_h
#define FeedProvider_h

@protocol FeedProvider
@property (nonatomic, readonly, assign) NSUInteger numberOfItems;
@property (nonatomic, readonly, assign) NSUInteger indexOfCurrentItem;
- (void)refresh;
@end


#endif /* FeedProvider_h */
