//
//  GPTDSButtonCustomization.m
//  Guavapay3DS2
//

#import "GPTDSButtonCustomization.h"

#import "GPTDSUICustomization.h"
#import "UIColor+DefaultColors.h"
#import "UIFont+DefaultFonts.h"

static const CGFloat kDefaultButtonCornerRadius = 8.0;
static const CGFloat kDefaultButtonFontScale = (CGFloat)1.0;

NS_ASSUME_NONNULL_BEGIN

@implementation GPTDSButtonCustomization

+ (instancetype)defaultSettingsForButtonType:(GPTDSUICustomizationButtonType)type {
    UIColor *backgroundColor = [UIColor _gptds_backgroundBrandColor];
    CGFloat cornerRadius = kDefaultButtonCornerRadius;
    UIFont *font = [UIFont _gptds_defaultBoldLabelTextFontWithScale:kDefaultButtonFontScale];
    UIColor *textColor = [UIColor _gptds_foregroundBrandColor];
    switch (type) {
        case GPTDSUICustomizationButtonTypeContinue:
        case GPTDSUICustomizationButtonTypeSubmit:
        case GPTDSUICustomizationButtonTypeNext:
            break;
        case GPTDSUICustomizationButtonTypeResend:
            backgroundColor = UIColor.clearColor;
            textColor = [UIColor _gptds_buttonGhostLinkColor];
            break;
        case GPTDSUICustomizationButtonTypeCancel:
            backgroundColor = UIColor.clearColor;
            textColor = nil;
            font = nil;
            break;
    }
    GPTDSButtonCustomization *buttonCustomization = [[self alloc] initWithBackgroundColor:backgroundColor cornerRadius:cornerRadius];
    buttonCustomization.font = font;
    buttonCustomization.textColor = textColor;
    return buttonCustomization;
}

- (instancetype)initWithBackgroundColor:(UIColor *)backgroundColor cornerRadius:(CGFloat)cornerRadius {
    self = [super init];
    if (self) {
        _backgroundColor = backgroundColor;
        _cornerRadius = cornerRadius;
    }
    return self;
}

- (id)copyWithZone:(nullable NSZone *)zone {
    GPTDSButtonCustomization *copy = [super copyWithZone:zone];
    copy.backgroundColor = self.backgroundColor;
    copy.cornerRadius = self.cornerRadius;
    copy.titleStyle = self.titleStyle;
    
    return copy;
}

@end

NS_ASSUME_NONNULL_END
