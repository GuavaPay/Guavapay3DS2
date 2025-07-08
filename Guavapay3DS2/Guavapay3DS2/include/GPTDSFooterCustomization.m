//
//  GPTDSFooterCustomization.m
//  Guavapay3DS2
//

#import "GPTDSFooterCustomization.h"

#import "UIFont+DefaultFonts.h"
#import "UIColor+DefaultColors.h"
#import "UIColor+ThirteenSupport.h"

@implementation GPTDSFooterCustomization

+ (instancetype)defaultSettings {
    return [self new];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.textColor = [UIColor _gptds_labelColor];
        _headingTextColor = [UIColor _gptds_labelColor];
        _backgroundColor = [UIColor _gptds_backgroundPrimaryColor];
        _chevronColor = [UIColor _gptds_labelColor];
        self.font = [UIFont _gptds_defaultLabelTextFontWithScale:(CGFloat)0.8];
        _headingFont = [UIFont _gptds_defaultLabelTextFontWithScale:(CGFloat)0.8];
    }
    return self;
}

- (instancetype)copyWithZone:(nullable NSZone *)zone {
    GPTDSFooterCustomization *copy = [super copyWithZone:zone];
    copy.headingTextColor = self.headingTextColor;
    copy.headingFont = self.headingFont;
    copy.backgroundColor = self.backgroundColor;
    copy.chevronColor = self.chevronColor;
    
    return copy;
}


@end
