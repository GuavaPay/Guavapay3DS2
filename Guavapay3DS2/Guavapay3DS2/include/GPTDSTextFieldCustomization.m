//
//  GPTDSTextFieldCustomization.m
//  Guavapay3DS2
//

#import "GPTDSTextFieldCustomization.h"

#import "UIFont+DefaultFonts.h"
#import "UIColor+DefaultColors.h"
#import "UIColor+ThirteenSupport.h"

NS_ASSUME_NONNULL_BEGIN

@implementation GPTDSTextFieldCustomization

+ (instancetype)defaultSettings {
    return [self new];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.font = [UIFont _gptds_defaultLabelTextFontWithScale:(CGFloat)1.0];
        _borderWidth = 2;
        _cornerRadius = 8;
        _keyboardAppearance = UIKeyboardAppearanceDefault;
        
        self.textColor = [UIColor _gptds_labelColor];
        _borderColor = [UIColor _gptds_backgroundBrandColor] ;
        _placeholderTextColor = [UIColor _gptds_systemGray2Color];
        _placeholderText = @"";
    }
    return self;
}

- (id)copyWithZone:(nullable NSZone *)zone {
    GPTDSTextFieldCustomization *copy = [super copyWithZone:zone];
    copy.borderWidth = self.borderWidth;
    copy.borderColor = self.borderColor;
    copy.cornerRadius = self.cornerRadius;
    copy.keyboardAppearance = self.keyboardAppearance;
    copy.placeholderTextColor = self.placeholderTextColor;
    copy.placeholderText = self.placeholderText;

    return copy;
}

@end

NS_ASSUME_NONNULL_END
