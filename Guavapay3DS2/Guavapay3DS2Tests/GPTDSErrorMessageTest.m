//
//  GPTDSErrorMessageTest.m
//  Guavapay3DS2Tests
//

#import <XCTest/XCTest.h>

#import "GPTDSErrorMessage.h"
#import "GPTDSJSONEncoder.h"
#import "GPTDSTestJSONUtils.h"

@interface GPTDSErrorMessageTest : XCTestCase

@end

@implementation GPTDSErrorMessageTest

#pragma mark - GPTDSJSONDecodable

- (void)testSuccessfulDecode {
    NSDictionary *json = [GPTDSTestJSONUtils jsonNamed:@"ErrorMessage"];
    NSError *error;
    GPTDSErrorMessage *errorMessage = [GPTDSErrorMessage decodedObjectFromJSON:json error:&error];
    
    XCTAssertNil(error);
    XCTAssertNotNil(errorMessage);
    XCTAssertEqualObjects(errorMessage.errorCode, @"203");
    XCTAssertEqualObjects(errorMessage.errorComponent, @"A");
    XCTAssertEqualObjects(errorMessage.errorDescription, @"Data element not in the required format. Not numeric or wrong length.");
    XCTAssertEqualObjects(errorMessage.errorDetails, @"billAddrCountry,billAddrPostCode,dsURL");
    XCTAssertEqualObjects(errorMessage.errorMessageType, @"AReq");
    XCTAssertEqualObjects(errorMessage.messageVersion, @"2.2.0");

}

#pragma mark - GPTDSJSONEncodable

- (void)testPropertyNamesToJSONKeysMapping {
    GPTDSErrorMessage *params = [GPTDSErrorMessage new];
    
    NSDictionary *mapping = [GPTDSErrorMessage propertyNamesToJSONKeysMapping];
    
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


@end
