//
//  GPTDSACSNetworkingManagerTest.m
//  Guavapay3DS2Tests
//

#import <XCTest/XCTest.h>

#import "GPTDSGuavapay3DS2Error.h"
#import "GPTDSACSNetworkingManager.h"
#import "GPTDSTestJSONUtils.h"
#import "GPTDSErrorMessage.h"
#import "GPTDSChallengeResponseObject.h"

@interface GPTDSACSNetworkingManager (Private)
- (nullable id<GPTDSChallengeResponse>)decodeJSON:(NSDictionary *)dict error:(NSError * _Nullable *)outError;
@end

@interface GPTDSACSNetworkingManagerTest : XCTestCase

@end

@implementation GPTDSACSNetworkingManagerTest

- (void)testDecodeJSON {
    GPTDSACSNetworkingManager *manager = [[GPTDSACSNetworkingManager alloc] init];
    NSError *error;
    id decoded;
    
    // Unknown message type
    NSDictionary *unknownMessageDict = @{@"messageType": @"foo"};
    decoded = [manager decodeJSON:unknownMessageDict error:&error];
    XCTAssertEqual(error.code, GPTDSErrorCodeUnknownMessageType);
    XCTAssertNil(decoded);
    error = nil;
    
    // Error Message type
    NSDictionary *errorMessageDict = [GPTDSTestJSONUtils jsonNamed:@"ErrorMessage"];
    decoded = [manager decodeJSON:errorMessageDict error:&error];
    XCTAssertEqual(error.code, GPTDSErrorCodeReceivedErrorMessage);
    XCTAssertTrue([error.userInfo[GPTDSGuavapay3DS2ErrorMessageErrorKey] isKindOfClass:[GPTDSErrorMessage class]]);
    XCTAssertNil(decoded);
    error = nil;
    
    // ChallengeResponse message type
    NSDictionary *challengeResponseDict = [GPTDSTestJSONUtils jsonNamed:@"CRes"];
    decoded = [manager decodeJSON:challengeResponseDict error:&error];
    XCTAssertNil(error);
    XCTAssertTrue([decoded isKindOfClass:[GPTDSChallengeResponseObject class]]);
}

@end
