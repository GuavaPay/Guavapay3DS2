//
//  UIFont+DefaultFonts.h
//  Guavapay3DS2
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIFont (DefaultFonts)

+ (UIFont *)_gptds_defaultHeadingTextFont;

+ (UIFont *)_gptds_defaultLabelTextFontWithScale:(CGFloat)scale;
+ (UIFont *)_gptds_defaultBoldLabelTextFontWithScale:(CGFloat)scale;

@end

NS_ASSUME_NONNULL_END
