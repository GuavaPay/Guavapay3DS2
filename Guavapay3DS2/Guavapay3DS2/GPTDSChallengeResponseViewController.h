//
//  GPTDSChallengeResponseViewController.h
//  Guavapay3DS2
//

#import <UIKit/UIKit.h>
#import "GPTDSChallengeResponseViewControllerDelegate.h"
#import "GPTDSChallengeResponse.h"
#import "GPTDSUICustomization.h"
#import "GPTDSImageLoader.h"
#import "GPTDSDirectoryServer.h"

@class GPTDSChallengeResponseViewController;
@protocol GPTDSAnalyticsDelegate;

NS_ASSUME_NONNULL_BEGIN

@protocol GPTDSChallengeResponseViewControllerPresentationDelegate

- (void)dismissChallengeResponseViewController:(GPTDSChallengeResponseViewController *)viewController;

@end

@interface GPTDSChallengeResponseViewController : UIViewController

@property (nonatomic, weak) id<GPTDSChallengeResponseViewControllerDelegate> delegate;
@property (nonatomic, weak) id<GPTDSChallengeResponseViewControllerOOBDelegate> oobDelegate;

@property (nonatomic, nullable, weak) id<GPTDSChallengeResponseViewControllerPresentationDelegate> presentationDelegate;

/// Use setChallengeResponser:animated: to update this value
@property (nonatomic, strong, readonly) id<GPTDSChallengeResponse> response;

- (instancetype)initWithUICustomization:(GPTDSUICustomization * _Nullable)uiCustomization 
                            imageLoader:(GPTDSImageLoader *)imageLoader
                        directoryServer:(GPTDSDirectoryServer)directoryServer
                      analyticsDelegate:(nullable id<GPTDSAnalyticsDelegate>)analyticsDelegate;

/// If `setLoading` was called beforehand, this waits until the loading spinner has been shown for at least 1 second before displaying the challenge responseself.processingView.isHidden.
- (void)setChallengeResponse:(id<GPTDSChallengeResponse>)response animated:(BOOL)animated;

- (void)setLoading;

- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
