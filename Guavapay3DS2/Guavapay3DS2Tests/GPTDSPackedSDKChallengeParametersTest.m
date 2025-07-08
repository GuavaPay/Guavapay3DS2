//
//  GPTDSPackedSDKChallengeParametersTest.m
//  Guavapay3DS2
//

#import <XCTest/XCTest.h>
#import "GPTDSPackedSDKChallengeParameters.h"


@interface GPTDSPackedSDKChallengeParametersTest : XCTestCase
@end

@implementation GPTDSPackedSDKChallengeParametersTest

- (void)testInitWithDictionary {
    NSDictionary *payload = @{
        @"threeDsServerTransactionId": @"test_threeDSServerTransactionID",
        @"acsTransactionId": @"test_acsTransactionID",
        @"acsRefNumber": @"test_acsReferenceNumber",
        @"acsSignedContent": @"test_acsSignedContent"
    };

    GPTDSPackedSDKChallengeParameters *params = [[GPTDSPackedSDKChallengeParameters alloc] initWithDictionary:payload];

    XCTAssertEqualObjects(params.threeDsServerTransactionId, payload[@"threeDsServerTransactionId"], @"Failed to set threeDsServerTransactionId");
    XCTAssertEqualObjects(params.acsTransactionId, payload[@"acsTransactionId"], @"Failed to set acsTransactionId");
    XCTAssertEqualObjects(params.acsRefNumber, payload[@"acsRefNumber"], @"Failed to set acsRefNumber");
    XCTAssertEqualObjects(params.acsSignedContent, payload[@"acsSignedContent"], @"Failed to set acsSignedContent");
}

@end
