//
//  GPTDSButtonCustomization.h
//  Guavapay3DS2
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "GPTDSCustomization.h"

/// An enum that defines the different types of buttons that are able to be customized.
typedef NS_ENUM(NSInteger, GPTDSUICustomizationButtonType) {
    
    /// The submit button type.
    GPTDSUICustomizationButtonTypeSubmit = 0,
    
    /// The continue button type.
    GPTDSUICustomizationButtonTypeContinue = 1,
    
    /// The next button type.
    GPTDSUICustomizationButtonTypeNext = 2,
    
    /// The cancel button type.
    GPTDSUICustomizationButtonTypeCancel = 3,
    
    /// The resend button type.
    GPTDSUICustomizationButtonTypeResend = 4,
};

/// An enumeration of the case transformations that can be applied to the button's title
typedef NS_ENUM(NSInteger, GPTDSButtonTitleStyle) {
    /// Default style, doesn't modify the title
    GPTDSButtonTitleStyleDefault,
    
    /// Applies localizedUppercaseString to the title
    GPTDSButtonTitleStyleUppercase,
    
    /// Applies localizedLowercaseString to the title
    GPTDSButtonTitleStyleLowercase,
    
    /// Applies localizedCapitalizedString to the title
    GPTDSButtonTitleStyleSentenceCapitalized,
};

NS_ASSUME_NONNULL_BEGIN

/// A customization object to use to configure the UI of a button.
@interface GPTDSButtonCustomization: GPTDSCustomization

/// The default settings for the provided button type.
+ (instancetype)defaultSettingsForButtonType:(GPTDSUICustomizationButtonType)type;

/**
 Initializes an instance of GPTDSButtonCustomization with the given backgroundColor and colorRadius.
 */
- (instancetype)initWithBackgroundColor:(UIColor *)backgroundColor cornerRadius:(CGFloat)cornerRadius;

/**
 This is unavailable because there are no sensible default property values without a button type.
 Use `defaultSettingsForButtonType:` or `initWithBackgroundColor:cornerRadius:` instead.
 */
- (instancetype)init NS_UNAVAILABLE;

/**
 The background color of the button.
 The default for .resend and .cancel is clear.
 The default for .submit, .continue, and .next is blue.
 */
@property (nonatomic) UIColor *backgroundColor;

/// The corner radius of the button. Defaults to 8.
@property (nonatomic) CGFloat cornerRadius;

/**
 The capitalization style of the button title
 */
@property (nonatomic) GPTDSButtonTitleStyle titleStyle;

@end

NS_ASSUME_NONNULL_END
