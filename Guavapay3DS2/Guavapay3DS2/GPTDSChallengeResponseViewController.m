//
//  GPTDSChallengeResponseViewController.m
//  Guavapay3DS2
//

@import WebKit;

#import "GPTDSBundleLocator.h"
#import "GPTDSLocalizedString.h"
#import "GPTDSChallengeResponseViewController.h"
#import "GPTDSImageLoader.h"
#import "GPTDSStackView.h"
#import "GPTDSBrandingView.h"
#import "GPTDSChallengeInformationView.h"
#import "GPTDSChallengeSelectionView.h"
#import "GPTDSTextChallengeView.h"
#import "GPTDSVisionSupport.h"
#import "GPTDSWhitelistView.h"
#import "GPTDSExpandableInformationView.h"
#import "GPTDSWebView.h"
#import "GPTDSProcessingView.h"
#import "GPTDSResendButton.h"
#import "GPTDSErrorBannerView.h"
#import "UIView+LayoutSupport.h"
#import "NSString+EmptyChecking.h"
#import "UIColor+DefaultColors.h"
#import "UIButton+CustomInitialization.h"
#import "UIFont+DefaultFonts.h"
#import "UIViewController+Guavapay3DS2.h"
#import "include/GPTDSAnalyticsDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface GPTDSChallengeResponseViewController() <WKNavigationDelegate>

@property (nonatomic, strong, nullable) id<GPTDSChallengeResponse> response;
@property (nonatomic) GPTDSDirectoryServer directoryServer;
@property (weak, nonatomic) id<GPTDSAnalyticsDelegate>analyticsDelegate;
/// Used to track how long we've been showing a loading spinner.  Nil if we are not showing a spinner.
@property (nonatomic, strong, nullable) NSDate *loadingStartDate;
@property (nonatomic, strong, nullable) GPTDSUICustomization *uiCustomization;
@property (nonatomic, strong) GPTDSImageLoader *imageLoader;
@property (nonatomic, strong) NSTimer *processingTimer;
@property (nonatomic, getter=isLoading) BOOL loading;
@property (nonatomic, strong) GPTDSProcessingView *processingView;
@property (nonatomic, strong, nullable) UIScrollView *scrollView;
@property (nonatomic, strong, nullable) GPTDSWebView *webView;
@property (nonatomic, strong, nullable) GPTDSChallengeInformationView *challengeInformationView;
@property (nonatomic, strong) GPTDSStackView *bottomStackView;
@property (nonatomic, strong) UITapGestureRecognizer *tapOutsideKeyboardGestureRecognizer;

// User input views
@property (nonatomic, strong) GPTDSChallengeSelectionView *challengeSelectionView;
@property (nonatomic, strong) GPTDSTextChallengeView *textChallengeView;
@property (nonatomic, strong) GPTDSWhitelistView *whitelistView;
@property (nonatomic, strong) UIStackView *buttonStackView;

@property (nonatomic) BOOL oobOpenAppRequested;
@end

@implementation GPTDSChallengeResponseViewController

static const NSTimeInterval kInterstepProcessingTime = 1.0;
static const NSTimeInterval kDefaultTransitionAnimationDuration = 0.3;
static const CGFloat kBrandingViewHeight = 64;
static const CGFloat kContentHorizontalInset = 16;
static const CGFloat kContentVerticalInset = 16;
static const CGFloat kExpandableContentHorizontalInset = 27;
static const CGFloat kContentViewTopPadding = 0;
static const CGFloat kContentViewBottomPadding = 26;
static const CGFloat kExpandableContentViewSpacing = 8;

static NSString * const kHTMLStringLoadingURL = @"about:blank";

