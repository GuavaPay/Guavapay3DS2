//
//  GPTDSProcessingView.m
//  Guavapay3DS2
//

#import "GPTDSProcessingView.h"
#import "GPTDSStackView.h"
#import "UIView+LayoutSupport.h"
#import "UIFont+DefaultFonts.h"
#import "UIColor+DefaultColors.h"
#import "GPTDSUICustomization.h"
#import "GPTDSProcessingSpinnerView.h"
#import "GPTDSBundleLocator.h"

NS_ASSUME_NONNULL_BEGIN

@interface GPTDSProcessingView()

@property (nonatomic, strong) GPTDSStackView *imageStackView;
@property (nonatomic, strong) UIView *blurViewPlaceholder;
@property (nonatomic, strong) UIView *centerBackgroundView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) GPTDSProcessingSpinnerView *spinner;

@end

@implementation GPTDSProcessingView

static const CGFloat kProcessingViewHorizontalMargin = 16;
static const CGFloat kProcessingViewVerticalMargin = 20;
static const CGFloat kSpinnerSize = 60;

- (instancetype)initWithCustomization:(GPTDSUICustomization *)customization directoryServerLogo:(nullable UIImage *)directoryServerLogo {
    self = [super initWithFrame:CGRectZero];

    if (self) {
        _blurViewPlaceholder = [UIView new];
        _imageView = [[UIImageView alloc] initWithImage:directoryServerLogo];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _shouldDisplayDSLogo = YES;
        [self _setupViewHierarchyWithCustomization:customization];
    }

    return self;
}

- (void)setShouldDisplayBlurView:(BOOL)shouldDisplayBlurView {
    _shouldDisplayBlurView = shouldDisplayBlurView;
    self.blurViewPlaceholder.hidden = shouldDisplayBlurView;
}

- (void)setShouldDisplayDSLogo:(BOOL)shouldDisplayDSLogo {
    _shouldDisplayDSLogo = shouldDisplayDSLogo;
    self.imageView.hidden = !shouldDisplayDSLogo;
    if (shouldDisplayDSLogo) {
        self.centerBackgroundView.backgroundColor = [UIColor _gptds_backgroundPrimaryColor];
    } else {
        self.centerBackgroundView.backgroundColor = UIColor.clearColor;
    }
}

- (void)_setupViewHierarchyWithCustomization:(GPTDSUICustomization *)customization {
    // Full-screen overlay
    UIView *overlayView = [[UIView alloc] init];
    overlayView.backgroundColor = [UIColor _gptds_backgroundOverlayColor];
    overlayView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:overlayView];
    [self sendSubviewToBack:overlayView];

    [NSLayoutConstraint activateConstraints:@[
        [overlayView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [overlayView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
        [overlayView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [overlayView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
    ]];

    // Centered card view with primary background and corner radius
    UIView *centerView = [[UIView alloc] init];
    self.centerBackgroundView = centerView;
    centerView.backgroundColor = [UIColor _gptds_backgroundPrimaryColor];
    centerView.layer.cornerRadius = 8;
    centerView.clipsToBounds = YES;
    centerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:centerView];

    [NSLayoutConstraint activateConstraints:@[
        [centerView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
        [centerView.leadingAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.leadingAnchor constant:kProcessingViewHorizontalMargin],
        [centerView.trailingAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.trailingAnchor constant:-kProcessingViewHorizontalMargin]
    ]];

    // Vertical stack inside the card
    UIStackView *stack = [[UIStackView alloc] init];
    stack.axis = UILayoutConstraintAxisVertical;
    stack.alignment = UIStackViewAlignmentCenter;
    stack.spacing = 16;
    stack.translatesAutoresizingMaskIntoConstraints = NO;
    [centerView addSubview:stack];

    [NSLayoutConstraint activateConstraints:@[
        [stack.topAnchor constraintEqualToAnchor:centerView.topAnchor constant:kProcessingViewVerticalMargin],
        [stack.bottomAnchor constraintEqualToAnchor:centerView.bottomAnchor constant:-kProcessingViewVerticalMargin],
        [stack.centerXAnchor constraintEqualToAnchor:centerView.centerXAnchor]
    ]];

    // Logo image (60x60)
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [stack addArrangedSubview:self.imageView];
    [NSLayoutConstraint activateConstraints:@[
        [self.imageView.widthAnchor constraintEqualToConstant:kSpinnerSize],
        [self.imageView.heightAnchor constraintEqualToConstant:kSpinnerSize],
    ]];

    // Spinner (60x60, brand color)
    _spinner = [[GPTDSProcessingSpinnerView alloc] initWithFrame:CGRectMake(0,0,60,60)];
    GPTDSButtonCustomization *buttonCustomization = [customization buttonCustomizationForButtonType:GPTDSUICustomizationButtonTypeSubmit];
    _spinner.spinnerColor = buttonCustomization.backgroundColor;
    _spinner.translatesAutoresizingMaskIntoConstraints = NO;
    [stack addArrangedSubview:_spinner];
    [NSLayoutConstraint activateConstraints:@[
        [_spinner.widthAnchor constraintEqualToConstant:kSpinnerSize],
        [_spinner.heightAnchor constraintEqualToConstant:kSpinnerSize],
    ]];
}

@end

NS_ASSUME_NONNULL_END
