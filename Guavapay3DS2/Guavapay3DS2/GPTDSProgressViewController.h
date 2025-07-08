//
//  GPTDSProgressViewController.h
//  Guavapay3DS2
//

#import <UIKit/UIKit.h>

#import "GPTDSDirectoryServer.h"

@class GPTDSImageLoader, GPTDSUICustomization;
@protocol GPTDSAnalyticsDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface GPTDSProgressViewController : UIViewController

- (instancetype)initWithDirectoryServer:(GPTDSDirectoryServer)directoryServer
                        uiCustomization:(GPTDSUICustomization * _Nullable)uiCustomization
                      analyticsDelegate:(nullable id<GPTDSAnalyticsDelegate>)analyticsDelegate
                              didCancel:(void (^)(void))didCancel;

@end

NS_ASSUME_NONNULL_END
