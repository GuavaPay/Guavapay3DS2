//
//  UIColor+ThirteenSupport.m
//  Guavapay3DS2
//

#import "UIColor+ThirteenSupport.h"

@implementation UIColor (GPTDSThirteenSupport)

+ (UIColor *)_gptds_colorWithDynamicProvider:(UIColor * _Nonnull (^)(UITraitCollection *traitCollection))dynamicProvider {
    return [UIColor colorWithDynamicProvider:dynamicProvider];
}

+ (UIColor *)_gptds_systemGray5Color {
    return [UIColor systemGray5Color];
}

+ (UIColor *)_gptds_systemGray2Color {
    return [UIColor systemGray2Color];
}

+ (UIColor *)_gptds_systemBackgroundColor {
    return [UIColor systemBackgroundColor];
}

+ (UIColor *)_gptds_labelColor {
    return [UIColor labelColor];
}

@end
