//
//  UIButton+CustomInitialization.m
//  Guavapay3DS2
//

#import "UIButton+CustomInitialization.h"
#import "GPTDSVisionSupport.h"

NS_ASSUME_NONNULL_BEGIN

@implementation UIButton (CustomInitialization)

#if !STP_TARGET_VISION
static const CGFloat kDefaultButtonContentInset = (CGFloat)18.0;
#endif

+ (UIButton *)_gptds_buttonWithTitle:(NSString * _Nullable)title customization:(GPTDSButtonCustomization * _Nullable)customization {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.clipsToBounds = YES;
#if !STP_TARGET_VISION // UIButton edge insets not supported on visionOS
    button.contentEdgeInsets = UIEdgeInsetsMake(kDefaultButtonContentInset, 0, kDefaultButtonContentInset, 0);
#endif
    [[self class] _gptds_configureButton:button withTitle:title customization:customization];

    return button;
}

+ (void)_gptds_configureButton:(UIButton *)button withTitle:(NSString * _Nullable)buttonTitle customization:(GPTDSButtonCustomization *  _Nullable)buttonCustomization {
    button.backgroundColor = buttonCustomization.backgroundColor;
    button.layer.cornerRadius = buttonCustomization.cornerRadius;

    UIFont *font = buttonCustomization.font;
    UIColor *textColor = buttonCustomization.textColor;

    if (buttonTitle != nil) {
        NSMutableDictionary *attributesDictionary = [NSMutableDictionary dictionary];

        if (font != nil) {
            attributesDictionary[NSFontAttributeName] = font;
        }

        if (textColor != nil) {
            attributesDictionary[NSForegroundColorAttributeName] = textColor;
        }
        switch (buttonCustomization.titleStyle) {
            case GPTDSButtonTitleStyleDefault:
                break;
            case GPTDSButtonTitleStyleSentenceCapitalized:
                buttonTitle = [buttonTitle localizedCapitalizedString];
                break;
            case GPTDSButtonTitleStyleLowercase:
                buttonTitle = [buttonTitle localizedLowercaseString];
                break;
            case GPTDSButtonTitleStyleUppercase:
                buttonTitle = [buttonTitle localizedUppercaseString];
                break;
        }

        NSAttributedString *title = [[NSAttributedString alloc] initWithString:buttonTitle attributes:attributesDictionary];
        [button setAttributedTitle:title forState:UIControlStateNormal];

        // Set disabled state title color to light gray
        UIColor *disabledColor = [UIColor lightGrayColor];
        NSMutableDictionary *disabledAttributes = [NSMutableDictionary dictionary];
        if (font != nil) {
            disabledAttributes[NSFontAttributeName] = font;
        }
        disabledAttributes[NSForegroundColorAttributeName] = disabledColor;
        NSAttributedString *disabledTitle = [[NSAttributedString alloc] initWithString:buttonTitle attributes:disabledAttributes];
        [button setAttributedTitle:disabledTitle forState:UIControlStateDisabled];
    }
}

@end

NS_ASSUME_NONNULL_END
