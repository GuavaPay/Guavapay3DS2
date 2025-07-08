//
//  GPTDSAuthenticationRequestParameters.m
//  Guavapay3DS2
//

#import "GPTDSAuthenticationRequestParameters.h"

NS_ASSUME_NONNULL_BEGIN

@interface GPTDSAuthenticationRequestParameters ()

@property (nonatomic, nullable, readonly) NSDictionary *sdkEphemeralPublicKeyJSON;

@end

@implementation GPTDSAuthenticationRequestParameters

- (instancetype)initWithSDKTransactionIdentifier:(NSString *)sdkTransactionIdentifier
                                      deviceData:(nullable NSString *)deviceData
                           sdkEphemeralPublicKey:(NSString *)sdkEphemeralPublicKey
                                sdkAppIdentifier:(NSString *)sdkAppIdentifier
                              sdkReferenceNumber:(NSString *)sdkReferenceNumber
                                  messageVersion:(NSString *)messageVersion {
    self = [super init];
    if (self) {
        _sdkTransactionIdentifier = [sdkTransactionIdentifier copy];
        _deviceData = [deviceData copy];
        _sdkEphemeralPublicKey = [sdkEphemeralPublicKey copy];
        _sdkAppIdentifier = [sdkAppIdentifier copy];
        _sdkReferenceNumber = [sdkReferenceNumber copy];
        _messageVersion = [messageVersion copy];
    }
    return self;
}

- (nullable NSDictionary *)sdkEphemeralPublicKeyJSON {
    NSData *data = [self.sdkEphemeralPublicKey dataUsingEncoding:NSUTF8StringEncoding];
    if (data == nil) {
        return nil;
    }

    return [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
}

#pragma mark - GPTDSJSONEncodable

+ (NSDictionary *)propertyNamesToJSONKeysMapping {
    return @{
             NSStringFromSelector(@selector(sdkTransactionIdentifier)): @"sdkTransactionId",
             NSStringFromSelector(@selector(deviceData)): @"deviceData",
             NSStringFromSelector(@selector(sdkEphemeralPublicKey)): @"sdkEphemeralPublicKey",
             NSStringFromSelector(@selector(sdkAppIdentifier)): @"sdkAppId",
             NSStringFromSelector(@selector(sdkReferenceNumber)): @"sdkReferenceNumber",
             NSStringFromSelector(@selector(messageVersion)): @"messageVersion",
             };
}

@end

NS_ASSUME_NONNULL_END
