//
//  GPTDSDeviceInformation.m
//  Guavapay3DS2
//

#import "GPTDSDeviceInformation.h"

NS_ASSUME_NONNULL_BEGIN

@implementation GPTDSDeviceInformation

- (instancetype)initWithDictionary:(NSDictionary<NSString *, id> *)deviceInformationDict {
    self = [super init];
    if (self) {
        _dictionaryValue = [deviceInformationDict copy];
    }

    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ : %@", [super description], _dictionaryValue];
}

@end

NS_ASSUME_NONNULL_END
