//
//  GPTDSChallengeParameters.m
//  Guavapay3DS2
//

#import "GPTDSChallengeParameters.h"

#import "GPTDSPackedSDKChallengeParameters.h"
#import "NSString+JWEHelpers.h"
#import "GPTDSAuthenticationResponse.h"

NS_ASSUME_NONNULL_BEGIN

@implementation GPTDSChallengeParameters

- (instancetype)initWithAuthenticationResponse:(id<GPTDSAuthenticationResponse>)authResponse {
    self = [self init];
    if (self) {
        _threeDSServerTransactionID = [authResponse.threeDSServerTransactionID copy];
        _acsTransactionID = [authResponse.acsTransactionID copy];
        _acsReferenceNumber = [authResponse.acsReferenceNumber copy];
        _acsSignedContent = [authResponse.acsSignedContent copy];
    }

    return self;
}

- (nullable instancetype)initWithPackedSDKString:(NSString *)packedSDKString
                                 requestorAppURL:(NSString *)requestorAppURL {
    NSData *packedSDKData = [packedSDKString _gptds_base64URLDecodedData];
    if (!packedSDKData) {
        return nil;
    }

    NSError *error = nil;
    NSDictionary *packedSDKDict = [NSJSONSerialization JSONObjectWithData:packedSDKData
                                                                  options:0
                                                                    error:&error];
    if (error || ![packedSDKDict isKindOfClass:[NSDictionary class]]) {
        return nil;
    }

    GPTDSPackedSDKChallengeParameters *packedSDK = [[GPTDSPackedSDKChallengeParameters alloc] initWithDictionary:packedSDKDict];
    if (!packedSDK) {
        return nil;
    }

    self = [self init];
    if (self) {
        self.threeDSServerTransactionID = packedSDK.threeDsServerTransactionId;
        self.acsReferenceNumber       = packedSDK.acsRefNumber;
        self.acsSignedContent         = packedSDK.acsSignedContent;
        self.acsTransactionID         = packedSDK.acsTransactionId;

        self.threeDSRequestorAppURL   = requestorAppURL;
    }
    return self;
}

@end

NS_ASSUME_NONNULL_END
