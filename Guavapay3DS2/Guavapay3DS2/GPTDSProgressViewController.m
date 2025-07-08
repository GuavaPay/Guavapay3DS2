//
//  GPTDSProgressViewController.m
//  Guavapay3DS2
//

#import "GPTDSProgressViewController.h"

#import "GPTDSBundleLocator.h"
#import "GPTDSUICustomization.h"
#import "UIViewController+Guavapay3DS2.h"
#import "GPTDSProcessingView.h"
#import "GPTDSVisionSupport.h"
#import "GPTDSAnalyticsDelegate.h"

@interface GPTDSProgressViewController()
@property (nonatomic, strong, nullable) GPTDSUICustomization *uiCustomization;
@property (nonatomic, strong) void (^didCancel)(void);
@property (nonatomic) GPTDSDirectoryServer directoryServer;
@property (nonatomic, weak) id<GPTDSAnalyticsDelegate> analyticsDelegate;
@end

@implementation GPTDSProgressViewController

- (instancetype)initWithDirectoryServer:(GPTDSDirectoryServer)directoryServer 
                        uiCustomization:(GPTDSUICustomization * _Nullable)uiCustomization
                      analyticsDelegate:(id<GPTDSAnalyticsDelegate>)analyticsDelegate
                              didCancel:(void (^)(void))didCancel {
    self = [super initWithNibName:nil bundle:nil];
    
    if (self) {
        _directoryServer = directoryServer;
        _uiCustomization = uiCustomization;
        _didCancel = didCancel;
    }
    
    return self;
}

- (void)loadView {
    NSString *imageName = GPTDSDirectoryServerImageName(self.directoryServer);
    UIImage *dsImage = imageName ? [UIImage imageNamed:imageName inBundle:[GPTDSBundleLocator gptdsResourcesBundle] compatibleWithTraitCollection:nil] : nil;
    self.view = [[GPTDSProcessingView alloc] initWithCustomization:self.uiCustomization directoryServerLogo:dsImage];
}

#if !STP_TARGET_VISION
- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.uiCustomization.preferredStatusBarStyle;
}
#endif

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _gptds_setupNavigationBarElementsWithCustomization:self.uiCustomization cancelButtonSelector:@selector(_cancelButtonTapped:)];
}

- (void)_cancelButtonTapped:(UIButton *)sender {
    self.didCancel();
}

@end
