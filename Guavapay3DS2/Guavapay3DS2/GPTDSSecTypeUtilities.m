//
//  GPTDSSecTypeUtilities.m
//  Guavapay3DS2
//

#import "GPTDSSecTypeUtilities.h"

#import <CommonCrypto/CommonCrypto.h>
#import <CommonCrypto/CommonRandom.h>
#import <Security/Security.h>

#import "GPTDSBundleLocator.h"
#import "GPTDSEllipticCurvePoint.h"

NS_ASSUME_NONNULL_BEGIN

SecCertificateRef _Nullable GPTDSCertificateForServer(GPTDSDirectoryServer server) {
    static NSMutableDictionary<NSString *, NSData *> *sCertificateData = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sCertificateData = [[NSMutableDictionary alloc] init];
    });

    NSString *serverKey = nil;
    switch (server) {
        case GPTDSDirectoryServerULTestRSA:
            serverKey = @"GPTDSDirectoryServerULTestRSA";
            break;

        case GPTDSDirectoryServerULTestEC:
            serverKey = @"GPTDSDirectoryServerULTestEC";
            break;

        case GPTDSDirectoryServerSTPTestRSA:
            serverKey = @"GPTDSDirectoryServerSTPTestRSA";
            break;

        case GPTDSDirectoryServerSTPTestEC:
            serverKey = @"GPTDSDirectoryServerSTPTestEC";
            break;

        case GPTDSDirectoryServerAmex:
            serverKey = @"GPTDSDirectoryServerAmex";
            break;

        case GPTDSDirectoryServerDiscover:
            serverKey = @"GPTDSDirectoryServerDiscover";
            break;

        case GPTDSDirectoryServerMastercard:
            serverKey = @"GPTDSDirectoryServerMastercard";
            break;

        case GPTDSDirectoryServerVisa:
            serverKey = @"GPTDSDirectoryServerVisa";
            break;
            
        case GPTDSDirectoryServerCartesBancaires:
            serverKey = @"GPTDSDirectoryServerCartesBancaires";
            break;

        case GPTDSDirectoryServerCustom:
            break;

        case GPTDSDirectoryServerUnknown:
            break;
    }

    if (serverKey == nil) {
        return NULL;
    }

    NSData *certificateData = sCertificateData[serverKey];
    if (certificateData == nil) {
        NSString *certificatePath = nil;
        switch (server) {
            case GPTDSDirectoryServerULTestRSA:
                break;

            case GPTDSDirectoryServerULTestEC:
                break;

            case GPTDSDirectoryServerSTPTestRSA:
                certificatePath = [[GPTDSBundleLocator gptdsResourcesBundle] pathForResource:@"ul-test" ofType:@"der"];
                break;
                
            case GPTDSDirectoryServerSTPTestEC:
                certificatePath = [[GPTDSBundleLocator gptdsResourcesBundle] pathForResource:@"ec_test" ofType:@"der"];
                break;

            case GPTDSDirectoryServerAmex:
                certificatePath = [[GPTDSBundleLocator gptdsResourcesBundle] pathForResource:@"amex" ofType:@"der"];
                break;

            case GPTDSDirectoryServerDiscover:
                certificatePath = [[GPTDSBundleLocator gptdsResourcesBundle] pathForResource:@"discover" ofType:@"der"];
                break;

            case GPTDSDirectoryServerMastercard:
                certificatePath = [[GPTDSBundleLocator gptdsResourcesBundle] pathForResource:@"mastercard" ofType:@"der"];
                break;

            case GPTDSDirectoryServerVisa:
                certificatePath = [[GPTDSBundleLocator gptdsResourcesBundle] pathForResource:@"visa" ofType:@"der"];
                break;
                
            case GPTDSDirectoryServerCartesBancaires:
                certificatePath = [[GPTDSBundleLocator gptdsResourcesBundle] pathForResource:@"cartes_bancaires" ofType:@"der"];
                break;

            case GPTDSDirectoryServerCustom:
                break;

            case GPTDSDirectoryServerUnknown:
                break;
        }

        if (certificatePath != nil) {
            certificateData = [NSData dataWithContentsOfFile:certificatePath];
            // cache the file data to limit file IO
            sCertificateData[serverKey] = certificateData;
        }
    }

    // Note to Future: SecCertificateCreateWithData only works with DER formatted data. The other popular
    // format for certificate files is PEM. These can be converted before adding to the SDK by invoking
    // `openssl x509 -in certificate_PEM.crt -outform der -out certificate_DER.der`
    return certificateData != nil ? SecCertificateCreateWithData(NULL, (CFDataRef)certificateData): NULL;
};

