//
//  GPTDSTextChallengeView.m
//  Guavapay3DS2
//

#import "GPTDSTextChallengeView.h"
#import "GPTDSStackView.h"
#import "GPTDSVisionSupport.h"
#import "UIView+LayoutSupport.h"
#import "NSString+EmptyChecking.h"
#import "UIColor+ThirteenSupport.h"
#import "UIColor+DefaultColors.h"

NS_ASSUME_NONNULL_BEGIN

@implementation GPTDSTextField

static const CGFloat kTextFieldMargin = (CGFloat)12.0;

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, kTextFieldMargin, 0);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, kTextFieldMargin, 0);
}

- (nullable NSString *)accessibilityIdentifier {
    return @"GPTDSTextField";
}

@end

@interface GPTDSTextChallengeView() <UITextFieldDelegate>

@property (nonatomic, strong) GPTDSStackView *containerView;

@end

@implementation GPTDSTextChallengeView

static const CGFloat kTextFieldKernSpacing = 0;
static const CGFloat kTextFieldPlaceholderKernSpacing = 0;
static const CGFloat kTextChallengeViewBottomPadding = 11;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    if (self) {
        [self _setupViewHierarchy];
    }

    return self;
}

- (void)_setupViewHierarchy {
    self.layoutMargins = UIEdgeInsetsMake(0, 0, kTextChallengeViewBottomPadding, 0);

    self.containerView = [[GPTDSStackView alloc] initWithAlignment:GPTDSStackViewLayoutAxisVertical];

    self.textField = [[GPTDSTextField alloc] init];
    self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.textField.delegate = self;
    self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textField.textContentType = UITextContentTypeOneTimeCode;
    self.textField.keyboardType = UIKeyboardTypeNumberPad;
    [self.textField.defaultTextAttributes setValue:@(kTextFieldKernSpacing) forKey:NSKernAttributeName];

    // Style textField as rounded rectangle
    self.textField.backgroundColor = [UIColor _gptds_backgroundPrimaryColor];
    self.textField.layer.cornerRadius = 8.0;
    self.textField.layer.borderColor = [UIColor _gptds_backgroundSecondaryColor].CGColor;
    self.textField.layer.borderWidth = 1.0;
    self.textField.layer.masksToBounds = YES;

    // Fix height
    self.textField.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.textField.heightAnchor constraintEqualToConstant:56.0]
    ]];

    [self.containerView addArrangedSubview:self.textField];
    [self addSubview:self.containerView];
    [self.containerView _gptds_pinToSuperviewBounds];
}

- (void)setTextFieldCustomization:(GPTDSTextFieldCustomization * _Nullable)textFieldCustomization {
    _textFieldCustomization = textFieldCustomization;

    self.textField.font = textFieldCustomization.font;
    self.textField.textColor = textFieldCustomization.textColor;
    self.textField.layer.borderColor = textFieldCustomization.borderColor.CGColor;
    self.textField.layer.borderWidth = textFieldCustomization.borderWidth;
    self.textField.layer.cornerRadius = textFieldCustomization.cornerRadius;
    self.textField.keyboardAppearance = textFieldCustomization.keyboardAppearance;
    NSDictionary *placeholderTextAttributes = @{
        NSKernAttributeName: @(kTextFieldPlaceholderKernSpacing),
        NSBaselineOffsetAttributeName: @(3.0f),
        NSForegroundColorAttributeName: textFieldCustomization.placeholderTextColor,
    };
    self.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:textFieldCustomization.placeholderText attributes:placeholderTextAttributes];
}

- (NSString * _Nullable)inputText {
    return self.textField.text;
}

- (void)didMoveToWindow {
    [super didMoveToWindow];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];

    return NO;
}

@end

NS_ASSUME_NONNULL_END
