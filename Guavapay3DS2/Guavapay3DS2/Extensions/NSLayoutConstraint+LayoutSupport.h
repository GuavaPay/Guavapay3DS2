//
//  NSLayoutConstraint+LayoutSupport.h
//  Guavapay3DS2
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSLayoutConstraint (LayoutSupport)

/**
 Provides an NSLayoutConstraint where the `NSLayoutAttributeTop` is equal for both views, with a multiplier of 1, and a constant of 0.
 
 @param view1 The view to constrain.
 @param view2 The view to constraint to.
 @return An NSLayoutConstraint that is constraining the first view to the second at the top.
 */
+ (NSLayoutConstraint *)_gptds_topConstraintWithItem:(id)view1 toItem:(id)view2;

/**
 Provides an NSLayoutConstraint where the `NSLayoutAttributeLeft` is equal for both views, with a multiplier of 1, and a constant of 0.
 
 @param view1 The view to constrain.
 @param view2 The view to constraint to.
 @return An NSLayoutConstraint that is constraining the first view to the second on the left.
 */
+ (NSLayoutConstraint *)_gptds_leftConstraintWithItem:(id)view1 toItem:(id)view2;

/**
 Provides an NSLayoutConstraint where the `NSLayoutAttributeRight` is equal for both views, with a multiplier of 1, and a constant of 0.
 
 @param view1 The view to constrain.
 @param view2 The view to constraint to.
 @return An NSLayoutConstraint that is constraining the first view to the second on the right.
 */
+ (NSLayoutConstraint *)_gptds_rightConstraintWithItem:(id)view1 toItem:(id)view2;

/**
 Provides an NSLayoutConstraint where the `NSLayoutAttributeBottom` is equal for both views, with a multiplier of 1, and a constant of 0.
 
 @param view1 The view to constrain.
 @param view2 The view to constraint to.
 @return An NSLayoutConstraint that is constraining the first view to the second at the bottom.
 */
+ (NSLayoutConstraint *)_gptds_bottomConstraintWithItem:(id)view1 toItem:(id)view2;

@end

NS_ASSUME_NONNULL_END
