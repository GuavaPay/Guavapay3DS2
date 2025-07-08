//
//  GPTDSEphemeralKeyPair.m
//  Guavapay3DS2
//

#import "GPTDSEphemeralKeyPair.h"

#import "NSData+JWEHelpers.h"
#import "NSDictionary+DecodingHelpers.h"
#import "NSString+JWEHelpers.h"
#import "GPTDSDirectoryServerCertificate.h"
#import "GPTDSEllipticCurvePoint.h"
#import "GPTDSSecTypeUtilities.h"

NS_ASSUME_NONNULL_BEGIN

@interface GPTDSEphemeralKeyPair ()
{
    SecKeyRef _privateKey;
    SecKeyRef _publicKey;
}

@end


@implementation GPTDSEphemeralKeyPair

- (instancetype)_initWithPrivateKey:(SecKeyRef)privateKey publicKey:(SecKeyRef)publicKey {
    self = [super init];
    if (self) {
        _privateKey = privateKey;
        _publicKey = publicKey;
    }
    
    return self;
}

+ (nullable instancetype)ephemeralKeyPair {
    NSDictionary *parameters = @{
        (__bridge NSString *)kSecAttrKeyType: (__bridge NSString *)kSecAttrKeyTypeECSECPrimeRandom,
        (__bridge NSString *)kSecAttrKeySizeInBits: @(256),
    };
    CFErrorRef error = NULL;
    SecKeyRef privateKey = SecKeyCreateRandomKey((__bridge CFDictionaryRef)parameters, &error);
    
    if (privateKey != NULL) {
        SecKeyRef publicKey = SecKeyCopyPublicKey(privateKey);
        return [[self alloc] _initWithPrivateKey:privateKey publicKey:publicKey];
    }
    
    return nil;
}

+ (nullable instancetype)testKeyPair {
    
    // values from EMVCo_3DS_-AppBased_CryptoExamples_082018.pdf
    NSData *d = [@"iyn--IbkBeNoPu8cN245L6pOQWt2lTH8V0Ds92jQmWA" _gptds_base64URLDecodedData];
    NSData *x = [@"C1PL42i6kmNkM61aupEAgLJ4gF1ZRzcV7lqo1TG0mL4" _gptds_base64URLDecodedData];
    NSData *y = [@"cNToWLSdcFQKG--PGVEUQrIHP8w6TcRyj0pyFx4-ZMc" _gptds_base64URLDecodedData];
    
    SecKeyRef privateKey = GPTDSPrivateSecKeyRefFromCoordinates(x, y, d);
    if (privateKey == NULL) {
        return nil;
    }
    SecKeyRef publicKey = SecKeyCopyPublicKey(privateKey);
    if (publicKey == NULL) {
        return nil;
    }
    
    return [[GPTDSEphemeralKeyPair alloc] _initWithPrivateKey:privateKey publicKey:publicKey];
}

- (void)dealloc {
    if (_privateKey != NULL) {
        CFRelease(_privateKey);
    }
    if (_publicKey != NULL) {
        CFRelease(_publicKey);
    }
}

- (NSString *)publicKeyJWK {
    GPTDSEllipticCurvePoint *publicKeyCurvePoint = [[GPTDSEllipticCurvePoint alloc] initWithKey:_publicKey];
    return [NSString stringWithFormat:@"{\"kty\":\"EC\",\"crv\":\"P-256\",\"x\":\"%@\",\"y\":\"%@\"}", [publicKeyCurvePoint.x _gptds_base64URLEncodedString], [publicKeyCurvePoint.y _gptds_base64URLEncodedString]];
}

- (nullable NSData *)createSharedSecretWithEllipticCurveKey:(GPTDSEllipticCurvePoint *)ecKey {
    return [self _createSharedSecretWithPrivateKey:_privateKey publicKey:ecKey.publicKey];
}

- (nullable NSData *)createSharedSecretWithCertificate:(GPTDSDirectoryServerCertificate *)certificate {
    return [self _createSharedSecretWithPrivateKey:_privateKey publicKey:certificate.publicKey];
}

- (nullable NSData *)_createSharedSecretWithPrivateKey:(SecKeyRef)privateKey publicKey:(SecKeyRef)publicKey {
    NSDictionary *params = @{(__bridge NSString *)kSecKeyKeyExchangeParameterRequestedSize: @(32)};
    CFErrorRef error = NULL;
    CFDataRef secret = SecKeyCopyKeyExchangeResult(privateKey, kSecKeyAlgorithmECDHKeyExchangeStandard, publicKey, (__bridge CFDictionaryRef)params, &error);
    
    return (NSData *)CFBridgingRelease(secret);
}

@end

NS_ASSUME_NONNULL_END
