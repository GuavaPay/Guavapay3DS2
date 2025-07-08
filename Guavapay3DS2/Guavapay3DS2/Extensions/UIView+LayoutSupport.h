//
//  UIView+LayoutSupport.h
//  Guavapay3DS2
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (LayoutSupport)

/**
 Pins the view to its superview's bounds.
 */
- (void)_gptds_pinToSuperviewBounds;

- (void)_gptds_pinToSuperviewBoundsWithoutMargin;

@end

NS_ASSUME_NONNULL_END
