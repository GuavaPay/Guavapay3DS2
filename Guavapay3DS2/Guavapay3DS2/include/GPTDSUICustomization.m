//
//  GPTDSUICustomization.m
//  Guavapay3DS2
//

#import "GPTDSUICustomization.h"
#import "UIColor+DefaultColors.h"
#import "UIColor+ThirteenSupport.h"

NS_ASSUME_NONNULL_BEGIN

@interface GPTDSUICustomization()

@property (nonatomic, strong) NSMutableDictionary<NSNumber *, GPTDSButtonCustomization *> *buttonCustomizationDictionary;

@end

@implementation GPTDSUICustomization

+ (instancetype)defaultSettings {
    return [[GPTDSUICustomization alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        _buttonCustomizationDictionary = [@{
                                            @(GPTDSUICustomizationButtonTypeNext): [GPTDSButtonCustomization defaultSettingsForButtonType:GPTDSUICustomizationButtonTypeNext
                                                                                   ],
                                            @(GPTDSUICustomizationButtonTypeCancel): [GPTDSButtonCustomization defaultSettingsForButtonType:GPTDSUICustomizationButtonTypeCancel],
                                            @(GPTDSUICustomizationButtonTypeResend): [GPTDSButtonCustomization defaultSettingsForButtonType:GPTDSUICustomizationButtonTypeResend],
                                            @(GPTDSUICustomizationButtonTypeSubmit): [GPTDSButtonCustomization defaultSettingsForButtonType:GPTDSUICustomizationButtonTypeSubmit],
                                            @(GPTDSUICustomizationButtonTypeContinue): [GPTDSButtonCustomization defaultSettingsForButtonType:GPTDSUICustomizationButtonTypeContinue],
                                            } mutableCopy];
        _navigationBarCustomization = [GPTDSNavigationBarCustomization defaultSettings];
        _labelCustomization = [GPTDSLabelCustomization defaultSettings];
        _textFieldCustomization = [GPTDSTextFieldCustomization defaultSettings];
        _footerCustomization = [GPTDSFooterCustomization defaultSettings];
        _selectionCustomization = [GPTDSSelectionCustomization defaultSettings];
        _backgroundColor = [UIColor _gptds_backgroundPrimaryColor];
        _activityIndicatorViewStyle = UIActivityIndicatorViewStyleMedium;
        _blurStyle = UIBlurEffectStyleRegular;
        _preferredStatusBarStyle = UIStatusBarStyleDefault;
    }
    
    return self;
}

- (void)setButtonCustomization:(GPTDSButtonCustomization *)buttonCustomization forType:(GPTDSUICustomizationButtonType)buttonType {
    self.buttonCustomizationDictionary[@(buttonType)] = buttonCustomization;
}

- (GPTDSButtonCustomization *)buttonCustomizationForButtonType:(GPTDSUICustomizationButtonType)buttonType {
    return self.buttonCustomizationDictionary[@(buttonType)];
}

#pragma mark - NSCopying

- (instancetype)copyWithZone:(nullable NSZone *)zone {
    GPTDSUICustomization *copy = [[[self class] allocWithZone:zone] init];
    copy.navigationBarCustomization = [self.navigationBarCustomization copy];
    copy.labelCustomization = [self.labelCustomization copy];
    copy.textFieldCustomization = [self.textFieldCustomization copy];
    NSMutableDictionary<NSNumber *, GPTDSButtonCustomization *> *buttonCustomizationDictionary = [NSMutableDictionary new];
    for (NSNumber *buttonCustomization in self.buttonCustomizationDictionary) {
        buttonCustomizationDictionary[buttonCustomization] = [self.buttonCustomizationDictionary[buttonCustomization] copy];
    }
    copy.buttonCustomizationDictionary = buttonCustomizationDictionary;
    copy.footerCustomization = [self.footerCustomization copy];
    copy.selectionCustomization = [self.selectionCustomization copy];
    copy.backgroundColor = self.backgroundColor;
    copy.activityIndicatorViewStyle = self.activityIndicatorViewStyle;
    copy.blurStyle = self.blurStyle;
    copy.preferredStatusBarStyle = self.preferredStatusBarStyle;
    return copy;
}

@end

NS_ASSUME_NONNULL_END
