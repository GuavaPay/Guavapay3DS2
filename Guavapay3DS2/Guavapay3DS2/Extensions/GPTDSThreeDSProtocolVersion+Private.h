//
//  GPTDSThreeDSProtocolVersion+Private.h
//  Guavapay3DS2
//

#import "GPTDSThreeDSProtocolVersion.h"

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSInteger, GPTDSThreeDSProtocolVersion) {
    GPTDSThreeDSProtocolVersion2_1_0,
    GPTDSThreeDSProtocolVersion2_2_0,
    GPTDSThreeDSProtocolVersionUnknown,
    GPTDSThreeDSProtocolVersionFallbackTest,
};

static NSString * const kThreeDS2ProtocolVersion2_1_0 = @"2.1.0";
static NSString * const kThreeDS2ProtocolVersion2_2_0 = @"2.2.0";
static NSString * const kThreeDSProtocolVersionFallbackTest = @"2.0.0";

NS_INLINE GPTDSThreeDSProtocolVersion GPTDSThreeDSProtocolVersionForString(NSString *stringValue) {
    if ([stringValue isEqualToString:kThreeDS2ProtocolVersion2_1_0]) {
        return GPTDSThreeDSProtocolVersion2_1_0;
    } else if ([stringValue isEqualToString:kThreeDS2ProtocolVersion2_2_0]) {
        return GPTDSThreeDSProtocolVersion2_2_0;
    } else if ([stringValue isEqualToString:kThreeDSProtocolVersionFallbackTest]) {
        return GPTDSThreeDSProtocolVersionFallbackTest;
    } else {
        return GPTDSThreeDSProtocolVersionUnknown;
    }
}

NS_INLINE NSString * _Nullable GPTDSThreeDSProtocolVersionStringValue(GPTDSThreeDSProtocolVersion protocolVersion) {
    switch (protocolVersion) {
        case GPTDSThreeDSProtocolVersion2_1_0:
            return kThreeDS2ProtocolVersion2_1_0;

        case GPTDSThreeDSProtocolVersion2_2_0:
            return kThreeDS2ProtocolVersion2_2_0;

        case GPTDSThreeDSProtocolVersionFallbackTest:
            return kThreeDSProtocolVersionFallbackTest;

        case GPTDSThreeDSProtocolVersionUnknown:
            return nil;
    }
}

NS_ASSUME_NONNULL_END
