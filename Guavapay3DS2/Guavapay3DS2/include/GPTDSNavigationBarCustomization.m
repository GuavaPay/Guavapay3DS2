//
//  GPTDSNavigationBarCustomization.m
//  Guavapay3DS2
//

#import "GPTDSLocalizedString.h"
#import "GPTDSNavigationBarCustomization.h"

#import "UIColor+DefaultColors.h"

NS_ASSUME_NONNULL_BEGIN

@implementation GPTDSNavigationBarCustomization

+ (instancetype)defaultSettings {
    return [self new];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _barTintColor = [UIColor _gptds_backgroundSecondaryColor];
        _headerText = GPTDSLocalizedString(@"Secure checkout", @"The title for the challenge response step of an authenticated checkout.");
        _buttonText = GPTDSLocalizedString(@"Cancel", "The text for the button that cancels the current challenge process.");
        _translucent = YES;
    }
    return self;
}

- (id)copyWithZone:(nullable NSZone *)zone {
    GPTDSNavigationBarCustomization *copy = [super copyWithZone:zone];
    copy.barTintColor = self.barTintColor;
    copy.headerText = self.headerText;
    copy.buttonText = self.buttonText;
    copy.barStyle = self.barStyle;
    copy.translucent = self.translucent;
    
    return copy;
}

@end

NS_ASSUME_NONNULL_END
