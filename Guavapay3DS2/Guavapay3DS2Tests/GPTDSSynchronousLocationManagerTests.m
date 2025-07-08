//
//  GPTDSSynchronousLocationManagerTests.m
//  Guavapay3DS2Tests
//

#import <XCTest/XCTest.h>

#import "GPTDSSynchronousLocationManager.h"

@interface GPTDSSynchronousLocationManagerTests : XCTestCase

@end

@implementation GPTDSSynchronousLocationManagerTests

- (void)testLocationFetchIsSynchronous {
    id originalLocation = [[NSObject alloc] init];
    id location = originalLocation;
    
    location = [[GPTDSSynchronousLocationManager sharedManager] deviceLocation];
    // tests that location gets synchronously updated (even if it's to nil due to permissions while running tests)
    XCTAssertNotEqual(originalLocation, location);
}

@end
