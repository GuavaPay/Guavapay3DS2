//
//  GPTDSLabelCustomization.m
//  Guavapay3DS2
//

#import "GPTDSLabelCustomization.h"

#import "UIFont+DefaultFonts.h"
#import "UIColor+ThirteenSupport.h"

NS_ASSUME_NONNULL_BEGIN

@implementation GPTDSLabelCustomization

+ (instancetype)defaultSettings {
    return [self new];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.textColor = [UIColor _gptds_labelColor];
        _headingTextColor = [UIColor _gptds_labelColor];
        self.font = [UIFont _gptds_defaultLabelTextFontWithScale:(CGFloat)0.85];
        _headingFont = [UIFont _gptds_defaultHeadingTextFont];
    }
    return self;
}

- (id)copyWithZone:(nullable NSZone *)zone {
    GPTDSLabelCustomization *copy = [super copyWithZone:zone];
    copy.headingTextColor = self.headingTextColor;
    copy.headingFont = self.headingFont;

    return copy;
}

@end

NS_ASSUME_NONNULL_END
