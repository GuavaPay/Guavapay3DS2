//
//  GPTDSWarningTests.m
//  Guavapay3DS2Tests
//

#import <XCTest/XCTest.h>

#import "GPTDSWarning.h"

@interface GPTDSWarningTests : XCTestCase

@end

@implementation GPTDSWarningTests

- (void)testWarning {
    GPTDSWarning *warning = [[GPTDSWarning alloc] initWithIdentifier:@"test_id" message:@"test_message" severity:GPTDSWarningSeverityMedium];
    XCTAssertEqual(warning.identifier, @"test_id", @"Identifier was not set correctly.");
    XCTAssertEqual(warning.message, @"test_message", @"Message was not set correctly.");
    XCTAssertEqual(warning.severity, GPTDSWarningSeverityMedium, @"Severity was not set correctly.");
}

@end
