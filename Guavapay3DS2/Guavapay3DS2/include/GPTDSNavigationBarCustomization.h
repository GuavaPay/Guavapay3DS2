//
//  GPTDSNavigationBarCustomization.h
//  Guavapay3DS2
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "GPTDSCustomization.h"

NS_ASSUME_NONNULL_BEGIN

/**
 A customization object to use to configure a UINavigationBar.
 
 The font and textColor inherited from `GPTDSCustomization` configure the
 title of the navigation bar, and default to nil.
 */
@interface GPTDSNavigationBarCustomization : GPTDSCustomization

/// The default settings.
+ (instancetype)defaultSettings;

/**
 The scroll edge appearance to set on the navigation bar.
 
 Defaults to `nil`
 */
@property (nonatomic, nullable) UINavigationBarAppearance *scrollEdgeAppearance;

/**
 The tint color of the navigation bar background.
 Defaults to nil.
 */
@property (nonatomic, nullable) UIColor *barTintColor;

/**
 The navigation bar style.
 Defaults to UIBarStyleDefault.
 */
@property (nonatomic) UIBarStyle barStyle;

/**
 A Boolean value indicating whether the navigation bar is translucent or not.
 Defaults to YES.
 */
@property (nonatomic) BOOL translucent;

/**
 The text to display in the title of the navigation bar.
 Defaults to "Secure checkout".
 */
@property (nonatomic, copy) NSString *headerText;

/**
 The text to display for the button in the navigation bar.
 Defaults to "Cancel".
 */
@property (nonatomic, copy) NSString *buttonText;

@end

NS_ASSUME_NONNULL_END
