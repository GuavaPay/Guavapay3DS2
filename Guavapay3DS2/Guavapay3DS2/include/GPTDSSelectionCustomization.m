//
//  GPTDSSelectionCustomization.m
//  Guavapay3DS2
//

#import "GPTDSSelectionCustomization.h"

#import "UIColor+DefaultColors.h"
#import "UIColor+ThirteenSupport.h"

NS_ASSUME_NONNULL_BEGIN

@implementation GPTDSSelectionCustomization

+ (instancetype)defaultSettings {
    return [self new];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _primarySelectedColor = [UIColor _gptds_controlsBackgroundPrimaryColor];
        _secondarySelectedColor = UIColor.whiteColor;
        _unselectedBackgroundColor = [UIColor _gptds_backgroundPrimaryColor];
        _unselectedBorderColor = [UIColor _gptds_controlsBorderDefaultColor];
    }
    return self;
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    GPTDSSelectionCustomization *copy = [GPTDSSelectionCustomization new];
    copy.primarySelectedColor = self.primarySelectedColor;
    copy.secondarySelectedColor = self.secondarySelectedColor;
    copy.unselectedBackgroundColor = self.unselectedBackgroundColor;
    copy.unselectedBorderColor = self.unselectedBorderColor;
    return copy;
}

@end

NS_ASSUME_NONNULL_END
