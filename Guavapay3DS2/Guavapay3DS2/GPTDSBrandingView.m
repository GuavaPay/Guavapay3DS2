//
//  GPTDSBrandingView.m
//  Guavapay3DS2
//

#import "GPTDSBrandingView.h"
#import "GPTDSStackView.h"
#import "UIView+LayoutSupport.h"
#import "GPTDSVisionSupport.h"
#import "UIColor+DefaultColors.h"

NS_ASSUME_NONNULL_BEGIN

@interface GPTDSBrandingView()

@property (nonatomic, strong) GPTDSStackView *stackView;

@property (nonatomic, strong) UIImageView *issuerImageView;
@property (nonatomic, strong) UIImageView *paymentSystemImageView;

@property (nonatomic, strong) UIView *issuerView;
@property (nonatomic, strong) UIView *paymentSystemView;

@end

@implementation GPTDSBrandingView

static const CGFloat kBrandingViewVerticalPadding = 8;
static const CGFloat kBrandingViewSpacing = 16;
static const CGFloat kImageViewHorizontalInset = 7;
static const CGFloat kImageViewVerticalInset = 19;
static const CGFloat kImageViewCornerRadius = 6;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    if (self) {
        [self _setupViewHierarchy];
    }

    return self;
}

- (void)setPaymentSystemImage:(UIImage *)paymentSystemImage {
    _paymentSystemImage = paymentSystemImage;

    self.paymentSystemImageView.image = paymentSystemImage;
}

- (void)setIssuerImage:(UIImage *)issuerImage {
    _issuerImage = issuerImage;

    self.issuerImageView.image = issuerImage;
}

- (void)_setupViewHierarchy {
    self.layoutMargins = UIEdgeInsetsMake(kBrandingViewVerticalPadding, 0, kBrandingViewVerticalPadding, 0);

    self.stackView = [[GPTDSStackView alloc] initWithAlignment:GPTDSStackViewLayoutAxisHorizontal];
    [self addSubview:self.stackView];

    [self.stackView _gptds_pinToSuperviewBounds];

    self.issuerImageView = [self _newBrandingImageView];
    self.issuerView = [self _newInsetViewWithImageView:self.issuerImageView];
    [self.stackView addArrangedSubview:self.issuerView];

    [self.stackView addSpacer:kBrandingViewSpacing];

    self.paymentSystemImageView = [self _newBrandingImageView];
    self.paymentSystemView = [self _newInsetViewWithImageView:self.paymentSystemImageView];
    [self.stackView addArrangedSubview:self.paymentSystemView];

    NSLayoutConstraint *imageViewWidthConstraint = [NSLayoutConstraint constraintWithItem:self.issuerView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0.5 constant:0];
    // Setting the priority of the width constraint, so that the priority of the equal widths constraint below takes precedence, allowing both image views to take half of the remaining space equally.
    imageViewWidthConstraint.priority = UILayoutPriorityDefaultHigh;
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:self.paymentSystemView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.issuerView attribute:NSLayoutAttributeWidth multiplier:1 constant:0];

    [NSLayoutConstraint activateConstraints:@[imageViewWidthConstraint, width]];
}

- (UIView *)_newInsetViewWithImageView:(UIImageView *)imageView {
    UIView *insetView = [UIView new];
    insetView.layoutMargins = UIEdgeInsetsMake(kImageViewHorizontalInset, kImageViewVerticalInset, kImageViewHorizontalInset, kImageViewVerticalInset);
    insetView.layer.cornerRadius = kImageViewCornerRadius;
    insetView.backgroundColor = [UIColor whiteColor]; // Issuer images always expect a white background.
    insetView.layer.masksToBounds = YES;

    [insetView addSubview:imageView];
    [imageView _gptds_pinToSuperviewBounds];

    return insetView;
}

- (UIImageView *)_newBrandingImageView {
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFit;

    return imageView;
}

@end

NS_ASSUME_NONNULL_END
