//
//  FeedProvider.h
//  SF iOS
//
//  Created by Roderic Campbell on 4/17/19.
//

#ifndef FeedProvider_h
#define FeedProvider_h

@protocol FeedProvider <NSObject>
@property (nonatomic, readonly, assign) NSUInteger numberOfItems;
- (void)refresh;
@end


#endif /* FeedProvider_h */
