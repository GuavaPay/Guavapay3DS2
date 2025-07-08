//
//  GPTDSChallengeParametersTests.m
//  Guavapay3DS2Tests
//

#import <XCTest/XCTest.h>

#import "GPTDSAuthenticationResponseObject.h"
#import "GPTDSChallengeParameters.h"
#import "NSData+JWEHelpers.h"

@interface TestAuthResponse: GPTDSAuthenticationResponseObject

@end

@interface GPTDSChallengeParametersTests : XCTestCase

@end

@implementation GPTDSChallengeParametersTests

- (void)testInitWithAuthResponse {
    GPTDSChallengeParameters *params = [[GPTDSChallengeParameters alloc] initWithAuthenticationResponse:[[TestAuthResponse alloc] init]];

    XCTAssertEqual(params.threeDSServerTransactionID, @"test_threeDSServerTransactionID", @"Failed to set test_threeDSServerTransactionID");
    XCTAssertEqual(params.acsTransactionID, @"test_acsTransactionID", @"Failed to set test_acsTransactionID");
    XCTAssertEqual(params.acsReferenceNumber, @"test_acsReferenceNumber", @"Failed to set test_acsReferenceNumber");
    XCTAssertEqual(params.acsSignedContent, @"test_acsSignedContent", @"Failed to set test_acsSignedContent");
    XCTAssertNil(params.threeDSRequestorAppURL, @"Should not have set threeDSRequestorAppURL");
}

- (void)testInitWithPackedSDKResponse {
    NSDictionary *payload = @{
        @"threeDsServerTransactionId": @"test_threeDSServerTransactionID",
        @"acsTransactionId": @"test_acsTransactionID",
        @"acsRefNumber": @"test_acsReferenceNumber",
        @"acsSignedContent": @"test_acsSignedContent"
    };
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:payload options:0 error:nil];
    NSString *base64URL = [jsonData _gptds_base64URLEncodedString];
    NSString *requestorAppURL = @"https://example.com";
    GPTDSChallengeParameters *params = [[GPTDSChallengeParameters alloc] initWithPackedSDKString:base64URL
                                                                                 requestorAppURL:requestorAppURL];

    XCTAssertEqualObjects(params.threeDSServerTransactionID, payload[@"threeDsServerTransactionId"], @"Failed to set threeDSServerTransactionID");
    XCTAssertEqualObjects(params.acsTransactionID, payload[@"acsTransactionId"], @"Failed to set acsTransactionID");
    XCTAssertEqualObjects(params.acsReferenceNumber, payload[@"acsRefNumber"], @"Failed to set acsReferenceNumber");
    XCTAssertEqualObjects(params.acsSignedContent, payload[@"acsSignedContent"], @"Failed to set acsSignedContent");
    XCTAssertEqualObjects(params.threeDSRequestorAppURL, requestorAppURL, @"Failed to set threeDSRequestorAppURL");
}

@end

#pragma mark - TestAuthResponse

@implementation TestAuthResponse

- (NSString *)threeDSServerTransactionID {
    return @"test_threeDSServerTransactionID";
}

- (NSString *)acsTransactionID {
    return @"test_acsTransactionID";
}

- (NSString *)acsReferenceNumber {
    return @"test_acsReferenceNumber";
}

- (NSString *)acsSignedContent {
    return @"test_acsSignedContent";
}

@end