- (instancetype)initWithUICustomization:(GPTDSUICustomization * _Nullable)uiCustomization
                            imageLoader:(GPTDSImageLoader *)imageLoader
                        directoryServer:(GPTDSDirectoryServer)directoryServer
                      analyticsDelegate:(nullable id<GPTDSAnalyticsDelegate>)analyticsDelegate {
    self = [super initWithNibName:nil bundle:nil];

    if (self) {
        _uiCustomization = uiCustomization;
        _imageLoader = imageLoader;
        _tapOutsideKeyboardGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_didTapOutsideKeyboard:)];
        _directoryServer = directoryServer;
        _analyticsDelegate = analyticsDelegate;
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _gptds_setupNavigationBarElementsWithCustomization:_uiCustomization cancelButtonSelector:@selector(_cancelButtonTapped:)];
    self.view.backgroundColor = self.uiCustomization.backgroundColor;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_applicationWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_applicationDidEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];

    NSString *imageName = GPTDSDirectoryServerImageName(self.directoryServer);
    UIImage *dsImage = imageName ? [UIImage imageNamed:imageName inBundle:[GPTDSBundleLocator gptdsResourcesBundle] compatibleWithTraitCollection:nil] : nil;
    self.processingView = [[GPTDSProcessingView alloc] initWithCustomization:self.uiCustomization directoryServerLogo:dsImage];
    self.processingView.hidden = !self.isLoading;

    [self.view addSubview:self.processingView];
    [self.processingView _gptds_pinToSuperviewBoundsWithoutMargin];

    [self.view addGestureRecognizer:self.tapOutsideKeyboardGestureRecognizer];
}

#if !STP_TARGET_VISION
- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.uiCustomization.preferredStatusBarStyle;
}
#endif

#pragma mark - Public APIs

- (void)setLoading {
    [self _setLoading:YES];
}

- (void)setChallengeResponse:(id<GPTDSChallengeResponse>)response animated:(BOOL)animated {
    BOOL isFirstChallengeResponse = _response == nil;
    _response = response;

    [self.processingTimer invalidate];

    if (!self.isLoading || !self.loadingStartDate) {
        [self _displayChallengeResponseAnimated:animated];
    } else {
        // Show the loading spinner for at least kDefaultProcessingTime seconds before displaying
        NSTimeInterval timeSpentLoading = [[NSDate date] timeIntervalSinceDate:self.loadingStartDate];

        // There is double time requirement for the initial CRes.
        NSTimeInterval requiredMinimumProcessingTime = kInterstepProcessingTime;
        if (isFirstChallengeResponse) {
            requiredMinimumProcessingTime *= 2;
        }

        if (timeSpentLoading >= requiredMinimumProcessingTime) {
            // loadingStartDate is nil if we called this method in between viewDidLoad and viewDidAppear.
            [self _displayChallengeResponseAnimated:animated];
        } else {
            self.processingTimer = [NSTimer timerWithTimeInterval:(requiredMinimumProcessingTime - timeSpentLoading) target:self selector:@selector(_timerDidFire:) userInfo:@(animated) repeats:NO];
            [[NSRunLoop currentRunLoop] addTimer:self.processingTimer forMode:NSDefaultRunLoopMode];
        }
    }
}

