//
//  GPTDSJSONWebEncryption.m
//  Guavapay3DS2
//

#import "GPTDSJSONWebEncryption.h"

#import <CommonCrypto/CommonCrypto.h>
#import <Security/Security.h>

#import "NSData+JWEHelpers.h"
#import "NSError+Guavapay3DS2.h"
#import "NSString+JWEHelpers.h"
#import "GPTDSDirectoryServerCertificate.h"
#import "GPTDSEphemeralKeyPair.h"
#import "GPTDSJSONWebSignature.h"
#import "GPTDSSecTypeUtilities.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - _GPTDSJSONWebEncryptionResult
@interface _GPTDSJSONWebEncryptionResult : NSObject

- (instancetype)initWithCiphertext:(NSData *)ciphertextData
              initializationVector:(NSData *)initializationVector
                           hmacTag:(NSData *)hmacTag;

@property (nonatomic, copy, readonly) NSData *ciphertextData;
@property (nonatomic, copy, readonly) NSData *initializationVector;
@property (nonatomic, copy, readonly) NSData *hmacTag;

@end

@implementation _GPTDSJSONWebEncryptionResult

- (instancetype)initWithCiphertext:(NSData *)ciphertextData
              initializationVector:(NSData *)initializationVector
                           hmacTag:(NSData *)hmacTag {
    self = [super init];
    if (self) {
        _ciphertextData = [ciphertextData copy];
        _initializationVector = [initializationVector copy];
        _hmacTag = [hmacTag copy];
    }

    return self;
}

@end

#pragma mark - GPTDSJSONWebEncryption

static const size_t kContentEncryptionKeyByteCount = 32;
static const size_t kHMACSubKeyByteCount = 16;
static const size_t kAESSubKeyByteCount = 16;

@implementation GPTDSJSONWebEncryption

+ (nullable NSString *)encryptJSON:(NSDictionary *)json
                forDirectoryServer:(GPTDSDirectoryServer)directoryServer
                             error:(out NSError *__autoreleasing  _Nullable * _Nullable)error {

    NSString *ciphertext = nil;

    GPTDSDirectoryServerCertificate *certificate = [GPTDSDirectoryServerCertificate certificateForDirectoryServer:directoryServer];
    NSString *directoryServerID = GPTDSDirectoryServerIdentifier(directoryServer);

    if (certificate != nil && directoryServerID != nil) {

        ciphertext = [self encryptJSON:json
                       withCertificate:certificate
                      directoryServerID:directoryServerID
                           serverKeyID:nil
                                 error:error];
    }

    if (error != nil && ciphertext == nil) {
        *error = *error ?: [NSError _gptds_jweError];
    }

    return ciphertext;
}

+ (nullable NSString *)encryptJSON:(NSDictionary *)json
                   withCertificate:(GPTDSDirectoryServerCertificate *)certificate
                 directoryServerID:(NSString *)directoryServerID
                       serverKeyID:(nullable NSString *)serverKeyID
                             error:(out NSError * _Nullable *)error {

    NSString *ciphertext = nil;
    NSError *jsonError = nil;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:json options:0 error:&jsonError];

    if (jsonData != nil) {

        switch (certificate.keyType) {
            case GPTDSDirectoryServerKeyTypeRSA:
                ciphertext = [self _RSAEncryptPlaintext:jsonData
                                        withCertificate:certificate
                                            serverKeyID:serverKeyID];
                break;

            case GPTDSDirectoryServerKeyTypeEC:
                ciphertext = [self _directEncryptPlaintext:jsonData
                                           withCertificate:certificate
                                        forDirectoryServer:directoryServerID];
                break;

            case GPTDSDirectoryServerKeyTypeUnknown:
                break;
        }
    }

    if (error != nil && ciphertext == nil) {
        *error = jsonError ?: [NSError _gptds_jweError];
    }

    return ciphertext;
}

