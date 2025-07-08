//
//  NSString+EmptyCheckingTests.m
//  Guavapay3DS2Tests
//

#import <XCTest/XCTest.h>

#import "NSString+EmptyChecking.h"

@interface NSString_EmptyCheckingTests : XCTestCase

@end

@implementation NSString_EmptyCheckingTests

- (void)testStringIsEmpty {
    XCTAssertTrue([NSString _gptds_isStringEmpty:@""]);
    XCTAssertTrue([NSString _gptds_isStringEmpty:@" "]);
    XCTAssertTrue([NSString _gptds_isStringEmpty:@"\n"]);
    XCTAssertTrue([NSString _gptds_isStringEmpty:@"\t"]);
}

- (void)testStringIsNotEmpty {
    XCTAssertFalse([NSString _gptds_isStringEmpty:@"Hello"]);
    XCTAssertFalse([NSString _gptds_isStringEmpty:@","]);
    XCTAssertFalse([NSString _gptds_isStringEmpty:@"\\n"]);
}

@end
