//
//  EARestrictedScrollView.h
//
//  Copyright (c) 2015 Evgeny Aleksandrov. License: MIT.

#import <UIKit/UIKit.h>

@interface EARestrictedScrollView : UIScrollView

/**
 *  This is the rect property which defines restriction area in coordinate space of `contentView`. Use CGRectZero to reset restriction.
 */
@property (nonatomic, assign) CGRect restrictionArea;


#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wproperty-attribute-mismatch"
/**
 *  When accessing this property with dot-notation - container offset will be used to calculate final value, so you can forget about implemetation details. Also lies in coordinate space of `contentView`.
 */
@property (nonatomic, assign, getter=alignedContentOffset, setter=setAlignedContentOffset:) CGPoint contentOffset;
#pragma GCC diagnostic pop

/**
 *  Should not be used, since it changes parent `contentOffset` that is being manipulated by subclass.
 */
- (void)setContentOffset:(CGPoint)contentOffset __attribute__((unavailable("use dot notation to access property")));

/**
 *  Should not be used, since it leads to parent `contentOffset` that is being manipulated by subclass.
 */
- (CGPoint)contentOffset __attribute__((unavailable("use dot notation to access property")));

@end