+ (nullable NSString *)directEncryptJSON:(NSDictionary *)json
                withContentEncryptionKey:(NSData *)contentEncryptionKey
                     forACSTransactionID:(NSString *)acsTransactionID
                                   error:(out NSError * _Nullable *)error {
    NSString *ciphertext = nil;

    NSError *jsonError = nil;


    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:json options:0 error:&jsonError];

    if (jsonData != nil) {
        NSString *headerString = [NSString stringWithFormat:@"{\"kid\":\"%@\",\"enc\":\"A128CBC-HS256\",\"alg\":\"dir\"}", acsTransactionID];
        ciphertext = [self _directEncryptPlaintext:jsonData
                          withContentEncryptionKey:contentEncryptionKey
                                      headerString:headerString];
    }

    if (error != nil && ciphertext == nil) {
        *error = jsonError ?: [NSError _gptds_jweError];
    }

    return ciphertext;
}

+ (nullable NSData *)_hmacTagWithKey:(NSData *)hmacSubKey
                        headerString:(NSString *)headerString
                initializationVector:(NSData *)initializationVector
                          cipherText:(NSData *)cipherText {
    NSString *encodedHeaderString = [headerString _gptds_base64URLEncodedString];

    // Per JWE spec, the encoded header data is included as additional authenticated data but with ASCII encoding https://tools.ietf.org/html/rfc7516#section-5.1
    NSData *additionalAuthenticatedData = [encodedHeaderString dataUsingEncoding:NSASCIIStringEncoding];
    uint64_t AL = CFSwapInt64HostToBig(additionalAuthenticatedData.length*8);

    NSMutableData *d = [NSMutableData data];
    [d appendBytes:additionalAuthenticatedData.bytes length:additionalAuthenticatedData.length];
    [d appendBytes:initializationVector.bytes length:initializationVector.length];
    [d appendBytes:cipherText.bytes length:cipherText.length];
    [d appendBytes:&AL length:sizeof(AL)];

    NSMutableData *M = [[NSMutableData alloc] initWithLength:CC_SHA256_DIGEST_LENGTH];

    CCHmac(kCCHmacAlgSHA256,
           hmacSubKey.bytes,
           kHMACSubKeyByteCount,
           d.bytes,
           d.length,
           M.mutableBytes);


    NSData *hmacTag = [M subdataWithRange:NSMakeRange(0, 16)];

    return hmacTag;
}

+ (nullable _GPTDSJSONWebEncryptionResult *)_encryptPlaintext:(NSData *)plaintextData
                                                    withKey:(NSData *)contentEncryptionKeyData
                                               headerString:(NSString *)headerString {
    // ecrypt JSON according to JWE (RFC 7516) using JWE Compact Serialization
    // enc: A128CBC-HS256

    // Ref: rfc7518 sec 5.2.3 https://www.rfc-editor.org/rfc/rfc7518.txt

    _GPTDSJSONWebEncryptionResult *result = nil;

    static const size_t kInitializationVectorByteCount = 16;

    NSAssert(contentEncryptionKeyData.length == kContentEncryptionKeyByteCount, @"Must use a valid 256 content encryption key");
    if (contentEncryptionKeyData.length == kContentEncryptionKeyByteCount) {

        NSData *hmacSubKeyData = [contentEncryptionKeyData subdataWithRange:NSMakeRange(0, kHMACSubKeyByteCount)];
        NSData *aesSubKeyData = [contentEncryptionKeyData subdataWithRange:NSMakeRange(kHMACSubKeyByteCount, kAESSubKeyByteCount)];
        NSData *initializationVectorData = GPTDSCryptoRandomData(kInitializationVectorByteCount);


        // pad with block size for AES
        NSMutableData *ciphertextData = [NSMutableData dataWithLength:plaintextData.length + kCCBlockSizeAES128];
        size_t outLength;
        CCCryptorStatus aesEncryptionResult =  CCCrypt(kCCEncrypt,
                                                       kCCAlgorithmAES,
                                                       kCCOptionPKCS7Padding,
                                                       aesSubKeyData.bytes,
                                                       kAESSubKeyByteCount,
                                                       initializationVectorData.bytes,
                                                       plaintextData.bytes,
                                                       (size_t)plaintextData.length,
                                                       ciphertextData.mutableBytes,
                                                       ciphertextData.length,
                                                       &outLength);
        if (aesEncryptionResult == kCCSuccess) {
            ciphertextData.length = outLength;

            NSData *hmacTag = [self _hmacTagWithKey:hmacSubKeyData
                                       headerString:headerString
                               initializationVector:initializationVectorData
                                         cipherText:ciphertextData];

            result = [[_GPTDSJSONWebEncryptionResult alloc] initWithCiphertext:ciphertextData
                                                        initializationVector:initializationVectorData
                                                                     hmacTag:hmacTag];
        }
    }

    return result;
}

