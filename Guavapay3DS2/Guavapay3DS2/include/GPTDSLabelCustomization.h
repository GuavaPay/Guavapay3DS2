//
//  GPTDSLabelCustomization.h
//  Guavapay3DS2
//

#import "GPTDSCustomization.h"

NS_ASSUME_NONNULL_BEGIN

/**
 A customization object to use to configure the UI of a text label.
 
 The font and textColor inherited from `GPTDSCustomization` configure non-heading labels.
 */
@interface GPTDSLabelCustomization : GPTDSCustomization

/// The default settings.
+ (instancetype)defaultSettings;

/// The color of the heading text. Defaults to black.
@property (nonatomic) UIColor *headingTextColor;

/// The font to use for the heading text.
@property (nonatomic) UIFont *headingFont;

@end

NS_ASSUME_NONNULL_END
