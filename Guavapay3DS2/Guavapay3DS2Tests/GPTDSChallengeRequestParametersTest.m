//
//  GPTDSChallengeRequestParametersTest.m
//  Guavapay3DS2Tests
//

#import <XCTest/XCTest.h>

#import "GPTDSChallengeRequestParameters.h"
#import "GPTDSJSONEncoder.h"

@interface GPTDSChallengeRequestParametersTest : XCTestCase

@end

@implementation GPTDSChallengeRequestParametersTest

#pragma mark - GPTDSJSONEncodable

- (void)testPropertyNamesToJSONKeysMapping {
    GPTDSChallengeRequestParameters *params = [[GPTDSChallengeRequestParameters alloc] initWithThreeDSServerTransactionIdentifier:@"server id"
                                                                                                       acsTransactionIdentifier:@"acs id"
                                                                                                                 messageVersion:@"message version"
                                                                                                       sdkTransactionIdentifier:@"sdk id"
                                                                                                                requestorAppUrl:@"requestor app url"
                                                                                                                 sdkCounterStoA:0];
    
    NSDictionary *mapping = [GPTDSChallengeRequestParameters propertyNamesToJSONKeysMapping];
    
    for (NSString *propertyName in [mapping allKeys]) {
        XCTAssertFalse([propertyName containsString:@":"]);
        XCTAssert([params respondsToSelector:NSSelectorFromString(propertyName)]);
    }
    
    for (NSString *formFieldName in [mapping allValues]) {
        XCTAssert([formFieldName isKindOfClass:[NSString class]]);
        XCTAssert([formFieldName length] > 0);
    }
    
    XCTAssertEqual([[mapping allValues] count], [[NSSet setWithArray:[mapping allValues]] count]);
    XCTAssertTrue([NSJSONSerialization isValidJSONObject:[GPTDSJSONEncoder dictionaryForObject:params]]);
}

- (void)testNextChallengeRequestParametersIncrementsCounter {
    GPTDSChallengeRequestParameters *params = [[GPTDSChallengeRequestParameters alloc] initWithThreeDSServerTransactionIdentifier:@"server id"
                                                                                                       acsTransactionIdentifier:@"acs id"
                                                                                                                 messageVersion:@"message version"
                                                                                                       sdkTransactionIdentifier:@"sdk id"
                                                                                                                requestorAppUrl:@"requestor app url"
                                                                                                                 sdkCounterStoA:0];
    for (NSInteger i = 0; i < 1000; i++) {
        XCTAssertEqual(params.sdkCounterStoA.length, 3);
        XCTAssertEqual(params.sdkCounterStoA.integerValue, i);
        params = [params nextChallengeRequestParametersByIncrementCounter];
    }
}

- (void)testEmptyChallengeDataEntryField {
    GPTDSChallengeRequestParameters *params = [[GPTDSChallengeRequestParameters alloc] initWithThreeDSServerTransactionIdentifier:@"server id"
                                                                                                       acsTransactionIdentifier:@"acs id"
                                                                                                                 messageVersion:@"message version"
                                                                                                       sdkTransactionIdentifier:@"sdk id"
                                                                                                                requestorAppUrl:@"requestor app url"
                                                                                                                 sdkCounterStoA:0];
    params.challengeDataEntry = @"";
    XCTAssertNil(params.challengeDataEntry);
}

@end