+ (nullable NSString *)_RSAEncryptPlaintext:(NSData *)plaintextData
                            withCertificate:(GPTDSDirectoryServerCertificate *)certificate
                                serverKeyID:(nullable NSString *)serverKeyID {
    NSData *contentEncryptionKey = GPTDSCryptoRandomData(kContentEncryptionKeyByteCount);
    if (contentEncryptionKey != nil) {
        NSString *headerString = nil;

        if (serverKeyID != nil) {
            headerString = [NSString stringWithFormat:@"{\"enc\":\"A128CBC-HS256\",\"alg\":\"RSA-OAEP-256\",\"kid\":\"%@\"}", serverKeyID];
        } else {
            headerString = @"{\"enc\":\"A128CBC-HS256\",\"alg\":\"RSA-OAEP-256\"}";

        }
        _GPTDSJSONWebEncryptionResult *encryptedData = [self _encryptPlaintext:plaintextData
                                                                     withKey:contentEncryptionKey
                                                                headerString:headerString];
        if (encryptedData != nil) {
            NSData *encryptedCEK = [certificate encryptDataUsingRSA_OAEP_SHA256:contentEncryptionKey];
            if (encryptedCEK != nil) {
                return [NSString stringWithFormat:@"%@.%@.%@.%@.%@", [headerString _gptds_base64URLEncodedString], [encryptedCEK _gptds_base64URLEncodedString], [encryptedData.initializationVector _gptds_base64URLEncodedString], [encryptedData.ciphertextData _gptds_base64URLEncodedString], [encryptedData.hmacTag _gptds_base64URLEncodedString]];
            }
        }
    }

    return nil;
}

+ (nullable NSString *)_directEncryptPlaintext:(NSData *)plaintextData
                               withCertificate:(GPTDSDirectoryServerCertificate *)certificate
                            forDirectoryServer:(NSString *)directoryServerID {

    GPTDSEphemeralKeyPair *ephemeralKeyPair = [GPTDSEphemeralKeyPair ephemeralKeyPair];
    NSData *rawSharedSecret = [ephemeralKeyPair createSharedSecretWithCertificate:certificate];
    NSData *contentEncryptionKey = GPTDSCreateConcatKDFWithSHA256(rawSharedSecret, kContentEncryptionKeyByteCount, directoryServerID);

    NSString *headerString = [NSString stringWithFormat:@"{\"enc\":\"A128CBC-HS256\",\"alg\":\"ECDH-ES\",\"epk\":%@}", ephemeralKeyPair.publicKeyJWK];

    return [self _directEncryptPlaintext:plaintextData
                withContentEncryptionKey:contentEncryptionKey
                            headerString:headerString];
}

+ (nullable NSString *)_directEncryptPlaintext:(NSData *)plaintextData
                      withContentEncryptionKey:(NSData *)contentEncryptionKey
                                  headerString:(NSString *)headerString {

    _GPTDSJSONWebEncryptionResult *encryptedData = [self _encryptPlaintext:plaintextData
                                                                 withKey:contentEncryptionKey
                                                            headerString:headerString];
    if (encryptedData != nil) {
        return [NSString stringWithFormat:@"%@..%@.%@.%@", [headerString _gptds_base64URLEncodedString], [encryptedData.initializationVector _gptds_base64URLEncodedString], [encryptedData.ciphertextData _gptds_base64URLEncodedString], [encryptedData.hmacTag _gptds_base64URLEncodedString]];
    }

    return nil;
}

#pragma mark - Decryption

