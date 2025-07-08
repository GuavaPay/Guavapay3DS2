//
//  GPTDSAuthenticationRequestParametersTest.m
//  Guavapay3DS2Tests
//

#import <XCTest/XCTest.h>

#import "GPTDSAuthenticationRequestParameters.h"
#import "GPTDSJSONEncoder.h"

@interface GPTDSAuthenticationRequestParametersTest : XCTestCase

@end

@implementation GPTDSAuthenticationRequestParametersTest

#pragma mark - GPTDSJSONEncodable

- (void)testPropertyNamesToJSONKeysMapping {
    GPTDSAuthenticationRequestParameters *params = [GPTDSAuthenticationRequestParameters new];
    
    NSDictionary *mapping = [GPTDSAuthenticationRequestParameters propertyNamesToJSONKeysMapping];
    
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
