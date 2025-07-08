//
//  GPTDSAuthenticationResponseTests.m
//  Guavapay3DS2Tests
//

#import <XCTest/XCTest.h>

#import "GPTDSAuthenticationResponseObject.h"
#import "GPTDSTestJSONUtils.h"

@interface GPTDSAuthenticationResponseTests : XCTestCase

@end

@implementation GPTDSAuthenticationResponseTests

- (void)testInitWithJSON {
    NSError *error = nil;
    GPTDSAuthenticationResponseObject *ares = [GPTDSAuthenticationResponseObject decodedObjectFromJSON:[GPTDSTestJSONUtils jsonNamed:@"ARes"] error:&error];

    XCTAssertNil(error);
    XCTAssertNotNil(ares, @"Failed to create an ares parsed from JSON");

    id<GPTDSAuthenticationResponse> authResponse = GPTDSAuthenticationResponseFromJSON([GPTDSTestJSONUtils jsonNamed:@"ARes"]);
    XCTAssertNotNil(authResponse, @"Failed to create an ares parsed from JSON");
    XCTAssert(authResponse.isChallengeRequired, @"ares did not indicate that a challenge was required");
}

@end
