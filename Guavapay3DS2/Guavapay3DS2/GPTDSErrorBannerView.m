//
//  GPTDSErrorBannerView.m
//  Guavapay3DS2
//

#import "GPTDSBundleLocator.h"
#import "GPTDSErrorBannerView.h"

#import "UIColor+DefaultColors.h"
#import "UIFont+DefaultFonts.h"

@interface GPTDSErrorBannerView()

@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *messageLabel;

@end

@implementation GPTDSErrorBannerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor _gptds_alertDangerBackgroundColor];
        self.layer.cornerRadius = 12;
        self.layer.masksToBounds = YES;
        self.layer.borderWidth = 2;
        self.layer.borderColor = [UIColor _gptds_alertDangerBorderColor].CGColor;

        _iconImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error" inBundle:[GPTDSBundleLocator gptdsResourcesBundle] compatibleWithTraitCollection:nil]];

        _messageLabel = [[UILabel alloc] init];
        _messageLabel.numberOfLines = 0;
        _messageLabel.font = [UIFont _gptds_defaultBoldLabelTextFontWithScale:(CGFloat)0.9];
        _messageLabel.textColor = [UIColor _gptds_foregroundDangerColor];
        _messageLabel.text = @"Your authentication failed";

        [self addSubview:_iconImage];
        [self addSubview:_messageLabel];

        [NSLayoutConstraint activateConstraints:@[
            [_iconImage.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:16],
            [_iconImage.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
            [_iconImage.topAnchor constraintGreaterThanOrEqualToAnchor:self.topAnchor constant:16],
            [_iconImage.bottomAnchor constraintLessThanOrEqualToAnchor:self.bottomAnchor constant:-16],
            [_iconImage.widthAnchor constraintEqualToConstant:24],
            [_iconImage.heightAnchor constraintEqualToConstant:24],

            [_messageLabel.leadingAnchor constraintEqualToAnchor:_iconImage.trailingAnchor constant:12],
            [_messageLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-16],
            [_messageLabel.topAnchor constraintEqualToAnchor:self.topAnchor constant:16],
            [_messageLabel.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-16],
        ]];

        _iconImage.translatesAutoresizingMaskIntoConstraints = NO;
        _messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return self;
}


- (void)setMessage:(NSString *)message {
    self.messageLabel.text = message;

    [self setNeedsLayout];
}

@end
