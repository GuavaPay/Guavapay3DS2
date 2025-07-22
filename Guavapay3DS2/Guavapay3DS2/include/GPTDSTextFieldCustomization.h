//
//  GPTDSTextFieldCustomization.h
//  Guavapay3DS2
//

#import <UIKit/UIKit.h>

#import "GPTDSCustomization.h"

NS_ASSUME_NONNULL_BEGIN

/**
 A customization object to use to configure the UI of a text field.

 The font and textColor inherited from `GPTDSCustomization` configure
 the user input text.
 */
@interface GPTDSTextFieldCustomization : GPTDSCustomization

/**
 The default settings.
 
 The default textColor is black.
 */
+ (instancetype)defaultSettings;

/// The border width of the text field. Defaults to 2.
@property (nonatomic) CGFloat borderWidth;

/// The color of the border of the text field. Defaults to clear.
@property (nonatomic) UIColor *borderColor;

/// The corner radius of the edges of the text field. Defaults to 8.
@property (nonatomic) CGFloat cornerRadius;

/// The appearance of the keyboard. Defaults to UIKeyboardAppearanceDefault.
@property (nonatomic) UIKeyboardAppearance keyboardAppearance;

/// The color of the placeholder text. Defaults to light gray.
@property (nonatomic) UIColor *placeholderTextColor;

/// The text for the placeholder. Default is empty.
@property (nonatomic) NSString *placeholderText;

@end

NS_ASSUME_NONNULL_END
