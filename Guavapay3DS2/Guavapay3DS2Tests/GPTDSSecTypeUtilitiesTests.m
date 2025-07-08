//
//  GPTDSSecTypeUtilitiesTests.m
//  Guavapay3DS2Tests
//

#import <XCTest/XCTest.h>

#import "NSString+JWEHelpers.h"
#import "GPTDSSecTypeUtilities.h"

@interface GPTDSSecTypeUtilitiesTests : XCTestCase

@end

@implementation GPTDSSecTypeUtilitiesTests

- (void)testDirectoryServerForID {
    XCTAssertEqual(GPTDSDirectoryServerForID(@"ul_test"), GPTDSDirectoryServerSTPTestRSA, @"ul_test should map to GPTDSDirectoryServerSTPTestRSA.");
    XCTAssertEqual(GPTDSDirectoryServerForID(@"ec_test"), GPTDSDirectoryServerSTPTestEC, @"ec_test should map to GPTDSDirectoryServerSTPTestEC.");
    XCTAssertEqual(GPTDSDirectoryServerForID(@"F055545342"), GPTDSDirectoryServerULTestRSA, @"F055545342 should map to GPTDSDirectoryServerULTestRSA.");
    XCTAssertEqual(GPTDSDirectoryServerForID(@"F155545342"), GPTDSDirectoryServerULTestEC, @"F155545342 should map to GPTDSDirectoryServerULTestEC.");

    XCTAssertEqual(GPTDSDirectoryServerForID(@"junk"), GPTDSDirectoryServerUnknown, @"junk server ID should map to GPTDSDirectoryServerUnknown.");
}

- (void)testCertificateForServer {
    SecCertificateRef certificate = NULL;

    certificate = GPTDSCertificateForServer(GPTDSDirectoryServerSTPTestRSA);
    XCTAssertTrue(certificate != NULL, @"Unable to load GPTDSDirectoryServerSTPTestRSA certificate.");
    if (certificate != NULL) {
        CFRelease(certificate);
    }
    certificate = GPTDSCertificateForServer(GPTDSDirectoryServerSTPTestEC);
    XCTAssertTrue(certificate != NULL, @"Unable to load GPTDSDirectoryServerSTPTestEC certificate.");
    if (certificate != NULL) {
        CFRelease(certificate);
    }
    certificate = GPTDSCertificateForServer(GPTDSDirectoryServerUnknown);
    if (certificate != NULL) {
        XCTFail(@"Should not have an unknown certificate.");
        CFRelease(certificate);
    }
}

- (void)testCopyPublicRSAKey {
    SecCertificateRef certificate = GPTDSCertificateForServer(GPTDSDirectoryServerSTPTestRSA);
    if (certificate != NULL) {
        SecKeyRef publicKey = SecCertificateCopyKey(certificate);
        if (publicKey != NULL) {
            CFRelease(publicKey);
        } else {
            XCTFail(@"Unable to load public key from certificate");
        }

        CFRelease(certificate);
    } else {
        XCTFail(@"Failed loading certificate for %@", NSStringFromSelector(_cmd));
    }
}

- (void)testCopyPublicECKey {
    SecCertificateRef certificate = GPTDSCertificateForServer(GPTDSDirectoryServerSTPTestEC);
    if (certificate != NULL) {
        SecKeyRef publicKey = SecCertificateCopyKey(certificate);
        if (publicKey != NULL) {
            CFRelease(publicKey);
        } else {
            XCTFail(@"Unable to load public key from certificate");
        }

        CFRelease(certificate);
    } else {
        XCTFail(@"Failed loading certificate for %@", NSStringFromSelector(_cmd));
    }
}

- (void)testCopyKeyTypeRSA {
    SecCertificateRef certificate = GPTDSCertificateForServer(GPTDSDirectoryServerSTPTestRSA);
    if (certificate != NULL) {
        CFStringRef keyType = GPTDSSecCertificateCopyPublicKeyType(certificate);
        if (keyType != NULL) {
            XCTAssertTrue(CFStringCompare(keyType, kSecAttrKeyTypeRSA, 0) == kCFCompareEqualTo, @"Key type is incorrect");
            CFRelease(keyType);
        } else {
            XCTFail(@"Failed to copy key type.");
        }
        CFRelease(certificate);
    } else {
        XCTFail(@"Failed loading certificate for %@", NSStringFromSelector(_cmd));
    }
}

- (void)testCopyKeyTypeEC {
    SecCertificateRef certificate = GPTDSCertificateForServer(GPTDSDirectoryServerSTPTestEC);
    if (certificate != NULL) {
        CFStringRef keyType = GPTDSSecCertificateCopyPublicKeyType(certificate);
        if (keyType != NULL) {
            XCTAssertTrue(CFStringCompare(keyType, kSecAttrKeyTypeECSECPrimeRandom, 0) == kCFCompareEqualTo, @"Key type is incorrect");
            CFRelease(keyType);
        } else {
            XCTFail(@"Failed to copy key type.");
        }
        CFRelease(certificate);
    } else {
        XCTFail(@"Failed loading certificate for %@", NSStringFromSelector(_cmd));
    }
}

- (void)testRandomData {
    // We're not actually going to implement randomness tests... just sanity
    NSData *data1 = GPTDSCryptoRandomData(32);
    NSData *data2 = GPTDSCryptoRandomData(32);

    XCTAssertNotNil(data1);
    XCTAssertTrue(data1.length == 32, @"Random data is not correct length.");
    XCTAssertNotEqualObjects(data1, data2, @"Sanity check: two random data's should not equate to equal (unless you get reeeeallly unlucky.");
    XCTAssertTrue(GPTDSCryptoRandomData(12).length == 12, @"Random data is not correct length.");
    XCTAssertNotNil(GPTDSCryptoRandomData(0), @"Empty random data should return empty data.");
    XCTAssertTrue(GPTDSCryptoRandomData(0).length == 0, @"Empty random data should have length 0");
}

- (void)testConcatKDFWithSHA256 {
    NSData *data = GPTDSCreateConcatKDFWithSHA256(GPTDSCryptoRandomData(32), 256, @"acs_identifier");
    XCTAssertNotNil(data, @"Failed to concat KDF and hash.");
    XCTAssertEqual(data.length, 256, @"Concat returned data of incorrect length");
}


- (void)testVerifyEllipticCurveP256 {
    NSData *payload = [@"eyJhbGciOiJFUzI1NiJ9.eyJpc3MiOiJqb2UiLA0KICJleHAiOjEzMDA4MTkzODAsDQogImh0dHA6Ly9leGFtcGxlLmNvbS9pc19yb290Ijp0cnVlfQ" dataUsingEncoding:NSUTF8StringEncoding];
    NSData *signature = [@"DtEhU3ljbEg8L38VWAfUAqOyKAM6-Xx-F4GawxaepmXFCgfTjDxw5djxLa8ISlSApmWQxfKTUJqPP3-Kg6NU1Q" _gptds_base64URLDecodedData];

    NSData *coordinateX = [@"f83OJ3D2xF1Bg8vub9tLe1gHMzV76e8Tus9uPHvRVEU" _gptds_base64URLDecodedData];
    NSData *coordinateY = [@"x_FEzRu9m36HLN_tue659LNpXW6pCyStikYjKIWI5a0" _gptds_base64URLDecodedData];

    XCTAssertTrue(GPTDSVerifyEllipticCurveP256Signature(coordinateX, coordinateY, payload, signature));
}
@end