- (void)dismiss {
    if (self.presentationDelegate) {
        [self.presentationDelegate dismissChallengeResponseViewController:self];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Private Helpers

- (void)_setLoading:(BOOL)isLoading {
    self.loading = isLoading;
    if (!self.viewLoaded || isLoading == !self.processingView.isHidden) {
        return;
    }

    // Disable animation to reduce `Cancel` button blinking
    [UIView performWithoutAnimation:^{
        self.navigationItem.rightBarButtonItem.enabled = !isLoading;
        [self.navigationItem.rightBarButtonItem.customView layoutIfNeeded];
    }];

    /* According to the specs [0], this should be set to NO during AReq/Ares and YES during CReq/CRes.
     However, according to UL test feedback [1], the AReq/ARes and initial CReq/CRes processing views should be identical.

     [0]: EMV 3-D Secure Protocol and Core Functions Specification v2.1.0 4.2.1.1
     - "The 3DS SDK shall for the CReq/CRes message exchange...[Req 148] Not include the DS logo or any other design element in the Processing screen."
     - "The 3DS SDK shall for the AReq/ARes message exchange...[Req 143] If requested, integrate the DS logo into the Processing screen."

     [1]:  UL_PreCompTestReport_ID846_202506_1.0
     - "Visual test case TC_SDK_10022_001 - The test case is FAILED because the processing screen for step 1 and step 2 are not identical. Step 1 displays a 'DS logo' while step 2 does not.

     To pass certification, we'll show the DS logo during the initial CReq/CRes (when self.response == nil).
     */
    self.processingView.shouldDisplayDSLogo = self.response == nil;
    // If there's no response, the blur view has nothing to blur and looks better visually if it's just the background color
    // EDIT Jan 2021: The challenge contents is hidden so this never looks good https://jira.corp.guavapay.com/browse/MOBILESDK-153
    self.processingView.shouldDisplayBlurView = NO; // self.response != nil;

    if (isLoading) {
        [self.view bringSubviewToFront:self.processingView];
        self.processingView.hidden = NO;
        [self.processingView startSpinning];

        self.loadingStartDate = [NSDate date];
        UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, GPTDSLocalizedString(@"Loading", @"Spoken by VoiceOver when the challenge is loading."));
    } else {
        self.processingView.hidden = YES;
        self.loadingStartDate = nil;
    }
}

- (void)_timerDidFire:(NSTimer *)timer {
    BOOL animated = ((NSNumber *)timer.userInfo).boolValue;
    [self.processingTimer invalidate];
    [self _displayChallengeResponseAnimated:animated];
}

- (void)_setupViewHierarchy {
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.backgroundColor = self.uiCustomization.footerCustomization.backgroundColor;
    self.scrollView.alwaysBounceVertical = YES;
    [self.view addSubview:self.scrollView];

    GPTDSStackView *containerStackView = [[GPTDSStackView alloc] initWithAlignment:GPTDSStackViewLayoutAxisVertical];
    [self.scrollView addSubview:containerStackView];
    [containerStackView _gptds_pinToSuperviewBoundsWithoutMargin];

    UIView *contentView = [UIView new];
    contentView.layoutMargins = UIEdgeInsetsMake(kContentViewTopPadding, kContentHorizontalInset, kContentViewBottomPadding, kContentHorizontalInset);
    contentView.backgroundColor = self.uiCustomization.backgroundColor;
    [containerStackView addArrangedSubview:contentView];

    GPTDSStackView *contentStackView = [[GPTDSStackView alloc] initWithAlignment:GPTDSStackViewLayoutAxisVertical];
    [contentView addSubview:contentStackView];
    [contentStackView _gptds_pinToSuperviewBounds];

    GPTDSBrandingView *brandingView = [self _newConfiguredBrandingView];
    GPTDSChallengeInformationView *challengeInformationView = [self _newConfiguredChallengeInformationView];
    self.challengeInformationView = challengeInformationView;
    UIButton *actionButton = nil;
    BOOL oobOpenApp = NO;
    if ((self.response.acsUIType == GPTDSACSUITypeOOB)
        && (self.response.oobAppURL)
        && (self.response.oobAppLabel)
        && !_oobOpenAppRequested) {
        oobOpenApp = YES;
    }
    actionButton = [self _newConfiguredActionButton:oobOpenApp];
    UIButton *resendButton = [self _newConfiguredResendButton];
    GPTDSTextChallengeView *textChallengeView = [self _newConfiguredTextChallengeView];
    self.textChallengeView = textChallengeView;
    GPTDSChallengeSelectionView *challengeSelectionView = [self _newConfiguredChallengeSelectionView];
    self.challengeSelectionView = challengeSelectionView;
    self.whitelistView = [self _newConfiguredWhitelistView];

    [contentStackView addArrangedSubview:brandingView];
    [contentStackView addLine:0];
    [contentStackView addSpacer:kContentVerticalInset];
    [contentStackView addArrangedSubview:challengeInformationView];
    [contentStackView addArrangedSubview:textChallengeView];
    [contentStackView addArrangedSubview:challengeSelectionView];

    [contentStackView addSpacer:12];

    self.buttonStackView = [self _newSubmitButtonStackView];

    [self.buttonStackView addArrangedSubview:actionButton];

    [contentStackView addArrangedSubview:self.buttonStackView];

    if (_response.acsUIType != GPTDSACSUITypeOOB && _response.acsUIType != GPTDSACSUITypeMultiSelect && _response.acsUIType != GPTDSACSUITypeSingleSelect) {
        [self.buttonStackView addArrangedSubview:resendButton];
    }
    if (!self.whitelistView.isHidden) {
        [contentStackView addSpacer:10];
    }
    [contentStackView addArrangedSubview:self.whitelistView];

    NSLayoutConstraint *contentViewWidth = [NSLayoutConstraint constraintWithItem:containerStackView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
    NSLayoutConstraint *brandingViewHeightConstraint = [NSLayoutConstraint constraintWithItem:brandingView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:kBrandingViewHeight];
    [NSLayoutConstraint activateConstraints:@[brandingViewHeightConstraint, contentViewWidth]];

    GPTDSExpandableInformationView *whyInformationView = [self _newConfiguredWhyInformationView];
    GPTDSExpandableInformationView *expandableInformationView = [self _newConfiguredExpandableInformationView];

    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.bottomStackView removeFromSuperview];
    self.bottomStackView = [[GPTDSStackView alloc] initWithAlignment:GPTDSStackViewLayoutAxisVertical];
    self.bottomStackView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.bottomStackView];

    // Constrain scrollView with fallback when bottomStackView is empty
    NSLayoutConstraint *scrollBottomToStack = [self.scrollView.bottomAnchor constraintEqualToAnchor:_bottomStackView.topAnchor];
    scrollBottomToStack.priority = UILayoutPriorityDefaultHigh;
    NSLayoutConstraint *scrollBottomToSafeArea = [self.scrollView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor];
    scrollBottomToSafeArea.priority = UILayoutPriorityDefaultLow;
    [NSLayoutConstraint activateConstraints:@[
        [self.scrollView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [self.scrollView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.scrollView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        scrollBottomToStack,
        scrollBottomToSafeArea
    ]];

    // Wrap why and expandable information views in a vertical stack
    whyInformationView.translatesAutoresizingMaskIntoConstraints = NO;
    expandableInformationView.translatesAutoresizingMaskIntoConstraints = NO;

    [self.bottomStackView addArrangedSubview:whyInformationView];
    if (!expandableInformationView.isHidden && !whyInformationView.isHidden) {
        [self.bottomStackView addSpacer:kExpandableContentViewSpacing];
        [self.bottomStackView addLine:-12];
        [self.bottomStackView addSpacer:kExpandableContentViewSpacing];
    }
    [self.bottomStackView addArrangedSubview:expandableInformationView];
    [NSLayoutConstraint activateConstraints:@[
        [self.bottomStackView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:kExpandableContentHorizontalInset],
        [self.bottomStackView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-kExpandableContentHorizontalInset],
        [self.bottomStackView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor]
    ]];

    [self _loadBrandingViewImages:brandingView];
}

- (void)_setupWebView {
    self.webView = [[GPTDSWebView alloc] init];
    self.webView.navigationDelegate = self;
    [self.view addSubview:self.webView];
    [self.webView _gptds_pinToSuperviewBounds];
    [self.webView loadExternalResourceBlockingHTMLString:self.response.acsHTML];
}

- (void)_loadBrandingViewImages:(GPTDSBrandingView *)brandingView {
    NSURL *issuerImageURL = [self _highestFideltyURLFromChallengeResponseImage:self.response.issuerImage];

    if (issuerImageURL != nil) {
        [self.imageLoader loadImageFromURL:issuerImageURL completion:^(UIImage * _Nullable image) {
            brandingView.issuerImage = image;
        }];
    }

    NSURL *paymentSystemImageURL = [self _highestFideltyURLFromChallengeResponseImage:self.response.paymentSystemImage];

    if (paymentSystemImageURL != nil) {
        [self.imageLoader loadImageFromURL:paymentSystemImageURL completion:^(UIImage * _Nullable image) {
            brandingView.paymentSystemImage = image;
        }];
    }
}

- (NSURL * _Nullable)_highestFideltyURLFromChallengeResponseImage:(id <GPTDSChallengeResponseImage>)image {
    return image.extraHighDensityURL ?: image.highDensityURL ?: image.mediumDensityURL;
}

- (void)_displayChallengeResponseAnimated:(BOOL)animated {
    if (self.response != nil) {
        [self _setLoading:NO];

        UIScrollView *existingScrollView = self.scrollView;
        GPTDSWebView *existingWebView = self.webView;

        void (^transitionBlock)(UIView *, BOOL) = ^void(UIView *viewToTransition, BOOL animated) {
            NSTimeInterval transitionTime = animated ? kDefaultTransitionAnimationDuration : 0;
            viewToTransition.alpha = 0;
            [UIView animateWithDuration:transitionTime animations:^{
                viewToTransition.alpha = 1;
            } completion:^(BOOL finished) {
                [existingScrollView removeFromSuperview];
                [existingWebView removeFromSuperview];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"GPTDSChallengeResponseViewController.didDisplayChallengeResponse" object:self];
                UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, self.navigationItem.titleView);
            }];
        };

        switch (self.response.acsUIType) {
            case GPTDSACSUITypeNone:
                break;
            case GPTDSACSUITypeText:
            case GPTDSACSUITypeSingleSelect:
            case GPTDSACSUITypeMultiSelect:
            case GPTDSACSUITypeOOB:
                [self _setupViewHierarchy];

                transitionBlock(self.scrollView, animated);
                break;
            case GPTDSACSUITypeHTML:
                [self _setupWebView];

                transitionBlock(self.webView, animated);
                break;
        }
    }
}

