//
//  UIColor+DefaultColors.h
//  Guavapay3DS2
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (DefaultColors)

/// The challenge view footer background color
+ (UIColor *)_gptds_defaultFooterBackgroundColor;
+ (UIColor *)_gptds_buttonGhostLinkColor;
+ (UIColor *)_gptds_foregroundBrandColor;
+ (UIColor *)_gptds_foregroundDangerColor;
+ (UIColor *)_gptds_backgroundBrandColor;
+ (UIColor *)_gptds_backgroundPrimaryColor;
+ (UIColor *)_gptds_backgroundSecondaryColor;
+ (UIColor *)_gptds_backgroundOverlayColor;
+ (UIColor *)_gptds_borderColor;
+ (UIColor *)_gptds_controlsBorderDefaultColor;
+ (UIColor *)_gptds_controlsBackgroundPrimaryColor;
+ (UIColor *)_gptds_alertDangerBackgroundColor;
+ (UIColor *)_gptds_alertDangerBorderColor;

@end

NS_ASSUME_NONNULL_END
