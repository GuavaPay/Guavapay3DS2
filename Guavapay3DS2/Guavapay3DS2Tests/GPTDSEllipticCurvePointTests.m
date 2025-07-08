//
//  GPTDSEllipticCurvePointTests.m
//  Guavapay3DS2Tests
//

#import <XCTest/XCTest.h>

#import "NSString+JWEHelpers.h"
#import "GPTDSEllipticCurvePoint.h"

@interface GPTDSEllipticCurvePointTests : XCTestCase

@end

@implementation GPTDSEllipticCurvePointTests

- (void)testInitWithJWK {

    GPTDSEllipticCurvePoint *ecPoint = [[GPTDSEllipticCurvePoint alloc] initWithJWK:@{ // ref. EMVCo_3DS_-AppBased_CryptoExamples_082018.pdf
                                                                                    @"kty":@"EC",
                                                                                    @"crv":@"P-256",
                                                                                    @"x":@"mPUKT_bAWGHIhg0TpjjqVsP1rXWQu_vwVOHHtNkdYoA",
                                                                                    @"y":@"8BQAsImGeAS46fyWw5MhYfGTT0IjBpFw2SS34Dv4Irs",
                                                                                    }];

    XCTAssertNotNil(ecPoint, @"Failed to create point with valid jwk");
    XCTAssertEqualObjects(ecPoint.x, [@"mPUKT_bAWGHIhg0TpjjqVsP1rXWQu_vwVOHHtNkdYoA" _gptds_base64URLDecodedData], @"Parsed incorrect x-coordinate");
    XCTAssertEqualObjects(ecPoint.y, [@"8BQAsImGeAS46fyWw5MhYfGTT0IjBpFw2SS34Dv4Irs" _gptds_base64URLDecodedData], @"Parsed incorrect y-coordinate");

    ecPoint = [[GPTDSEllipticCurvePoint alloc] initWithJWK:@{
                                                            @"kty":@"EC",
                                                            @"crv":@"P-128",
                                                            @"x":@"mPUKT_bAWGHIhg0TpjjqVsP1rXWQu_vwVOHHtNkdYoA",
                                                            @"y":@"8BQAsImGeAS46fyWw5MhYfGTT0IjBpFw2SS34Dv4Irs",
                                                            }];
    XCTAssertNil(ecPoint, @"Shoud return nil for non P-256 curve.");
}

@end