- (GPTDSBrandingView *)_newConfiguredBrandingView {
    GPTDSBrandingView *brandingView = [[GPTDSBrandingView alloc] init];
    brandingView.hidden = self.response.issuerImage == nil && self.response.paymentSystemImage == nil;

    return brandingView;
}

- (GPTDSErrorBannerView *)_newConfiguredErrorBannerView {
    GPTDSErrorBannerView *errorBannerView = [[GPTDSErrorBannerView alloc] init];
    errorBannerView.hidden = !self.response.showChallengeInfoTextIndicator;

    return errorBannerView;
}

- (GPTDSChallengeInformationView *)_newConfiguredChallengeInformationView {
    GPTDSChallengeInformationView *challengeInformationView = [[GPTDSChallengeInformationView alloc] init];
    challengeInformationView.headerText = self.response.challengeInfoHeader;
    challengeInformationView.challengeInformationText = self.response.challengeInfoText;
    if (self.response.acsUIType != GPTDSACSUITypeText) {
        challengeInformationView.challengeInformationLabel = self.response.challengeInfoLabel;
    }
    challengeInformationView.labelCustomization = self.uiCustomization.labelCustomization;

    if (self.response.showChallengeInfoTextIndicator) {
        challengeInformationView.textIndicatorImage = [UIImage imageNamed:@"error" inBundle:[GPTDSBundleLocator gptdsResourcesBundle] compatibleWithTraitCollection:nil];
    }

    return challengeInformationView;
}

