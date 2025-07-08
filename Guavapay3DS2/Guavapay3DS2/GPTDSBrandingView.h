//
//  GPTDSBrandingView.h
//  Guavapay3DS2
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GPTDSBrandingView: UIView

/// The issuer image to present in the branding view.
@property (nonatomic, strong) UIImage *issuerImage;

/// The payment system image to present in the branding view.
@property (nonatomic, strong) UIImage *paymentSystemImage;

@end

NS_ASSUME_NONNULL_END
