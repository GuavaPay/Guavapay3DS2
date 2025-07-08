//
//  UIColor+DefaultColors.m
//  Guavapay3DS2
//

#import "UIColor+DefaultColors.h"
#import "UIColor+ThirteenSupport.h"

@implementation UIColor (DefaultColors)

+ (UIColor *)_gptds_defaultFooterBackgroundColor {
    return [UIColor _gptds_systemGray5Color];
}

+ (UIColor *)_gptds_buttonGhostLinkColor {
    return [UIColor _gptds_colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
        return (traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight)
        ? [UIColor colorWithRed:(CGFloat)(29.0 / 255.0) green:(CGFloat)(106.0 / 255.0) blue:(CGFloat)(221.0 / 255.0) alpha:1.0]
        : [UIColor colorWithRed:(CGFloat)(77.0 / 255.0) green:(CGFloat)(145.0 / 255.0) blue:(CGFloat)(255.0 / 255.0) alpha:1.0];
    }];
}

+ (UIColor *)_gptds_foregroundBrandColor {
    return [UIColor _gptds_colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
        return (traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight)
        ? [UIColor colorWithRed:(CGFloat)(57.0 / 255.0) green:(CGFloat)(77.0 / 255.0) blue:(CGFloat)(0.0 / 255.0) alpha:1.0]
        : [UIColor colorWithRed:(CGFloat)(48.0 / 255.0) green:(CGFloat)(66.0 / 255.0) blue:(CGFloat)(0.0 / 255.0) alpha:1.0];
    }];
}

+ (nonnull UIColor *)_gptds_foregroundDangerColor {
    return [UIColor _gptds_colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
        return (traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight)
        ? [UIColor colorWithRed:(CGFloat)(186.0 / 255.0) green:(CGFloat)(26.0 / 255.0) blue:(CGFloat)(26.0 / 255.0) alpha:1.0]
        : [UIColor colorWithRed:(CGFloat)(255.0 / 255.0) green:(CGFloat)(182.0 / 255.0) blue:(CGFloat)(173.0 / 255.0) alpha:1.0];
    }];
}

+ (UIColor *)_gptds_backgroundBrandColor {
    return [UIColor _gptds_colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
        return (traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight)
        ? [UIColor colorWithRed:(CGFloat)(186.0 / 255.0) green:(CGFloat)(244.0 / 255.0) blue:(CGFloat)(0.0 / 255.0) alpha:1.0]
        : [UIColor colorWithRed:(CGFloat)(183.0 / 255.0) green:(CGFloat)(240.0 / 255.0) blue:(CGFloat)(0.0 / 255.0) alpha:1.0];
    }];
}

+ (UIColor *)_gptds_backgroundPrimaryColor {
    return [UIColor _gptds_colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
        return (traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight)
        ? [UIColor colorWithRed:(CGFloat)(255.0 / 255.0) green:(CGFloat)(255.0 / 255.0) blue:(CGFloat)(255.0 / 255.0) alpha:1.0]
        : [UIColor colorWithRed:(CGFloat)(30.0 / 255.0) green:(CGFloat)(30.0 / 255.0) blue:(CGFloat)(30.0 / 255.0) alpha:1.0];
    }];
}

+ (UIColor *)_gptds_backgroundSecondaryColor {
    return [UIColor _gptds_colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
        return (traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight)
        ? [UIColor colorWithRed:(CGFloat)(247.0 / 255.0) green:(CGFloat)(248.0 / 255.0) blue:(CGFloat)(247.0 / 255.0) alpha:1.0]
        : [UIColor colorWithRed:(CGFloat)(12.0 / 255.0) green:(CGFloat)(15.0 / 255.0) blue:(CGFloat)(11.0 / 255.0) alpha:1.0];
    }];
}

+ (UIColor *)_gptds_backgroundOverlayColor {
    return [UIColor _gptds_colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
        return (traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight)
        ? [UIColor colorWithRed:(CGFloat)(0.0 / 255.0) green:(CGFloat)(0.0 / 255.0) blue:(CGFloat)(0.0 / 255.0) alpha:0.4]
        : [UIColor colorWithRed:(CGFloat)(255.0 / 255.0) green:(CGFloat)(255.0 / 255.0) blue:(CGFloat)(255.0 / 255.0) alpha:0.08];
    }];
}

+ (UIColor *)_gptds_borderColor {
    return [UIColor _gptds_colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
        return (traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight)
        ? [UIColor colorWithRed:(CGFloat)(239.0 / 255.0) green:(CGFloat)(239.0 / 255.0) blue:(CGFloat)(240.0 / 255.0) alpha:1.0]
        : [UIColor colorWithRed:(CGFloat)(47.0 / 255.0) green:(CGFloat)(48.0 / 255.0) blue:(CGFloat)(49.0 / 255.0) alpha:1.0];
    }];
}

+ (UIColor *)_gptds_controlsBorderDefaultColor {
    return [UIColor _gptds_colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
        return (traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight)
        ? [UIColor colorWithRed:(CGFloat)(177.0 / 255.0) green:(CGFloat)(178.0 / 255.0) blue:(CGFloat)(180.0 / 255.0) alpha:1.0]
        : [UIColor colorWithRed:(CGFloat)(105.0 / 255.0) green:(CGFloat)(106.0 / 255.0) blue:(CGFloat)(109.0 / 255.0) alpha:1.0];
    }];
}

+ (UIColor *)_gptds_controlsBackgroundPrimaryColor {
    return [UIColor _gptds_colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
        return (traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight)
        ? [UIColor colorWithRed:(CGFloat)(164.0 / 255.0) green:(CGFloat)(215.0 / 255.0) blue:(CGFloat)(0.0 / 255.0) alpha:1.0]
        : [UIColor colorWithRed:(CGFloat)(164.0 / 255.0) green:(CGFloat)(219.0 / 255.0) blue:(CGFloat)(0.0 / 255.0) alpha:1.0];
    }];
}

+ (nonnull UIColor *)_gptds_alertDangerBackgroundColor {
    return [UIColor _gptds_colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
        return (traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight)
        ? [UIColor colorWithRed:(CGFloat)(255.0 / 255.0) green:(CGFloat)(237.0 / 255.0) blue:(CGFloat)(234.0 / 255.0) alpha:1.0]
        : [UIColor colorWithRed:(CGFloat)(82.0 / 255.0) green:(CGFloat)(0.0 / 255.0) blue:(CGFloat)(3.0 / 255.0) alpha:1.0];
    }];
}

+ (nonnull UIColor *)_gptds_alertDangerBorderColor {
    return [UIColor _gptds_colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
        return (traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight)
        ? [UIColor colorWithRed:(CGFloat)(255.0 / 255.0) green:(CGFloat)(218.0 / 255.0) blue:(CGFloat)(214.0 / 255.0) alpha:1.0]
        : [UIColor colorWithRed:(CGFloat)(107.0 / 255.0) green:(CGFloat)(0.0 / 255.0) blue:(CGFloat)(5.0 / 255.0) alpha:1.0];
    }];
}

@end
