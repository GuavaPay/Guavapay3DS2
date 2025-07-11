//
//  GPTDSEphemeralKeyPairTests.m
//  Guavapay3DS2Tests
//

#import <XCTest/XCTest.h>

#import "GPTDSDirectoryServerCertificate.h"
#import "GPTDSEllipticCurvePoint.h"
#import "GPTDSEphemeralKeyPair+Testing.h"
#import "GPTDSSecTypeUtilities.h"

@interface GPTDSEphemeralKeyPairTests : XCTestCase

@end

@implementation GPTDSEphemeralKeyPairTests

- (void)testCreateEpehemeralKeyPair {
    GPTDSEphemeralKeyPair *keyPair = [GPTDSEphemeralKeyPair ephemeralKeyPair];
    XCTAssertNotNil(keyPair.publicKeyJWK, @"Failed to create a valid public key JWK");
    GPTDSEphemeralKeyPair *keyPair2 = [GPTDSEphemeralKeyPair ephemeralKeyPair];
    XCTAssertNotEqual(keyPair.publicKeyJWK, keyPair2.publicKeyJWK, @"Failed sanity check that two different ephemeral key pairs don't have the same public key JWK.");
}

- (void)testDiffieHellmanSharedSecret {
    // values from EMVCo_3DS_-AppBased_CryptoExamples_082018.pdf
    NSDictionary *jwk = [NSJSONSerialization JSONObjectWithData:[@"{\"kty\":\"EC\",\"crv\":\"P-256\",\"kid\":\"UUIDkeyidentifierforDS-EC\", \"x\":\"2_v-MuNZccqwM7PXlakW9oHLP5XyrjMG1UVS8OxYrgA\", \"y\":\"rm1ktLmFIsP2R0YyJGXtsCbaTUesUK31Xc04tHJRolc\"}" dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];

    GPTDSEllipticCurvePoint *publicKey = [[GPTDSEllipticCurvePoint alloc] initWithJWK:jwk];
    GPTDSEphemeralKeyPair *keyPair = [GPTDSEphemeralKeyPair testKeyPair];
    NSData *secret = [keyPair createSharedSecretWithEllipticCurveKey:publicKey];
    const unsigned char expectedSecretBytes[] = {0x5C, 0x32, 0xBC, 0x13, 0xF8, 0xEC, 0xEB, 0x14, 0x8A, 0xBA, 0xF2, 0xA6, 0xB9, 0xDD, 0x1F, 0x68, 0x91, 0xBB, 0x2A, 0x80, 0xAB, 0x09, 0x34, 0x7C, 0x64, 0x06, 0x82, 0x31, 0xA5, 0x9E, 0x8C, 0xA2};
    NSData *expectedSecret = [[NSData alloc] initWithBytes:expectedSecretBytes length:32];
    XCTAssertEqualObjects(secret, expectedSecret, @"Generated incorrect shared secret value");
}

@end
