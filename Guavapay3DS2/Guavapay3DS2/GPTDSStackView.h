//
//  GPTDSStackView.h
//  Guavapay3DS2
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, GPTDSStackViewLayoutAxis) {
    
    /// A horizontal layout for the stack view to use.
    GPTDSStackViewLayoutAxisHorizontal = 0,
    
    /// A vertical layout for the stack view to use.
    GPTDSStackViewLayoutAxisVertical = 1,
};

@interface GPTDSStackView: UIView

/**
 Initializes an `GPTDSStackView`.

 @param alignment The alignment for the stack view to use.
 @return An initialized `GPTDSStackView`.
 */
- (instancetype)initWithAlignment:(GPTDSStackViewLayoutAxis)alignment;

/**
 Adds a subview to the list of arranged subviews. Views will be displayed in the order they are added.

 @param view The view to add to the stack view.
 */
- (void)addArrangedSubview:(UIView *)view;

/**
 Removes a subview from the list of arranged subviews.
 
 @param view The view to remove.
 */
- (void)removeArrangedSubview:(UIView *)view;

/**
 Adds a spacer that fits the layout axis of the `GPTDSStackView`.

 @param dimension How wide or tall the spacer should be, depending on the axis of the `GPTDSStackView`.
 @note Spacers added through this function will not be removed or hidden automatically when they no longer fall between two views. For more precise interactions, add an `GPTDSSpacerView` manually through `addArrangedSubview:`.
 */
- (void)addSpacer:(CGFloat)dimension;

/**
 Adds a horizontal line that fits the layout axis of the `GPTDSStackView`.

 @param inset horizontal insets from parent `GPTDSStackView`
 */
- (void)addLine:(CGFloat)inset;

@end

NS_ASSUME_NONNULL_END
