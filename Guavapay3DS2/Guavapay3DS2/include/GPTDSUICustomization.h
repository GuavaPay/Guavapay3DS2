//
//  GPTDSUICustomization.h
//  Guavapay3DS2
//

#import <Foundation/Foundation.h>
#import "GPTDSCustomization.h"
#import "GPTDSButtonCustomization.h"
#import "GPTDSNavigationBarCustomization.h"
#import "GPTDSLabelCustomization.h"
#import "GPTDSTextFieldCustomization.h"
#import "GPTDSFooterCustomization.h"
#import "GPTDSSelectionCustomization.h"

NS_ASSUME_NONNULL_BEGIN

/**
 The `GPTDSUICustomization` provides configuration for UI elements.
 
 It's important to configure this object appropriately before using it to initialize a
 `GPTDSThreeDS2Service` object. `GPTDSThreeDS2Service` makes a copy of the customization
 settings you provide; it ignores any subsequent changes you make to your `GPTDSUICustomization` instance.
*/
@interface GPTDSUICustomization: NSObject <NSCopying>

/// The default settings.  See individual properties for their default values.
+ (instancetype)defaultSettings;

/**
 Provides custom settings for the UINavigationBar of all UIViewControllers the SDK display.
 The default is `[GPTDSNavigationBarCustomization defaultSettings]`.
 */
@property (nonatomic) GPTDSNavigationBarCustomization *navigationBarCustomization;

/**
 Provides custom settings for labels.
 The default is `[GPTDSLabelCustomization defaultSettings]`.
 */
@property (nonatomic) GPTDSLabelCustomization *labelCustomization;

/**
 Provides custom settings for text fields.
 The default is `[GPTDSTextFieldCustomization defaultSettings]`.
 */
@property (nonatomic) GPTDSTextFieldCustomization *textFieldCustomization;

/**
 The primary background color of all UIViewControllers the SDK display.
 Defaults to white.
 */
@property (nonatomic) UIColor *backgroundColor;

/**
 The Challenge view displays a footer with additional details.  This controls the background color of that view.
 Defaults to gray.
 */
@property (nonatomic) GPTDSFooterCustomization *footerCustomization;

/**
 Sets a given button customization for the specified type.
 
 @param buttonCustomization The buttom customization to use.
 @param buttonType The type of button to use the customization for.
 */
- (void)setButtonCustomization:(GPTDSButtonCustomization *)buttonCustomization forType:(GPTDSUICustomizationButtonType)buttonType;

/**
 Retrieves a button customization object for the given button type.

 @param buttonType The button type to retrieve a customization object for.
 @return A button customization object, or the default if none was set.
 @see GPTDSButtonCustomization
 */
- (GPTDSButtonCustomization *)buttonCustomizationForButtonType:(GPTDSUICustomizationButtonType)buttonType;

/**
 Provides custom settings for radio buttons and checkboxes.
 The default is `[GPTDSSelectionCustomization defaultSettings]`.
 */
@property (nonatomic) GPTDSSelectionCustomization *selectionCustomization;


/**
 The preferred status bar style for all UIViewControllers the SDK display.
 Defaults to UIStatusBarStyleDefault.
 */
@property (nonatomic) UIStatusBarStyle preferredStatusBarStyle;

#pragma mark - Progress View

/**
 The style of UIActivityIndicatorViews displayed.
 This should contrast with `backgroundColor`.  Defaults to regular on iOS 13+,
 gray on iOS 10-12.
 */
@property (nonatomic) UIActivityIndicatorViewStyle activityIndicatorViewStyle;

/**
 The style of the UIBlurEffect displayed underneath the UIActivityIndicatorView.
 Defaults to UIBlurEffectStyleDefault.
 */
@property (nonatomic) UIBlurEffectStyle blurStyle;

@end

NS_ASSUME_NONNULL_END
