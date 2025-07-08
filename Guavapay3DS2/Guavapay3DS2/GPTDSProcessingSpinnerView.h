//
//  GPTDSProcessingSpinnerView.h
//  Guavapay3DS2
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GPTDSProcessingSpinnerView : UIView

/// Color of the spinner arc. By default, brandBackground is taken from customization.
@property (nonatomic, strong) UIColor *spinnerColor;

/// Start spinner animation
- (void)startSpinning;

@end

NS_ASSUME_NONNULL_END
