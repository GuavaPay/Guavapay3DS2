//
//  GPTDSSubmitButton.m
//  Guavapay3DS2
//

#import "GPTDSSubmitButton.h"
#import "GPTDSButtonCustomization.h"

@interface GPTDSSubmitButton ()

@end

NS_ASSUME_NONNULL_BEGIN

@implementation GPTDSSubmitButton

const CGFloat kMinimumHeight = 56.0;

- (nonnull instancetype)initWithCustomization:(nonnull GPTDSButtonCustomization *)customization title:(nonnull NSString *)title {
    self = [super init];
    if (self) {
        [self configureAppearanceWithCustomization:customization];
        [self configureTitle:title customization:customization];
    }
    return self;
}

- (void)configureAppearanceWithCustomization:(GPTDSButtonCustomization *  _Nullable)buttonCustomization {
    self.backgroundColor = buttonCustomization.backgroundColor;
    self.layer.cornerRadius = buttonCustomization.cornerRadius;
    // Add padding around title for multi-line support
    self.contentEdgeInsets = UIEdgeInsetsMake(12, 12, 12, 12);
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)configureTitle:(NSString * _Nullable)buttonTitle customization:(GPTDSButtonCustomization *  _Nullable)buttonCustomization {
    UIFont *font = buttonCustomization.font;
    UIColor *textColor = buttonCustomization.textColor;

    if (buttonTitle != nil) {
        NSMutableDictionary *attributesDictionary = [NSMutableDictionary dictionary];

        if (font != nil) {
            attributesDictionary[NSFontAttributeName] = font;
        }

        if (textColor != nil) {
            attributesDictionary[NSForegroundColorAttributeName] = textColor;
        }

        switch (buttonCustomization.titleStyle) {
            case GPTDSButtonTitleStyleDefault:
                break;
            case GPTDSButtonTitleStyleSentenceCapitalized:
                buttonTitle = [buttonTitle localizedCapitalizedString];
                break;
            case GPTDSButtonTitleStyleLowercase:
                buttonTitle = [buttonTitle localizedLowercaseString];
                break;
            case GPTDSButtonTitleStyleUppercase:
                buttonTitle = [buttonTitle localizedUppercaseString];
                break;
        }

        NSAttributedString *title = [[NSAttributedString alloc] initWithString:buttonTitle attributes:attributesDictionary];
        [self setAttributedTitle:title forState:UIControlStateNormal];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat maxLabelWidth = CGRectGetWidth(self.bounds) - self.contentEdgeInsets.left - self.contentEdgeInsets.right;
    self.titleLabel.preferredMaxLayoutWidth = maxLabelWidth;
    [self invalidateIntrinsicContentSize];
}


- (CGSize)intrinsicContentSize {
    CGFloat maxLabelWidth = CGRectGetWidth(self.bounds) - self.contentEdgeInsets.left - self.contentEdgeInsets.right;
    CGSize labelSize = [self.titleLabel sizeThatFits:CGSizeMake(maxLabelWidth, CGFLOAT_MAX)];

    CGFloat height = labelSize.height + self.contentEdgeInsets.top + self.contentEdgeInsets.bottom;
    height = MAX(height, kMinimumHeight);

    return CGSizeMake(labelSize.width + self.contentEdgeInsets.left + self.contentEdgeInsets.right,
                      height);
}

@end

NS_ASSUME_NONNULL_END
