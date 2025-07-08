//
//  GPTDSSelectionButton.m
//  Guavapay3DS2
//

#import <UIKit/UIKit.h>
#import "GPTDSResendButton.h"
#import "GPTDSButtonCustomization.h"
#import <dispatch/dispatch.h>

@interface GPTDSResendButton ()

@property (nonatomic, strong) dispatch_source_t countdownTimer;
@property (nonatomic, assign) NSInteger remainingSeconds;
@property (nonatomic, copy) NSString *baseTitle;
@property (nonatomic, readonly) BOOL isCooldownActive;

@end

NS_ASSUME_NONNULL_BEGIN

@implementation GPTDSResendButton

- (BOOL)isCooldownActive {
    return self.remainingSeconds >= 1;
}

- (nonnull instancetype)initWithCustomization:(nonnull GPTDSButtonCustomization *)customization title:(nonnull NSString *)title {
    self = [super init];
    if (self) {
        self.customization = customization;
        [self configureAppearanceWithCustomization:customization];
        [self configureTitle:title customization:customization];
        [self startCountdown];
    }
    return self;
}

- (void)resetCounter {
    [self startCountdown];
}

- (void)configureAppearanceWithCustomization:(GPTDSButtonCustomization *  _Nullable)buttonCustomization {
    self.backgroundColor = buttonCustomization.backgroundColor;
    self.layer.cornerRadius = buttonCustomization.cornerRadius;
}

- (void)updateTitle {
    NSString *title;
    if (self.isCooldownActive) {
        title = [NSString stringWithFormat:@"%@ (%ld)", self.baseTitle, (long)self.remainingSeconds];
    } else {
        title = self.baseTitle;
    }
    [self configureTitle:title customization:self.customization];
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
            attributesDictionary[NSForegroundColorAttributeName] = self.isCooldownActive ? UIColor.labelColor : textColor;
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

- (void)startCountdown {
    self.enabled = NO;
    self.tintColor = UIColor.labelColor;
    NSAttributedString *currentAttrTitle = [self attributedTitleForState:UIControlStateNormal];
    self.baseTitle = currentAttrTitle.string ?: @"";

    self.remainingSeconds = 59;
    [self updateTitle];

    dispatch_queue_t queue = dispatch_get_main_queue();
    self.countdownTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(self.countdownTimer,
                              dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC),
                              NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(self.countdownTimer, ^{
        if (self.isCooldownActive) {
            self.remainingSeconds--;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self updateTitle];
            });
        } else {
            dispatch_source_cancel(self.countdownTimer);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.enabled = YES;
                [self updateTitle];
            });
        }
    });
    dispatch_resume(self.countdownTimer);
}

@end

NS_ASSUME_NONNULL_END
