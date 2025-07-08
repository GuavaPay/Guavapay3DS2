//
//  GPTDSCustomization.m
//  Guavapay3DS2
//

#import "GPTDSCustomization.h"

NS_ASSUME_NONNULL_BEGIN

@implementation GPTDSCustomization

- (id)copyWithZone:(nullable NSZone *)zone {
    GPTDSCustomization *copy = [[[self class] allocWithZone:zone] init];
    copy.font = self.font;
    copy.textColor = self.textColor;

    return copy;
}

@end

NS_ASSUME_NONNULL_END
