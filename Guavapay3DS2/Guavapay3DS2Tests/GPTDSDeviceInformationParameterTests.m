//
//  GPTDSDeviceInformationParameterTests.m
//  Guavapay3DS2Tests
//

#import <XCTest/XCTest.h>

#import "GPTDSDeviceInformationParameter+Private.h"

@interface GPTDSDeviceInformationParameterTests : XCTestCase

@end

@implementation GPTDSDeviceInformationParameterTests

- (void)testNoPermissions {
    GPTDSDeviceInformationParameter *noPermissionParam = [[GPTDSDeviceInformationParameter alloc] initWithIdentifier:@"NoPermissionID"
                                                                                                   permissionCheck:^BOOL{
                                                                                                       return NO;
                                                                                                   }
                                                                                                        valueCheck:^id _Nullable{
                                                                                                            XCTFail(@"Should not try to collect value if we don't have permission for it");
                                                                                                            return @"fail";
                                                                                                        }];
    [noPermissionParam collectIgnoringRestrictions:YES withHandler:^(BOOL collected, NSString * _Nonnull identifier, id _Nonnull value) {
        XCTAssertFalse(collected, @"Should not have collected a param we don't have permission for.");
        XCTAssertTrue([value isKindOfClass:[NSString class]], @"No permission value should be a string.");
        XCTAssertEqualObjects(value, @"RE03", @"Returned value should be 'RE03' for param with missing permissions.");
    }];
}

- (void)testNoValue {
    GPTDSDeviceInformationParameter *noValueParam = [[GPTDSDeviceInformationParameter alloc] initWithIdentifier:@"NoValueID"
                                                                                              permissionCheck:^BOOL{
                                                                                                  return YES;
                                                                                              }
                                                                                                   valueCheck:^id _Nullable{
                                                                                                       return nil;
                                                                                                   }];
    [noValueParam collectIgnoringRestrictions:YES withHandler:^(BOOL collected, NSString * _Nonnull identifier, id _Nonnull value) {
        XCTAssertFalse(collected, @"Should not have collected a param we don't have a value for.");
        XCTAssertTrue([value isKindOfClass:[NSString class]], @"No value value should be a string.");
        XCTAssertEqualObjects(value, @"RE02", @"Returned value should be 'RE02' for param with unavailable value.");
    }];
}

- (void)testCollect {
    __block BOOL permissionCheckCalled = NO;
    __block BOOL valueCheckCalled = NO;
    __block BOOL collectedHandlerCalled = NO;

    GPTDSDeviceInformationParameter *param = [[GPTDSDeviceInformationParameter alloc] initWithIdentifier:@"ParamID"
                                                                                       permissionCheck:^BOOL{
                                                                                           XCTAssertFalse(valueCheckCalled);
                                                                                           permissionCheckCalled = YES;
                                                                                           return YES;
                                                                                       }
                                                                                            valueCheck:^id _Nullable{
                                                                                                XCTAssertTrue(permissionCheckCalled);
                                                                                                valueCheckCalled = YES;
                                                                                                return @"param_val";
                                                                                            }];
    [param collectIgnoringRestrictions:YES withHandler:^(BOOL collected, NSString * _Nonnull identifier, id _Nonnull value) {
        XCTAssertTrue(collected, @"Should have marked value as collected.");
        XCTAssertEqualObjects(value, @"param_val", @"Inaccurate returned value.");
        XCTAssertTrue(permissionCheckCalled);
        XCTAssertTrue(valueCheckCalled);
        collectedHandlerCalled = YES;
    }];

    // This check tests that collect is synchronous for now
    XCTAssertTrue(collectedHandlerCalled);

    // reset so the permission before value check doesn't fail on the second call
    permissionCheckCalled = NO;
    valueCheckCalled = NO;

    // make sure the ignoreRestrictions param is respected
    [param collectIgnoringRestrictions:NO withHandler:^(BOOL collected, NSString * _Nonnull identifier, id _Nonnull value) {
        XCTAssertFalse(collected, @"Should not have marked value as collected.");
        XCTAssertFalse(permissionCheckCalled, @"Restrictions shouldn't even check the runtime permission.");
        XCTAssertFalse(valueCheckCalled, @"Should not have tried to get the value.");
        XCTAssertEqualObjects(value, @"RE01", @"Should return market restricted code as the value.");
    }];
}

- (void)testAllParameters {
    NSArray<GPTDSDeviceInformationParameter *> *allParams = [GPTDSDeviceInformationParameter allParameters];
    XCTAssertEqual(allParams.count, 30, @"iOS should collect 30 separate parameters.");
    NSMutableSet<NSString *> *allParamIdentifiers = [[NSMutableSet alloc] init];
    for (GPTDSDeviceInformationParameter *param in allParams) {
        [param collectIgnoringRestrictions:YES withHandler:^(BOOL collected, NSString * _Nonnull identifier, id _Nonnull value) {
            [allParamIdentifiers addObject:identifier];
        }];
    }
    XCTAssertEqual(allParamIdentifiers.count, allParams.count, @"Sanity check that there are not duplicate identifiers.");
    NSArray<NSString *> *expectedIdentifiers = @[
                                                 @"C001",
                                                 @"C002",
                                                 @"C003",
                                                 @"C004",
                                                 @"C005",
                                                 @"C006",
                                                 @"C008",
                                                 @"C009",
                                                 @"C010",
                                                 @"C011",
                                                 @"C012",
                                                 @"C013",
                                                 @"C014",
                                                 @"C015",
                                                 @"C017",
                                                 @"I001",
                                                 @"I002",
                                                 @"I003",
                                                 @"I004",
                                                 @"I005",
                                                 @"I006",
                                                 @"I007",
                                                 @"I008",
                                                 @"I009",
                                                 @"I010",
                                                 @"I011",
                                                 @"I012",
                                                 @"I013",
                                                 @"I014",
                                                 @"I015"
                                                 ];
    for (NSString *identifier in expectedIdentifiers) {
        XCTAssertTrue([allParamIdentifiers containsObject:identifier], @"Missing identifier %@", identifier);
    }
}

