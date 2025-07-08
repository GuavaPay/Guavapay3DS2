//
//  GPTDSChallengeInformationView.m
//  Guavapay3DS2
//

#import "GPTDSChallengeInformationView.h"
#import "GPTDSStackView.h"
#import "GPTDSSpacerView.h"
#import "UIView+LayoutSupport.h"
#import "NSString+EmptyChecking.h"
#import "UIColor+DefaultColors.h"

NS_ASSUME_NONNULL_BEGIN

@interface GPTDSChallengeInformationView ()

@property (nonatomic, strong) GPTDSStackView *informationStackView;
@property (nonatomic, strong) GPTDSStackView *indicatorStackView;

@property (nonatomic, strong) UILabel *headerLabel;
@property (nonatomic, strong) UIImageView *textIndicatorImageView;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UILabel *informationLabel;
@property (nonatomic, strong) UIView *indicatorStackViewSpacerView;
@property (nonatomic, strong) UIView *indicatorImageTextSpacerView;
@property (nonatomic, strong) UIColor *defaultTextColor;

@end

@implementation GPTDSChallengeInformationView

static const CGFloat kHeaderTextBottomPadding = 8;
static const CGFloat kInformationTextBottomPadding = 20;
static const CGFloat kChallengeInformationViewBottomPadding = 6;
static const CGFloat kTextIndicatorHorizontalPadding = 8;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    if (self) {
        [self _setupViewHierarchy];
    }

    return self;
}

- (void)setHeaderText:(NSString * _Nullable)headerText {
    _headerText = headerText;

    self.headerLabel.text = headerText;
    self.headerLabel.hidden = [NSString _gptds_isStringEmpty:headerText];
}

- (void)setTextIndicatorImage:(UIImage * _Nullable)textIndicatorImage {
    _textIndicatorImage = textIndicatorImage;

    self.textIndicatorImageView.image = textIndicatorImage;
    self.textIndicatorImageView.hidden = textIndicatorImage == nil;
    self.indicatorImageTextSpacerView.hidden = textIndicatorImage == nil;
    // If an icon is shown, color the challenge text red; otherwise use the default color
    self.textLabel.textColor = textIndicatorImage ? [UIColor _gptds_foregroundDangerColor] : self.defaultTextColor;
}

- (void)setChallengeInformationText:(NSString * _Nullable)challengeInformationText {
    _challengeInformationText = challengeInformationText;

    self.textLabel.text = challengeInformationText;
    self.textLabel.hidden = [NSString _gptds_isStringEmpty:challengeInformationText];
}

- (void)setChallengeInformationLabel:(NSString * _Nullable)challengeInformationLabel {
    _challengeInformationLabel = challengeInformationLabel;

    self.informationLabel.text = challengeInformationLabel;
    self.informationLabel.hidden = [NSString _gptds_isStringEmpty:challengeInformationLabel];
    self.indicatorStackViewSpacerView.hidden = self.informationLabel.hidden;
}

- (void)_setupViewHierarchy {
    self.layoutMargins = UIEdgeInsetsMake(0, 0, kChallengeInformationViewBottomPadding, 0);

    self.headerLabel = [self _newInformationLabel];

    self.textIndicatorImageView = [[UIImageView alloc] init];
    self.textIndicatorImageView.contentMode = UIViewContentModeTop;
    self.textIndicatorImageView.hidden = YES;

    self.textLabel = [self _newInformationLabel];
    // Store the default text color for later
    self.defaultTextColor = self.textLabel.textColor;
    self.informationLabel = [self _newInformationLabel];

    self.indicatorStackView = [[GPTDSStackView alloc] initWithAlignment:GPTDSStackViewLayoutAxisHorizontal];

    [self.indicatorStackView addArrangedSubview:self.textIndicatorImageView];
    self.indicatorImageTextSpacerView = [[GPTDSSpacerView alloc] initWithLayoutAxis:GPTDSStackViewLayoutAxisHorizontal dimension:kTextIndicatorHorizontalPadding];
    self.indicatorImageTextSpacerView.hidden = YES;
    [self.indicatorStackView addArrangedSubview:self.indicatorImageTextSpacerView];
    [self.indicatorStackView addArrangedSubview:self.textLabel];

    self.informationStackView = [[GPTDSStackView alloc] initWithAlignment:GPTDSStackViewLayoutAxisVertical];
    [self.informationStackView addArrangedSubview:self.headerLabel];
    [self.informationStackView addSpacer:kHeaderTextBottomPadding];
    [self.informationStackView addArrangedSubview:self.indicatorStackView];
    self.indicatorStackViewSpacerView = [[GPTDSSpacerView alloc] initWithLayoutAxis:GPTDSStackViewLayoutAxisVertical dimension:kInformationTextBottomPadding];
    [self.informationStackView addArrangedSubview:self.indicatorStackViewSpacerView];
    [self.informationStackView addArrangedSubview:self.informationLabel];

    [self addSubview:self.informationStackView];

    [self.informationStackView _gptds_pinToSuperviewBounds];

    NSLayoutConstraint *imageViewWidthConstraint = [NSLayoutConstraint constraintWithItem:self.textIndicatorImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:35];
    [NSLayoutConstraint activateConstraints:@[imageViewWidthConstraint]];
}

- (void)setLabelCustomization:(GPTDSLabelCustomization * _Nullable)labelCustomization {
    _labelCustomization = labelCustomization;

    self.headerLabel.font = labelCustomization.headingFont;
    self.headerLabel.textColor = labelCustomization.headingTextColor;

    self.textLabel.font = labelCustomization.font;
    self.textLabel.textColor = labelCustomization.textColor;

    self.informationLabel.font = labelCustomization.font;
    self.informationLabel.textColor = labelCustomization.textColor;
}

- (UILabel *)_newInformationLabel {
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    label.hidden = YES;

    return label;
}

@end

NS_ASSUME_NONNULL_END
