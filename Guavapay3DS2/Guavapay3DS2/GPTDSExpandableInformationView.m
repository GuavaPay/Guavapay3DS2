//
//  GPTDSExpandableInformationView.m
//  Guavapay3DS2
//

#import "GPTDSLocalizedString.h"
#import "GPTDSBundleLocator.h"
#import "GPTDSExpandableInformationView.h"
#import "GPTDSStackView.h"
#import "UIView+LayoutSupport.h"
#import "NSString+EmptyChecking.h"

NS_ASSUME_NONNULL_BEGIN

@interface GPTDSExpandableInformationView()

@property (nonatomic, strong) UIView *tappableView;
@property (nonatomic, strong) GPTDSStackView *textContainerView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIImageView *titleImageView;

@end

@implementation GPTDSExpandableInformationView

static const CGFloat kTextContainerSpacing = 13;
static const CGFloat kExpandableInformationViewVerticalMargin = 16;
static const CGFloat kExpandableInformationViewHorizontalMargin = 4;
static const CGFloat kTitleImageViewMargin = 16;
static const CGFloat kTitleImageViewRotationAnimationDuration = (CGFloat)0.2;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    if (self) {
        [self _setupViewHierarchy];
        self.accessibilityIdentifier = @"GPTDSExpandableInformationView";
    }

    return self;
}

- (void)_setupViewHierarchy {
    self.layoutMargins = UIEdgeInsetsMake(kExpandableInformationViewVerticalMargin,
                                          kExpandableInformationViewHorizontalMargin,
                                          kExpandableInformationViewVerticalMargin,
                                          kExpandableInformationViewHorizontalMargin);

    self.titleLabel = [[UILabel alloc] init];
    // Set titleLabel as not an accessibility element because we make the
    // container, which is the actual control, have the same accessibility label
    // and accurately reflects that interactivity and state of the control
    self.titleLabel.isAccessibilityElement = NO;
    self.titleLabel.numberOfLines = 0;

    self.textLabel = [[UILabel alloc] init];
    self.textLabel.numberOfLines = 0;

    UIImage *chevronImage = [[UIImage imageNamed:@"Chevron" inBundle:[GPTDSBundleLocator gptdsResourcesBundle] compatibleWithTraitCollection:nil] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.titleImageView = [[UIImageView alloc] initWithImage:chevronImage];
    self.titleImageView.contentMode = UIViewContentModeCenter;
    self.titleImageView.transform = CGAffineTransformMakeRotation((CGFloat)M_PI_2);

    UIView *chevronContainer = [[UIView alloc] init];
    [chevronContainer addSubview:self.titleImageView];

    self.titleImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.titleImageView.trailingAnchor constraintEqualToAnchor:chevronContainer.trailingAnchor constant:-kTitleImageViewMargin/2],
        [self.titleImageView.leadingAnchor constraintEqualToAnchor:chevronContainer.leadingAnchor],
        [self.titleImageView.widthAnchor constraintEqualToConstant:kTitleImageViewMargin],
        [self.titleImageView.heightAnchor constraintEqualToConstant:kTitleImageViewMargin]
    ]];

    GPTDSStackView *containerView = [[GPTDSStackView alloc] initWithAlignment:GPTDSStackViewLayoutAxisHorizontal];
    [self addSubview:containerView];
    [containerView _gptds_pinToSuperviewBounds];

    GPTDSStackView *titleContainerView = [[GPTDSStackView alloc] initWithAlignment:GPTDSStackViewLayoutAxisVertical];
    [titleContainerView addArrangedSubview:self.titleLabel];

    [containerView addArrangedSubview:titleContainerView];
    [containerView addArrangedSubview:chevronContainer];

    self.textContainerView = [[GPTDSStackView alloc] initWithAlignment:GPTDSStackViewLayoutAxisVertical];
    self.textContainerView.hidden = YES;
    [self.textContainerView addSpacer:kTextContainerSpacing];
    [self.textContainerView addArrangedSubview:self.textLabel];
    [titleContainerView addArrangedSubview:self.textContainerView];

    UITapGestureRecognizer *expandTextTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_toggleTextExpansion)];
    [containerView addGestureRecognizer:expandTextTapRecognizer];
    containerView.accessibilityTraits |= UIAccessibilityTraitButton;
    containerView.isAccessibilityElement = YES;
    self.tappableView = containerView;
    [self _updateTappableViewAccessibilityValue];
}

- (void)setTitle:(NSString * _Nullable)title {
    _title = title;

    self.titleLabel.text = title;
    self.tappableView.accessibilityLabel = title;
}

- (void)setText:(NSString * _Nullable)text {
    _text = text;

    self.textLabel.text = text;
}

- (void)_updateTappableViewAccessibilityValue {
    if (self.textContainerView.isHidden) {
        self.tappableView.accessibilityValue = GPTDSLocalizedString(@"Collapsed", @"Accessibility label for expandandable text control to indicate text is hidden.");
    } else {
        self.tappableView.accessibilityValue = GPTDSLocalizedString(@"Expanded", @"Accessibility label for expandandable text control to indicate that the UI has been expanded and additional text is available.");
    }
}

- (void)_toggleTextExpansion {
    if (self.didTap) {
        self.didTap();
    }
    self.textContainerView.hidden = !self.textContainerView.hidden;

    CGFloat rotationValue = -(CGFloat)M_PI_2;
    if (self.textContainerView.isHidden) {
        rotationValue = (CGFloat)M_PI_2;
        UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, self.titleLabel);
    } else {
        UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, self.textLabel);
    }
    [self _updateTappableViewAccessibilityValue];

    [UIView animateWithDuration:kTitleImageViewRotationAnimationDuration animations:^{
        self.titleImageView.transform = CGAffineTransformMakeRotation(rotationValue);
    }];
}

- (void)setCustomization:(GPTDSFooterCustomization * _Nullable)customization {
    self.titleLabel.font = customization.headingFont;
    self.titleLabel.textColor = customization.headingTextColor;

    self.textLabel.font = customization.font;
    self.textLabel.textColor = customization.textColor;

    self.titleImageView.tintColor = customization.chevronColor;
}

@end

NS_ASSUME_NONNULL_END
