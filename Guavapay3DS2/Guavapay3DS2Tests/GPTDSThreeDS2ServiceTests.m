//
//  GPTDSThreeDS2ServiceTests.m
//  Guavapay3DS2Tests
//

#import <XCTest/XCTest.h>

#import "GPTDSAlreadyInitializedException.h"
#import "GPTDSConfigParameters.h"
#import "GPTDSInvalidInputException.h"
#import "GPTDSThreeDS2Service.h"
#import "GPTDSNotInitializedException.h"

@interface GPTDSThreeDS2ServiceTests : XCTestCase

@end

@implementation GPTDSThreeDS2ServiceTests

- (void)testInitialize {
    GPTDSThreeDS2Service *service = [[GPTDSThreeDS2Service alloc] init];
    XCTAssertNoThrow([service initializeWithConfig:[[GPTDSConfigParameters alloc] init]
                                            locale:nil
                                        uiSettings:nil],
                     @"Should not throw with valid input and first call to initialize");

    XCTAssertThrowsSpecific([service initializeWithConfig:[[GPTDSConfigParameters alloc] init]
                                                   locale:nil
                                               uiSettings:nil],
                            GPTDSAlreadyInitializedException,
                            @"Should throw GPTDSAlreadyInitializedException if called again with valid input.");

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnonnull"
    XCTAssertThrowsSpecific([service initializeWithConfig:nil
                                                   locale:nil
                                               uiSettings:nil],
                            GPTDSInvalidInputException,
                            @"Should throw GPTDSInvalidInputException for nil config even if already initialized.");

    service = [[GPTDSThreeDS2Service alloc] init];
    XCTAssertThrowsSpecific([service initializeWithConfig:nil
                                                   locale:nil
                                               uiSettings:nil],
                            GPTDSInvalidInputException,
                            @"Should throw GPTDSInvalidInputException for nil config on first initialize.");
#pragma clang diagnostic pop

    XCTAssertNoThrow([service initializeWithConfig:[[GPTDSConfigParameters alloc] init]
                                            locale:nil
                                        uiSettings:nil],
                     @"Should not throw with valid input and first call to initialize even after invalid input");
    
    service = [[GPTDSThreeDS2Service alloc] init];
    XCTAssertThrowsSpecific(service.warnings, GPTDSNotInitializedException);

}

@end