- (GPTDSTextChallengeView *)_newConfiguredTextChallengeView {
    GPTDSTextChallengeView *textChallengeView = [[GPTDSTextChallengeView alloc] init];
    textChallengeView.hidden = self.response.acsUIType != GPTDSACSUITypeText;
    GPTDSTextFieldCustomization *uiCustomization = self.uiCustomization.textFieldCustomization;
    if (self.response.challengeInfoLabel) {
        uiCustomization.placeholderText = self.response.challengeInfoLabel;
    }
    textChallengeView.textFieldCustomization = uiCustomization;
    textChallengeView.textField.accessibilityLabel = self.response.challengeInfoLabel;
    textChallengeView.backgroundColor = self.uiCustomization.backgroundColor;

    return textChallengeView;
}

- (GPTDSChallengeSelectionView *)_newConfiguredChallengeSelectionView {
    GPTDSChallengeSelectionStyle selectionStyle = self.response.acsUIType == GPTDSACSUITypeMultiSelect ? GPTDSChallengeSelectionStyleMulti : GPTDSChallengeSelectionStyleSingle;
    GPTDSChallengeSelectionView *challengeSelectionView = [[GPTDSChallengeSelectionView alloc] initWithChallengeSelectInfo:self.response.challengeSelectInfo selectionStyle:selectionStyle];
    challengeSelectionView.hidden = self.response.acsUIType != GPTDSACSUITypeSingleSelect && self.response.acsUIType != GPTDSACSUITypeMultiSelect;
    challengeSelectionView.labelCustomization = self.uiCustomization.labelCustomization;
    challengeSelectionView.selectionCustomization = self.uiCustomization.selectionCustomization;
    challengeSelectionView.backgroundColor = self.uiCustomization.backgroundColor;

    return challengeSelectionView;
}

