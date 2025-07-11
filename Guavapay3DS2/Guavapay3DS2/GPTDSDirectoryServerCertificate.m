//
//  GPTDSDirectoryServerCertificate.m
//  Guavapay3DS2
//

#import "GPTDSDirectoryServerCertificate.h"
#import "GPTDSDirectoryServerCertificate+Internal.h"

#import "NSData+JWEHelpers.h"
#import "NSString+JWEHelpers.h"
#import "GPTDSEllipticCurvePoint.h"
#import "GPTDSJSONWebSignature.h"
#import "GPTDSSecTypeUtilities.h"

NS_ASSUME_NONNULL_BEGIN

@interface GPTDSDirectoryServerCertificate ()
{
    SecCertificateRef _certificate;
    GPTDSDirectoryServer _directoryServer;
}

- (instancetype)_initForDirectoryServer:(GPTDSDirectoryServer)directoryServer;

@end

@implementation GPTDSDirectoryServerCertificate

- (instancetype)_initWithCertificate:(SecCertificateRef _Nullable)certificate forDirectorySever:(GPTDSDirectoryServer)directoryServer {
    self = [super init];
    if (self) {
        _certificate = certificate;
        switch (directoryServer) {

            case GPTDSDirectoryServerULTestRSA: {
                /**
                 UL provides the following, which is PKCS#8, but Security framework wants PKCS#1. Luckily all we have to do is remove the first 32 characters which are just a header to convert
                 @"-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAr/O0BfXWngO9OJDBsqdR\n5U2h28jrX6Y+LlblTBaYeT2tW7+ca3YzTFXA8duVUwdlWxl3JZCOOeL1feVP6g0TNOHVCkCnirVDLkcozod4aSkNvx+929aDr1ithqhruf0skBc2sMZGBBCNpso6XGzyAf2uZ2+9DvXoKIUYgcr7PQmL2Y0awyQN7KCRcusaotYNz2mOPrL/hAv6hTexkNrQ\nKzFcPwCuc6kN6aNjD+p2CJ51/5p02SNS70nPOmwmg63j6f3n7xVykQ56kNc1l5B5xOpeHJmqk3+hyF1dF/47rQmMFicN41QSvZ5AZJKgWlIn2VQROMkEHkF9ZBRLx1nF\nTwIDAQAB\n-----END PUBLIC KEY-----\n"
                 */
                static NSString * const kULTestRSAPublicKey = @"MIIBCgKCAQEAr/O0BfXWngO9OJDBsqdR\n5U2h28jrX6Y+LlblTBaYeT2tW7+ca3YzTFXA8duVUwdlWxl3JZCOOeL1feVP6g0TNOHVCkCnirVDLkcozod4aSkNvx+929aDr1ithqhruf0skBc2sMZGBBCNpso6XGzyAf2uZ2+9DvXoKIUYgcr7PQmL2Y0awyQN7KCRcusaotYNz2mOPrL/hAv6hTexkNrQ\nKzFcPwCuc6kN6aNjD+p2CJ51/5p02SNS70nPOmwmg63j6f3n7xVykQ56kNc1l5B5xOpeHJmqk3+hyF1dF/47rQmMFicN41QSvZ5AZJKgWlIn2VQROMkEHkF9ZBRLx1nF\nTwIDAQAB";

                NSString *cleanedString = [[[kULTestRSAPublicKey stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];

                NSData *base64Decoded = [[NSData alloc] initWithBase64EncodedString:cleanedString options:0];
                NSDictionary *attributes = @{
                    (__bridge NSString *)kSecAttrKeyType: (__bridge NSString *)kSecAttrKeyTypeRSA,
                    (__bridge NSString *)kSecAttrKeyClass: (__bridge NSString *)kSecAttrKeyClassPublic,
                };
                CFErrorRef error = NULL;
                SecKeyRef key = SecKeyCreateWithData((__bridge CFDataRef)base64Decoded, (__bridge CFDictionaryRef)attributes, &error);
                if (key == NULL) {
                    return nil;
                }
                _publicKey = key;
            }
                break;
                
            case GPTDSDirectoryServerULTestEC: {
                static NSString * const kULTestECPublicKey = @"MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAEYktbLuAv0v52erE5LPscomKaOmQs\nvevxzOyn9k4sF1hqpBc5kUygzxA9Jl0R/2dTuk8ka7UCujk36xeUsLVpWA==";
                NSString *cleanedString = [[[kULTestECPublicKey stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
                NSData *base64Decoded = [[NSData alloc] initWithBase64EncodedString:cleanedString options:0];
                // This data is PEM encoded, to get to ec standard we take the last 65 bytes
                if (base64Decoded.length >= 65) {
                    base64Decoded = [base64Decoded subdataWithRange:NSMakeRange(base64Decoded.length - 65, 65)];
                }
                NSDictionary *attributes = @{
                    (__bridge NSString *)kSecAttrKeyType: (__bridge NSString *)kSecAttrKeyTypeECSECPrimeRandom,
                    (__bridge NSString *)kSecAttrKeyClass: (__bridge NSString *)kSecAttrKeyClassPublic,
                };
                CFErrorRef error = NULL;
                SecKeyRef key = SecKeyCreateWithData((__bridge CFDataRef)base64Decoded, (__bridge CFDictionaryRef)attributes, &error);
                if (key == NULL) {
                    return nil;
                }
                _publicKey = key;
            }
                break;
                
            case GPTDSDirectoryServerSTPTestRSA:
                // fall-through
            case GPTDSDirectoryServerSTPTestEC:
                // fall-through
            case GPTDSDirectoryServerAmex:
                // fall-through
            case GPTDSDirectoryServerCartesBancaires:
                // fall-through
            case GPTDSDirectoryServerDiscover:
                // fall-through
            case GPTDSDirectoryServerMastercard:
                // fall-through
            case GPTDSDirectoryServerVisa:
                // fall-through
            case GPTDSDirectoryServerCustom:
                // fall-through
            case GPTDSDirectoryServerUnknown:
                NSAssert(certificate != NULL, @"Must provide a certificate");
                _publicKey = SecCertificateCopyKey(certificate);
        }
        _directoryServer = directoryServer;
        
        if (_publicKey == NULL) {
            return nil;
        }
    }
    
    return self;
}

- (instancetype)_initForDirectoryServer:(GPTDSDirectoryServer)directoryServer {
    SecCertificateRef certificate = NULL;

    switch (directoryServer) {
        case GPTDSDirectoryServerULTestRSA:
            // fall-through
        case GPTDSDirectoryServerULTestEC:
            // The UL test servers don't actually have certificates, just hard-coded key values
            break;
            
        case GPTDSDirectoryServerSTPTestRSA:
            // fall-through
        case GPTDSDirectoryServerSTPTestEC:
            // fall-through
        case GPTDSDirectoryServerAmex:
            // fall-through
        case GPTDSDirectoryServerCartesBancaires:
            // fall-through
        case GPTDSDirectoryServerDiscover:
            // fall-through;
        case GPTDSDirectoryServerMastercard:
            // fall-through
        case GPTDSDirectoryServerVisa: {
            certificate = GPTDSCertificateForServer(directoryServer);
            if (certificate == NULL) {
                return nil;
            }
        }
            break;
            
        case GPTDSDirectoryServerCustom:
            return nil;
            
        case GPTDSDirectoryServerUnknown:
            return nil;
    }
    return [self _initWithCertificate:certificate forDirectorySever:directoryServer];
}

+ (nullable instancetype)certificateForDirectoryServer:(GPTDSDirectoryServer)directoryServer {
    return [[self alloc] _initForDirectoryServer:directoryServer];
}

+ (nullable instancetype)customCertificateWithData:(NSData *)certificateData {
    SecCertificateRef certificate = GPTDSSecCertificateFromData(certificateData);
    if (certificate == NULL) {
        return nil;
    }
    return [[self alloc] _initWithCertificate:certificate forDirectorySever:GPTDSDirectoryServerCustom];
}

+ (nullable instancetype)customCertificateWithString:(NSString *)certificateString {
    SecCertificateRef certificate = GPTDSSecCertificateFromString(certificateString);
    if (certificate == NULL) {
        return nil;
    }
    
    return [[self alloc] _initWithCertificate:certificate forDirectorySever:GPTDSDirectoryServerCustom];
}

- (void)dealloc {
    if (_certificate != NULL) {
        CFRelease(_certificate);
    }
    if (_publicKey != NULL) {
        CFRelease(_publicKey);
    }
}

- (NSString *)certificateString {
    NSData *data = (NSData *)CFBridgingRelease(SecCertificateCopyData(_certificate));
    return [data base64EncodedStringWithOptions:0];
}

- (GPTDSDirectoryServerKeyType)keyType {
    switch (_directoryServer) {
        case GPTDSDirectoryServerULTestRSA:
            return GPTDSDirectoryServerKeyTypeRSA;

        case GPTDSDirectoryServerULTestEC:
            return GPTDSDirectoryServerKeyTypeEC;


        case GPTDSDirectoryServerSTPTestRSA:
            // fall-through
        case GPTDSDirectoryServerSTPTestEC:
            // fall-through
        case GPTDSDirectoryServerAmex:
            // fall-through
        case GPTDSDirectoryServerCartesBancaires:
            // fall-through
        case GPTDSDirectoryServerDiscover:
            // fall-through;
        case GPTDSDirectoryServerMastercard:
            // fall-through
        case GPTDSDirectoryServerVisa:
            // fall-through
        case GPTDSDirectoryServerCustom: {
            NSAssert(_certificate != NULL, @"Must have a valid certificate file");
            if (_certificate == NULL) {
                return GPTDSDirectoryServerKeyTypeUnknown;
            }
            CFStringRef keyType = GPTDSSecCertificateCopyPublicKeyType(_certificate);
            GPTDSDirectoryServerKeyType ret = GPTDSDirectoryServerKeyTypeUnknown;
            if (keyType != NULL) {
                if (CFStringCompare(keyType, kSecAttrKeyTypeRSA, 0) == kCFCompareEqualTo) {
                    ret = GPTDSDirectoryServerKeyTypeRSA;
                } else if (CFStringCompare(keyType, kSecAttrKeyTypeECSECPrimeRandom, 0) == kCFCompareEqualTo) {
                    ret = GPTDSDirectoryServerKeyTypeEC;
                }

                CFRelease(keyType);
            }
            return ret;
        }

        case GPTDSDirectoryServerUnknown:
            NSAssert(0, @"Should not have an GPTDSDirectoryServerCertificate instance withSTPDirectoryServerUnknown");
            return GPTDSDirectoryServerKeyTypeUnknown;
    }
}

- (nullable NSData *)encryptDataUsingRSA_OAEP_SHA256:(NSData *)plaintext {
    NSAssert(_publicKey != NULL, @"GPTDSDirectoryServerCertificate should always have _publicKey");
    if (_publicKey == NULL) {
        return nil;
    }
    
    CFDataRef encryptedData = SecKeyCreateEncryptedData(_publicKey,
                                                        kSecKeyAlgorithmRSAEncryptionOAEPSHA256,
                                                        (CFDataRef)plaintext,
                                                        NULL);
    return (NSData *)CFBridgingRelease(encryptedData);
}

+ (BOOL)_verifyCertificateChain:(NSArray<NSString *> *)certificatesStrings withRootCertificates:(NSArray<NSString *> *)rootCertificateStrings {
    if (certificatesStrings.count == 0 || rootCertificateStrings.count == 0) {
        return NO;
    }

    NSMutableArray *certificates = [[NSMutableArray alloc] initWithCapacity:certificatesStrings.count];
    for (NSString *certificateString in certificatesStrings) {
        SecCertificateRef certificate = GPTDSSecCertificateFromString(certificateString);
        if (certificate == NULL) {
            return NO;
        }
        [certificates addObject:(id)CFBridgingRelease(certificate)];
    }
    
    NSMutableArray *rootCertificates = [[NSMutableArray alloc] initWithCapacity:rootCertificateStrings.count];
    for (NSString *certificateString in rootCertificateStrings) {
        SecCertificateRef certificate = GPTDSSecCertificateFromString(certificateString);
        if (certificate == NULL) {
            return NO;
        }
        [rootCertificates addObject:(id)CFBridgingRelease(certificate)];
    }
    
    SecPolicyRef policy = SecPolicyCreateBasicX509();
    SecTrustRef trust;
    OSStatus status = SecTrustCreateWithCertificates((__bridge CFTypeRef)certificates,
                                                     policy,
                                                     &trust);
    if (policy) {
        CFRelease(policy);
    }
    if (status != errSecSuccess) {
        return NO;
    }
    if (rootCertificates.count > 0) {
        status = SecTrustSetAnchorCertificates(trust, (__bridge CFTypeRef)rootCertificates);
        if (status != errSecSuccess) {
            return NO;
        }
    }
    
    CFErrorRef error = NULL;

    bool verified = SecTrustEvaluateWithError(trust, &error);
    return (BOOL)verified;
}

+ (BOOL)verifyJSONWebSignature:(GPTDSJSONWebSignature *)jws withRootCertificates:(NSArray<NSString *> *)rootCertificates {
    if (jws.certificateChain.count == 0 || ![self _verifyCertificateChain:jws.certificateChain withRootCertificates:rootCertificates]) {
        return NO;
    }

    switch (jws.algorithm) {
        case GPTDSJSONWebSignatureAlgorithmES256:
            return GPTDSVerifyEllipticCurveP256Signature(jws.ellipticCurvePoint.x, jws.ellipticCurvePoint.y, jws.digest, jws.signature);

        case GPTDSJSONWebSignatureAlgorithmPS256: {
            if (jws.certificateChain.count == 0) {
                return NO;
            }
            NSString *certificateString = [jws.certificateChain firstObject];
            SecCertificateRef certificate = GPTDSSecCertificateFromString(certificateString);
            if (certificate == NULL) {
                return NO;
            }

            BOOL verified = GPTDSVerifyRSASignature(certificate, jws.digest, jws.signature);
            CFRelease(certificate);
            return verified;
        }


        case GPTDSJSONWebSignatureAlgorithmUnknown:
            return NO;
    }
}

@end

NS_ASSUME_NONNULL_END
