//
//  UIColor+ThirteenSupport.h
//  Guavapay3DS2
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (GPTDSThirteenSupport)

+ (UIColor *)_gptds_colorWithDynamicProvider:(UIColor * _Nonnull (^)(UITraitCollection *traitCollection))dynamicProvider;
+ (UIColor *)_gptds_systemGray5Color;
+ (UIColor *)_gptds_systemGray2Color;
+ (UIColor *)_gptds_systemBackgroundColor;
+ (UIColor *)_gptds_labelColor;


@end

NS_ASSUME_NONNULL_END
