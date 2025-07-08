//
//  GPTDSDeviceInformationManagerTests.m
//  Guavapay3DS2Tests
//

#import <XCTest/XCTest.h>

#import "GPTDSDeviceInformation.h"
#import "GPTDSDeviceInformationManager.h"
#import "GPTDSWarning.h"

@interface GPTDSDeviceInformationManagerTests : XCTestCase

@end

@implementation GPTDSDeviceInformationManagerTests

- (void)testDeviceInformation {
    GPTDSDeviceInformation *deviceInformation = [GPTDSDeviceInformationManager deviceInformationWithWarnings:@[] ignoringRestrictions:NO];
    XCTAssertEqualObjects(deviceInformation.dictionaryValue[@"DV"], @"1.7", @"Device data version check.");
    XCTAssertNotNil(deviceInformation.dictionaryValue[@"DD"], @"Device data should be non-nil");
    XCTAssertNotNil(deviceInformation.dictionaryValue[@"DPNA"], @"Param not available should be non-nil in simulator");
    XCTAssertNil(deviceInformation.dictionaryValue[@"SW"]);

    deviceInformation = [GPTDSDeviceInformationManager deviceInformationWithWarnings:@[[[GPTDSWarning alloc] initWithIdentifier:@"WARNING_1" message:@"" severity:GPTDSWarningSeverityMedium], [[GPTDSWarning alloc] initWithIdentifier:@"WARNING_2" message:@"" severity:GPTDSWarningSeverityMedium], ] ignoringRestrictions:NO];
    NSArray<NSString *> *warningIDs = @[@"WARNING_1", @"WARNING_2"];
    XCTAssertEqualObjects(deviceInformation.dictionaryValue[@"SW"], warningIDs, @"Failed to set warning identifiers correctly");
}

@end