- (void)testOnlyApprovedIdentifiers {
    NSArray<GPTDSDeviceInformationParameter *> *allParams = [GPTDSDeviceInformationParameter allParameters];
    NSMutableSet<NSString *> *collectedParameterIdentifiers = [[NSMutableSet alloc] init];
    for (GPTDSDeviceInformationParameter *param in allParams) {
        [param collectIgnoringRestrictions:NO withHandler:^(BOOL collected, NSString * _Nonnull identifier, id _Nonnull value) {

            if (collected) {
                [collectedParameterIdentifiers addObject:identifier];
            }
        }];
    }
    NSArray<NSString *> *expectedIdentifiers = @[
                                                 @"C001",
                                                 @"C002",
                                                 @"C003",
                                                 @"C004",
                                                 @"C005",
                                                 @"C006",
                                                 @"C008",
                                                 @"C014",
                                                 ];
    XCTAssertEqual(collectedParameterIdentifiers.count, expectedIdentifiers.count, @"Should only have collected the expected amount.");

    for (NSString *identifier in expectedIdentifiers) {
        XCTAssertTrue([collectedParameterIdentifiers containsObject:identifier], @"Missing identifier %@", identifier);
    }
}

- (void)testIdentifiersAccurate {
    NSDictionary<NSString *, GPTDSDeviceInformationParameter *> *expectedIdentifiers = @{
                                                                                        @"C001": [GPTDSDeviceInformationParameter platform],
                                                                                        @"C002": [GPTDSDeviceInformationParameter deviceModel],
                                                                                        @"C003": [GPTDSDeviceInformationParameter OSName],
                                                                                        @"C004": [GPTDSDeviceInformationParameter OSVersion],
                                                                                        @"C005": [GPTDSDeviceInformationParameter locale],
                                                                                        @"C006": [GPTDSDeviceInformationParameter timeZone],
                                                                                        @"C008": [GPTDSDeviceInformationParameter screenResolution],
                                                                                        @"C009": [GPTDSDeviceInformationParameter deviceName],
                                                                                        @"C010": [GPTDSDeviceInformationParameter IPAddress],
                                                                                        @"C011": [GPTDSDeviceInformationParameter latitude],
                                                                                        @"C012": [GPTDSDeviceInformationParameter longitude],
                                                                                        @"I001": [GPTDSDeviceInformationParameter identiferForVendor],
                                                                                        @"I002": [GPTDSDeviceInformationParameter userInterfaceIdiom],
                                                                                        @"I003": [GPTDSDeviceInformationParameter familyNames],
                                                                                        @"I004": [GPTDSDeviceInformationParameter fontNamesForFamilyName],
                                                                                        @"I005": [GPTDSDeviceInformationParameter systemFont],
                                                                                        @"I006": [GPTDSDeviceInformationParameter labelFontSize],
                                                                                        @"I007": [GPTDSDeviceInformationParameter buttonFontSize],
                                                                                        @"I008": [GPTDSDeviceInformationParameter smallSystemFontSize],
                                                                                        @"I009": [GPTDSDeviceInformationParameter systemFontSize],
                                                                                        @"I010": [GPTDSDeviceInformationParameter systemLocale],
                                                                                        @"I011": [GPTDSDeviceInformationParameter availableLocaleIdentifiers],
                                                                                        @"I012": [GPTDSDeviceInformationParameter preferredLanguages],
                                                                                        @"I013": [GPTDSDeviceInformationParameter defaultTimeZone],
                                                                                        };

    [expectedIdentifiers enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, GPTDSDeviceInformationParameter * _Nonnull obj, BOOL * _Nonnull stop) {
        [obj collectIgnoringRestrictions:YES withHandler:^(BOOL collected, NSString * _Nonnull identifier, id _Nonnull value) {
            XCTAssertEqualObjects(key, identifier);
        }];
    }];
}

#pragma mark - App ID

- (void)testSDKAppIdentifier {
    // xctest in Xcode 13+ uses the Xcode version for the current app id string, previous versions are empty
    NSString *appIdentifierKeyPrefix = @"GPTDSGuavapay3DS2AppIdentifierKey";
    NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] ?: @"";
    NSString *appIdentifierUserDefaultsKey = [appIdentifierKeyPrefix stringByAppendingString:appVersion];

    [[NSUserDefaults standardUserDefaults] removeObjectForKey:appIdentifierUserDefaultsKey];
    NSString *appId = [GPTDSDeviceInformationParameter sdkAppIdentifier];
    XCTAssertNotNil(appId);
    XCTAssertEqualObjects(appId, [[NSUserDefaults standardUserDefaults] stringForKey:appIdentifierUserDefaultsKey]);
}

@end