CFStringRef _Nullable GPTDSSecCertificateCopyPublicKeyType(SecCertificateRef certificate) {
    CFStringRef ret = NULL;
    
    SecKeyRef key = SecCertificateCopyKey(certificate);
    
    if (key != NULL) {
        CFDictionaryRef attributes = SecKeyCopyAttributes(key);
        if (attributes == NULL) {
            CFRelease(key);
            return NULL;
        }
        
        if (attributes != NULL) {
            const void *keyType = CFDictionaryGetValue(attributes, kSecAttrKeyType);
            if (keyType != NULL && CFGetTypeID(keyType) == CFStringGetTypeID()) {
                ret = CFStringCreateCopy(kCFAllocatorDefault, (CFStringRef)keyType);
            }
            CFRelease(attributes);
        }
        CFRelease(key);
    }
    
    return ret;
}

SecCertificateRef _Nullable GPTDSSecCertificateFromString(NSString *certificateString) {
    static NSString * const kCertificateAnchorPrefix = @"-----BEGIN CERTIFICATE-----";
    static NSString * const kCertificateAnchorSuffix = @"-----END CERTIFICATE-----";

    // first remove newlines
    NSString *certificateStringNoAnchors = [[[certificateString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];

    // remove the begin/end certificate markers
    NSUInteger fromIndex = [certificateStringNoAnchors hasPrefix:kCertificateAnchorPrefix] ? kCertificateAnchorPrefix.length : 0;
    NSUInteger toIndex = [certificateStringNoAnchors hasSuffix:kCertificateAnchorSuffix] ? certificateStringNoAnchors.length - kCertificateAnchorSuffix.length : certificateStringNoAnchors.length;
    certificateStringNoAnchors = [[certificateStringNoAnchors substringWithRange:NSMakeRange(fromIndex, toIndex - fromIndex)] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    if (certificateStringNoAnchors.length == 0) {
        return NULL;
    }
    NSData *certificateData = [[NSData alloc] initWithBase64EncodedString:certificateStringNoAnchors options:0];
    if (certificateData == nil) {
        return NULL;
    }
    
    return GPTDSSecCertificateFromData(certificateData);
}

SecCertificateRef _Nullable GPTDSSecCertificateFromData(NSData *data) {
    SecCertificateRef certificate = SecCertificateCreateWithData(NULL, (__bridge CFDataRef)data);
    return certificate;
}

SecKeyRef _Nullable GPTDSPrivateSecKeyRefFromCoordinates(NSData *x, NSData *y, NSData *d) {
    static unsigned char prefixBytes[] = {0x04};
    NSMutableData *bytes = [[NSMutableData alloc] initWithBytes:(void *)prefixBytes length:1];
    [bytes appendData:x];
    [bytes appendData:y];
    [bytes appendData:d];
    NSDictionary *attributes = @{
        (__bridge NSString *)kSecAttrKeyType: (__bridge NSString *)kSecAttrKeyTypeECSECPrimeRandom,
        (__bridge NSString *)kSecAttrKeyClass: (__bridge NSString *)kSecAttrKeyClassPrivate,
        (__bridge NSString *)kSecAttrKeySizeInBits: @(256),
    };
    CFErrorRef error = NULL;
    SecKeyRef key = SecKeyCreateWithData((__bridge CFDataRef)bytes, (__bridge CFDictionaryRef)attributes, &error);
    return key;
}

SecKeyRef _Nullable GPTDSSecKeyRefFromCoordinates(NSData *coordinateX, NSData *coordinateY) {
    static unsigned char prefixBytes[] = {0x04};
    NSMutableData *bytes = [[NSMutableData alloc] initWithBytes:(void *)prefixBytes length:1];
    [bytes appendData:coordinateX];
    [bytes appendData:coordinateY];
    NSDictionary *attributes = @{
        (__bridge NSString *)kSecAttrKeyType: (__bridge NSString *)kSecAttrKeyTypeECSECPrimeRandom,
        (__bridge NSString *)kSecAttrKeyClass: (__bridge NSString *)kSecAttrKeyClassPublic,
        (__bridge NSString *)kSecAttrKeySizeInBits: @(256),
    };
    CFErrorRef error = NULL;
    SecKeyRef key = SecKeyCreateWithData((__bridge CFDataRef)bytes, (__bridge CFDictionaryRef)attributes, &error);
    return key;
}

// ref. https://crypto.stackexchange.com/questions/1795/how-can-i-convert-a-der-ecdsa-signature-to-asn-1/1797#1797
NSData * _Nullable GPTDSDEREncodedSignature(NSData * signature) {
    // make sure input signature is of correct R || S format
    NSUInteger signatureLength = signature.length;
    if (signatureLength == 0 || signatureLength % 2 != 0) {
        return nil;
    }
    
    static const uint8_t bytePrefix = 0x00;

    NSMutableData *rBytes = [[NSMutableData alloc] init];
    uint8_t firstRByte;
    [signature getBytes:&firstRByte length:1];

    if (firstRByte >= 0x80) {
        // "Signed big-endian encoding of minimal length", we can't have the first bit be 1 because these are postive values
        [rBytes appendBytes:&bytePrefix length:1];
    }
    [rBytes appendBytes:signature.bytes length:signatureLength / 2];
    
    NSMutableData *sBytes = [[NSMutableData alloc] init];
    uint8_t firstSByte;
    [signature getBytes:&firstSByte range:NSMakeRange(signatureLength / 2, 1)];
    
    if (firstSByte >= 0x80) {
        // "Signed big-endian encoding of minimal length", we can't have the first bit be 1 because these are postive values
        [sBytes appendBytes:&bytePrefix length:1];
    }
    [sBytes appendBytes:(signature.bytes + (signatureLength / 2)) length:signatureLength / 2];
    
    uint8_t rLength = (uint8_t)rBytes.length;
    uint8_t sLength = (uint8_t)sBytes.length;
    
    static const uint8_t derBytePrefix = 0x30;
    NSMutableData *derEncoded = [[NSMutableData alloc] initWithBytes:&derBytePrefix length:1];
    
    static const uint8_t derSeparatorByte = 0x02;
    // numBytes does not include the 0x30 byte
    uint8_t numBytes = rLength + sLength + 2 + 2; // + 2 for separators, + 2 for r and s size bytes
    [derEncoded appendBytes:&numBytes length:1];
    [derEncoded appendBytes:&derSeparatorByte length:1];
    
    [derEncoded appendBytes:&rLength length:1];
    [derEncoded appendBytes:rBytes.bytes length:rBytes.length];
    
    [derEncoded appendBytes:&derSeparatorByte length:1];

    [derEncoded appendBytes:&sLength length:1];
    [derEncoded appendBytes:sBytes.bytes length:sBytes.length];
    
    return [derEncoded copy];
}

BOOL GPTDSVerifyEllipticCurveP256Signature(NSData *coordinateX, NSData *coordinateY, NSData *payload, NSData *signature) {
    BOOL ret = NO;
    
    // make P-256 curve key from coordinates
    SecKeyRef key = GPTDSSecKeyRefFromCoordinates(coordinateX, coordinateY);
    
    if (key != NULL) {
        size_t hashBytesSize = CC_SHA256_DIGEST_LENGTH;
        unsigned char hashBytes[hashBytesSize];
        CC_SHA256(payload.bytes, (CC_LONG)payload.length, hashBytes);
        CFErrorRef error = NULL;
        NSData *derEncodedSignature = GPTDSDEREncodedSignature(signature);
        if (derEncodedSignature == nil) {
            CFRelease(key);
            return NO;
        }
        ret = (BOOL)SecKeyVerifySignature(key, kSecKeyAlgorithmECDSASignatureDigestX962SHA256, (__bridge CFDataRef)[NSData dataWithBytes:hashBytes length:hashBytesSize], (__bridge CFDataRef)derEncodedSignature, &error);
        CFRelease(key);
    }
    return ret;
}

BOOL GPTDSVerifyRSASignature(SecCertificateRef certificate, NSData *payload, NSData *signature) {
    BOOL ret = NO;
    
    SecKeyRef key = SecCertificateCopyKey(certificate);
    if (key != NULL && signature) {
        CFErrorRef error = NULL;
        size_t hashBytesSize = CC_SHA256_DIGEST_LENGTH;
        unsigned char hashBytes[hashBytesSize];
        CC_SHA256(payload.bytes, (CC_LONG)payload.length, hashBytes);
        
        ret = (BOOL)SecKeyVerifySignature(key, kSecKeyAlgorithmRSASignatureDigestPSSSHA256, (__bridge CFDataRef)[NSData dataWithBytes:hashBytes length:hashBytesSize], (__bridge CFDataRef)signature, &error);
        CFRelease(key);
    }
    return ret;
}

NSData * _Nullable GPTDSCryptoRandomData(size_t numBytes) {
    void *randomBytes[numBytes];
    memset(randomBytes, 0, numBytes);
    if (CCRandomGenerateBytes(randomBytes, numBytes) == kCCSuccess) {
        NSData *data = [NSData dataWithBytes:randomBytes length:numBytes];
        return data;
    }
    return NULL;
}

NSData * _Nullable _GPTDSCreateKDFFormattedData(NSData *data) {
    uint32_t bigEndianLength = CFSwapInt32HostToBig((uint32_t)data.length);
    NSMutableData *encodedLength = [NSMutableData dataWithBytes:&bigEndianLength length:4];
    [encodedLength appendData:data];
    return [encodedLength copy];
}

NSData * _Nullable GPTDSCreateConcatKDFWithSHA256(NSData *sharedSecret, NSUInteger keyLength, NSString *apv) {
    NSData *concatKDFData = nil;

    uint32_t bigEndianKeyLength = CFSwapInt32HostToBig((uint32_t)keyLength*8);

    // algorithmID and partyUInfo are intentionally empty strings based on the Core Spec
    // section 6.2.3.3 which states that they should be null. The KDF standard, NIST.800-56A,
    // requires that null values still have the length bytes set to 0.
    NSData *algorithmID = _GPTDSCreateKDFFormattedData([@"" dataUsingEncoding:NSASCIIStringEncoding]);
    NSData *partyUInfo = _GPTDSCreateKDFFormattedData([@"" dataUsingEncoding:NSUTF8StringEncoding]);
    NSData *partyVInfo = _GPTDSCreateKDFFormattedData([apv dataUsingEncoding:NSUTF8StringEncoding]);
    NSData *suppPubInfo = [NSData dataWithBytes:&bigEndianKeyLength length:4];

    if (algorithmID == nil ||
        partyUInfo == nil ||
        partyVInfo == nil ||
        suppPubInfo == nil
        ) {
        return nil;
    }

    NSMutableData *otherInfo = [algorithmID mutableCopy];
    [otherInfo appendData:partyUInfo];
    [otherInfo appendData:partyVInfo];
    [otherInfo appendData:suppPubInfo];

    const unsigned char roundOneBytes[4] = {0, 0, 0, 1};
    NSMutableData *roundOneHashInput = [[NSMutableData alloc] initWithBytes:roundOneBytes length:4];
    [roundOneHashInput appendData:sharedSecret];
    [roundOneHashInput appendData:otherInfo];

    NSMutableData *roundOneHashOutput = [NSMutableData dataWithLength:CC_SHA256_DIGEST_LENGTH];

    if (CC_SHA256(roundOneHashInput.bytes, (CC_LONG)roundOneHashInput.length,  roundOneHashOutput.mutableBytes) != nil) {
        concatKDFData = [NSData dataWithBytes:roundOneHashOutput.bytes length:MAX(keyLength, roundOneHashOutput.length)];
    }

    return concatKDFData;
}

NS_ASSUME_NONNULL_END
