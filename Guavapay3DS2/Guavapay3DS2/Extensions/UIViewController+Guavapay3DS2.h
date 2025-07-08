//
//  UIViewController+Guavapay3DS2.h
//  Guavapay3DS2
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class GPTDSUICustomization;

@interface UIViewController (Guavapay3DS2)

- (void)_gptds_setupNavigationBarElementsWithCustomization:(GPTDSUICustomization *)customization cancelButtonSelector:(SEL)cancelButtonSelector;

@end

NS_ASSUME_NONNULL_END