+ (nullable NSDictionary *)decryptData:(NSData *)data
              withContentEncryptionKey:(NSData *)contentEncryptionKey
                                 error:(out NSError * _Nullable *)error {
    NSString *jweString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSArray<NSString *> *jweComponents = [jweString componentsSeparatedByString:@"."];
    if (jweComponents.count != 5) {

        // Data may be JSON describing error
        NSError *jsonError = nil;
        NSDictionary *errorJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        if (errorJSON != nil) {
            return errorJSON;
        }
        if (error != NULL) {
            *error = jsonError ?: [NSError _gptds_jweError];
        }
        return nil;
    }

    NSString *headerString = [jweComponents[0] _gptds_base64URLDecodedString];
    NSData *initializationVector = [jweComponents[2] _gptds_base64URLDecodedData];
    NSData *ciphertextData = [jweComponents[3] _gptds_base64URLDecodedData];
    NSData *hmacTag = [jweComponents[4] _gptds_base64URLDecodedData];

    if (headerString == nil ||
        initializationVector == nil ||
        ciphertextData == nil ||
        hmacTag == nil
        ) {
        if (error != NULL) {
            *error = [NSError _gptds_jweError];
        }
        return nil;
    }
    NSAssert(contentEncryptionKey.length == kContentEncryptionKeyByteCount, @"Must use a valid 256 content encryption key");
    if (contentEncryptionKey.length != kContentEncryptionKeyByteCount) {
        if (error != NULL) {
            *error = [NSError _gptds_jweError];
        }
        return nil;
    }

    NSData *hmacSubKeyData = [contentEncryptionKey subdataWithRange:NSMakeRange(0, kHMACSubKeyByteCount)];
    NSData *aesSubKeyData = [contentEncryptionKey subdataWithRange:NSMakeRange(kHMACSubKeyByteCount, kAESSubKeyByteCount)];

    // pad with block size for AES
    NSMutableData *plaintextData = [NSMutableData dataWithLength:ciphertextData.length + kCCBlockSizeAES128];
    size_t outLength;
    CCCryptorStatus aesDecryptionResult =  CCCrypt(kCCDecrypt,
                                                   kCCAlgorithmAES,
                                                   kCCOptionPKCS7Padding,
                                                   aesSubKeyData.bytes,
                                                   kAESSubKeyByteCount,
                                                   initializationVector.bytes,
                                                   ciphertextData.bytes,
                                                   (size_t)ciphertextData.length,
                                                   plaintextData.mutableBytes,
                                                   plaintextData.length,
                                                   &outLength);

    if (aesDecryptionResult != kCCSuccess) {
        if (error != NULL) {
            *error = [NSError _gptds_jweError];
        }
        return nil;
    }

    plaintextData.length = outLength;
    NSData *calculatedHMACTag = [self _hmacTagWithKey:hmacSubKeyData
                                         headerString:headerString
                                 initializationVector:initializationVector
                                           cipherText:ciphertextData];

    if (![calculatedHMACTag isEqualToData:hmacTag]) {
        if (error != NULL) {
            *error = [NSError _gptds_jweError];
        }
        return nil;
    }

    NSDictionary *decryptedJSON = [NSJSONSerialization JSONObjectWithData:plaintextData
                                                                  options:0
                                                                    error:error];
    if (*error != NULL) {
        *error = [NSError _gptds_jweError];
        return nil;
    }
    
    return decryptedJSON;
}

#pragma mark - JSON Web Signature Verification

+ (BOOL)verifyJSONWebSignature:(GPTDSJSONWebSignature *)jws forDirectoryServer:(GPTDSDirectoryServer)directoryServer {
    GPTDSDirectoryServerCertificate *certificate = [GPTDSDirectoryServerCertificate certificateForDirectoryServer:directoryServer];
    NSString *certificateString = nil;
    
    if (directoryServer == GPTDSDirectoryServerULTestRSA || directoryServer == GPTDSDirectoryServerULTestEC) {
        // for UL tests, the last certificate in the chain is the anchor/root
        certificateString = jws.certificateChain.lastObject;
    } else {
        NSAssert(0, @"We shouldn't be using this path outside of UL testing");
        certificateString = certificate.certificateString;
    }
    
    if (certificateString == nil) {
        return NO;
    }

    return [self verifyJSONWebSignature:jws withCertificate:certificate rootCertificates:@[certificateString]];
}

+ (BOOL)verifyJSONWebSignature:(GPTDSJSONWebSignature *)jws withCertificate:(__unused GPTDSDirectoryServerCertificate *)certificate rootCertificates:(NSArray<NSString *> *)rootCertificates {
    return [GPTDSDirectoryServerCertificate verifyJSONWebSignature:jws withRootCertificates:rootCertificates];
}

@end

NS_ASSUME_NONNULL_END
