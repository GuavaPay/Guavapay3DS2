//
//  UIButton+CustomInitialization.h
//  Guavapay3DS2
//

#import <UIKit/UIKit.h>

#import "GPTDSUICustomization.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (CustomInitialization)

+ (UIButton *)_gptds_buttonWithTitle:(NSString * _Nullable)title customization:(GPTDSButtonCustomization * _Nullable)customization;

@end

NS_ASSUME_NONNULL_END
