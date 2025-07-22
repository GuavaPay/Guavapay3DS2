//
//  GPTDSProcessingView.h
//  Guavapay3DS2
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class GPTDSUICustomization;

@interface GPTDSProcessingView : UIView

/// Defaults to NO
@property (nonatomic) BOOL shouldDisplayBlurView;
/// Defaults to YES
@property (nonatomic) BOOL shouldDisplayDSLogo;

- (instancetype)initWithCustomization:(GPTDSUICustomization *)customization directoryServerLogo:(nullable UIImage *)directoryServerLogo;

@end

NS_ASSUME_NONNULL_END