- (UIButton *)_newConfiguredActionButton:(BOOL) oobOpenApp {
    GPTDSUICustomizationButtonType buttonType = GPTDSUICustomizationButtonTypeSubmit;
    NSString *buttonTitle;

    switch (self.response.acsUIType) {
        case GPTDSACSUITypeNone:
            break;
        case GPTDSACSUITypeText:
        case GPTDSACSUITypeSingleSelect:
        case GPTDSACSUITypeMultiSelect: {
            buttonTitle = self.response.submitAuthenticationLabel;

            break;
        }
        case GPTDSACSUITypeOOB: {
            buttonType = GPTDSUICustomizationButtonTypeContinue;
            if (oobOpenApp) {
                buttonTitle = self.response.oobAppLabel;
            } else {
                buttonTitle = self.response.oobContinueLabel;
            }

            break;
        }
        case GPTDSACSUITypeHTML:
            break;
    }

    GPTDSButtonCustomization *buttonCustomization = [self.uiCustomization buttonCustomizationForButtonType:buttonType];
    UIButton *actionButton = [UIButton _gptds_buttonWithTitle:buttonTitle customization:buttonCustomization];
    if (oobOpenApp) {
        [actionButton addTarget:self action:@selector(_oobButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [actionButton addTarget:self action:@selector(_actionButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    actionButton.hidden = buttonTitle == nil || [NSString _gptds_isStringEmpty:buttonTitle];
    actionButton.accessibilityIdentifier = @"Continue";

    return actionButton;
}

- (GPTDSResendButton *)_newConfiguredResendButton {
    GPTDSButtonCustomization *buttonCustomization = [self.uiCustomization buttonCustomizationForButtonType:GPTDSUICustomizationButtonTypeResend];

    NSString *resendButtonTitle = self.response.resendInformationLabel;
    GPTDSResendButton *resendButton = [[GPTDSResendButton alloc] initWithCustomization:buttonCustomization title:resendButtonTitle];

    resendButton.hidden = resendButtonTitle == nil || [NSString _gptds_isStringEmpty:resendButtonTitle];
    [resendButton addTarget:self action:@selector(_resendButtonTapped:) forControlEvents:UIControlEventTouchUpInside];

    return resendButton;
}

- (GPTDSWhitelistView *)_newConfiguredWhitelistView {
    GPTDSWhitelistView *whitelistView = [[GPTDSWhitelistView alloc] init];
    whitelistView.whitelistText = self.response.whitelistingInfoText;
    whitelistView.labelCustomization = self.uiCustomization.labelCustomization;
    whitelistView.selectionCustomization = self.uiCustomization.selectionCustomization;
    whitelistView.hidden = whitelistView.whitelistText == nil;
    whitelistView.accessibilityIdentifier = @"GPTDSWhitelistView";

    return whitelistView;
}

- (GPTDSExpandableInformationView *)_newConfiguredWhyInformationView {
    GPTDSExpandableInformationView *whyInformationView = [[GPTDSExpandableInformationView alloc] init];
    whyInformationView.title = self.response.whyInfoLabel;
    whyInformationView.text = self.response.whyInfoText;
    whyInformationView.customization = self.uiCustomization.footerCustomization;
    whyInformationView.hidden = whyInformationView.title == nil;
    whyInformationView.backgroundColor = self.uiCustomization.footerCustomization.backgroundColor;
    __weak typeof(self) weakSelf = self;
    whyInformationView.didTap = ^{
        [weakSelf.textChallengeView endEditing:NO];
    };

    return whyInformationView;
}

- (GPTDSExpandableInformationView *)_newConfiguredExpandableInformationView {

    GPTDSExpandableInformationView *expandableInformationView = [[GPTDSExpandableInformationView alloc] init];
    expandableInformationView.title = self.response.expandInfoLabel;
    expandableInformationView.text = self.response.expandInfoText;
    expandableInformationView.customization = self.uiCustomization.footerCustomization;
    expandableInformationView.hidden = expandableInformationView.title == nil;
    expandableInformationView.backgroundColor = self.uiCustomization.footerCustomization.backgroundColor;
    __weak typeof(self) weakSelf = self;
    expandableInformationView.didTap = ^{
        [weakSelf.textChallengeView endEditing:NO];
    };

    return expandableInformationView;
}

- (UIStackView *)_newSubmitButtonStackView {
    UIStackView *stackView = [[UIStackView alloc] init];
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.distribution = UIStackViewDistributionFillEqually;
    stackView.alignment = UIStackViewAlignmentFill;
    stackView.spacing = 12;
    stackView.translatesAutoresizingMaskIntoConstraints = NO;

#if !STP_TARGET_VISION
    CGSize size = [UIScreen mainScreen].bounds.size;
    if (size.width > size.height) {
        // hack to detect landscape
        stackView.axis = UILayoutConstraintAxisHorizontal;
        stackView.alignment = UIStackViewAlignmentCenter;
    }
#endif
    return stackView;
}

- (void)_keyboardDidShow:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];

    // Get the keyboard’s frame at the end of its animation.
    CGRect keyboardFrameEnd = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];

    // Convert the keyboard's frame from the screen's coordinate space to your view's coordinate space.
    keyboardFrameEnd = [self.view convertRect:keyboardFrameEnd fromView:nil];

    // Get the intersection between the keyboard's frame and the view's bounds to work with the
    // part of the keyboard that overlaps your view.
    CGRect viewIntersection = CGRectIntersection(self.view.bounds, keyboardFrameEnd);
    CGFloat bottomOffset = 0;

    // Check whether the keyboard intersects your view before adjusting your offset.
    if (!CGRectIsEmpty(viewIntersection)) {
        // Adjust the offset by the difference between the view's height and the height of the
        // intersection rectangle.
        bottomOffset = CGRectGetMaxY(self.view.bounds) - CGRectGetMinY(viewIntersection);
    }

    UIEdgeInsets contentInsets = UIEdgeInsetsMake(self.scrollView.contentInset.top, 0.0, bottomOffset, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

- (void)_keyboardWillHide:(NSNotification *)notification {
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(self.scrollView.contentInset.top, 0.0, 0.0, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

- (void)_applicationDidEnterBackground {
    if (self.response.acsUIType == GPTDSACSUITypeOOB) {
        [self.analyticsDelegate OOBDidEnterBackground:self.response.threeDSServerTransactionID];
    }
}

- (void)_applicationWillEnterForeground:(NSNotification *)notification {
    if (self.response.acsUIType == GPTDSACSUITypeOOB) {

        [self.analyticsDelegate OOBWillEnterForeground:self.response.threeDSServerTransactionID];

        if (self.response.challengeAdditionalInfoText) {
            // [Req 316] When Challenge Additional Information Text is present, the SDK would replace the Challenge Information Text and Challenge Information Text Indicator with the Challenge Additional Information Text when the 3DS Requestor App is moved to the foreground.
            self.challengeInformationView.challengeInformationText = self.response.challengeAdditionalInfoText;
            self.challengeInformationView.textIndicatorImage = nil;
        }

        // [REQ 70]
        [self submit:self.response.acsUIType];
    } else if (self.response.acsUIType == GPTDSACSUITypeHTML && self.response.acsHTMLRefresh) {
        // [Req 317] When the ACS HTML Refresh element is present, the SDK replaces the ACS HTML with the contents of ACS HTML Refresh when the 3DS Requestor App is moved to the foreground.
        [self.webView loadExternalResourceBlockingHTMLString:self.response.acsHTMLRefresh];
    }
}

- (void)_didTapOutsideKeyboard:(UIGestureRecognizer *)gestureRecognizer {
    // Note this doesn't fire if a subview handles the touch (e.g. UIControls, GPTDSExpandableInformationView)
    [self.textChallengeView endEditing:NO];
}

#pragma mark - Button callbacks

- (void)_cancelButtonTapped:(UIButton *)sender {
    [self.textChallengeView endEditing:NO];
    [self.delegate challengeResponseViewControllerDidCancel:self];
    [self.analyticsDelegate cancelButtonTappedWithTransactionID:self.response.threeDSServerTransactionID];
}

- (void)_resendButtonTapped:(UIButton *)sender {
    [self.textChallengeView endEditing:NO];
    if ([sender isKindOfClass:[GPTDSResendButton class]]) {
        [(GPTDSResendButton *)sender resetCounter];
    }
    [self.delegate challengeResponseViewControllerDidRequestResend:self];
}

- (void)submit:(GPTDSACSUIType)type {
    [self.textChallengeView endEditing:NO];

    switch (type) {
        case GPTDSACSUITypeNone:
            break;
        case GPTDSACSUITypeText: {
            [self.delegate challengeResponseViewController:self
                                            didSubmitInput:self.textChallengeView.inputText
                                        whitelistSelection:self.whitelistView.selectedResponse];

            [self.analyticsDelegate OTPSubmitButtonTappedWithTransactionID:self.response.threeDSServerTransactionID];
            break;
        }
        case GPTDSACSUITypeSingleSelect:
        case GPTDSACSUITypeMultiSelect: {
            [self.delegate challengeResponseViewController:self
                                        didSubmitSelection:self.challengeSelectionView.currentlySelectedChallengeInfo
                                        whitelistSelection:self.whitelistView.selectedResponse];
            break;
        }
        case GPTDSACSUITypeOOB:
            [self.delegate challengeResponseViewControllerDidOOBContinue:self
                                                      whitelistSelection:self.whitelistView.selectedResponse];
            [self.analyticsDelegate OOBContinueButtonTappedWithTransactionID:self.response.threeDSServerTransactionID];
            _oobOpenAppRequested = NO;
            break;
        case GPTDSACSUITypeHTML:
            // No action button in this case, see WKNavigationDelegate.
            break;
    }
}

- (void)_actionButtonTapped:(UIButton *)sender {
    [self submit:self.response.acsUIType];
}

- (void)_oobButtonTapped:(UIButton *)sender {
    _oobOpenAppRequested = YES;
    [self.oobDelegate challengeResponseViewController:self
                                    didRequestOpenApp:self.response.oobAppURL];
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {

    NSURLRequest *request = navigationAction.request;

    if ([request.URL.absoluteString isEqualToString:kHTMLStringLoadingURL]) {
        return decisionHandler(WKNavigationActionPolicyAllow);
    } else {
        if (navigationAction.navigationType == WKNavigationTypeFormSubmitted || navigationAction.navigationType == WKNavigationTypeLinkActivated || navigationAction.navigationType == WKNavigationTypeOther) {
            // - The web view will return, either a parameter string (HTML Action = GET) or a
            // header/body (HTML Action = POST) containing the cardholders data input.
            // - The SDK passes the received data, unchanged, to the ACS in the ACS HTML
            // data element of the CReq message. The SDK shall not modify or reformat the
            // data in any way.

            // [Req 37] When the Cardholder’s response is returned as a parameter string, the form data is passed to the web view instance by triggering a location change to a specified (HTTPS://EMV3DS/challenge) URL with the challenge responses appended to the location URL as query parameters (for example, HTTPS://EMV3DS/challenge?city=Pittsburgh). The web view instance, because it monitors URL changes, receives the Cardholder’s responses as query parameters.

            if ([request.HTTPMethod isEqualToString:@"GET"]) {
                [self.delegate challengeResponseViewController:self didSubmitHTMLForm:request.URL.query];
            } else if ([request.HTTPMethod isEqualToString:@"POST"]) {
                NSData *body = request.HTTPBody;
                NSString *bodyString = [[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding];
                NSLog(@"Request body: %@", bodyString);

                [self.delegate challengeResponseViewController:self didSubmitHTMLForm:bodyString];
            }
        }

        return decisionHandler(WKNavigationActionPolicyCancel);
    }
}

- (void) viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    if (size.width > size.height) {
        // hack to detect landscape
        self.buttonStackView.axis = UILayoutConstraintAxisHorizontal;
        self.buttonStackView.alignment = UIStackViewAlignmentCenter;
    } else {
        self.buttonStackView.axis = UILayoutConstraintAxisVertical;
        self.buttonStackView.alignment = UIStackViewAlignmentFill;
    }
}

@end

NS_ASSUME_NONNULL_END
