//
//  GPTDSSelectionCustomization.h
//  Guavapay3DS2
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 A customization object that configures the appearance of
 radio buttons and checkboxes.
 */
@interface GPTDSSelectionCustomization: NSObject <NSCopying>

/// The default settings.
+ (instancetype)defaultSettings;

/**
 The primary color of the selected state.
 Defaults to blue.
 */
@property (nonatomic) UIColor *primarySelectedColor;

/**
 The secondary color of the selected state (e.g. the checkmark color).
 Defaults to white.
 */
@property (nonatomic) UIColor *secondarySelectedColor;

/**
 The background color displayed in the unselected state.
 Defaults to light blue.
 */
@property (nonatomic) UIColor *unselectedBackgroundColor;

/**
 The color of the border drawn around the view in the unselected state.
 Defaults to blue.
 */
@property (nonatomic) UIColor *unselectedBorderColor;

@end

NS_ASSUME_NONNULL_END
