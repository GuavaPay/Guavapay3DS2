//
//  NSDictionary+DecodingHelpersTest.m
//  Guavapay3DS2Tests
//

#import <XCTest/XCTest.h>

#import "NSDictionary+DecodingHelpers.h"
#import "GPTDSGuavapay3DS2Error.h"
#import "NSError+Guavapay3DS2.h"

@interface JSONDecodableTestObject : NSObject<GPTDSJSONDecodable>
@property (nonatomic, copy) NSString *value;
@end

@implementation JSONDecodableTestObject

+ (instancetype)decodedObjectFromJSON:(NSDictionary *)json error:(NSError * _Nullable __autoreleasing *)outError {
    NSString *value = [json _gptds_stringForKey:@"key" required:YES error:outError];
    if (outError && *outError) {
        return nil;
    }
    JSONDecodableTestObject *obj = [[self alloc] init];
    obj.value = value;
    return obj;
}

@end

@interface NSDictionary_DecodingHelpersTest : XCTestCase

@end

@implementation NSDictionary_DecodingHelpersTest

- (void)testMissingRequiredKey {
    // Every getter should fail the same way if the key is not present
    NSDictionary *json = @{};
    NSError *expectedError = [NSError _gptds_missingJSONFieldError:@"key"];
    NSError *error;
    id value;
    
    value = [json _gptds_stringForKey:@"key" required:YES error:&error];
    XCTAssertNotNil(error);
    if (error) {
        XCTAssertEqual(error.code, expectedError.code);
        XCTAssertEqualObjects(error.userInfo, expectedError.userInfo);
    } else {
        XCTFail(@"Error should have a value");
    }
    XCTAssertNil(value);

    value = [json _gptds_stringForKey:@"key" validator:^BOOL (NSString *value) {
        return NO;
    } required:YES error:&error];
    XCTAssertNotNil(error);
    if (error) {
        XCTAssertEqual(error.code, expectedError.code);
        XCTAssertEqualObjects(error.userInfo, expectedError.userInfo);
    } else {
        XCTFail(@"Error should have a value");
    }
    XCTAssertNil(value);

    value = [json _gptds_boolForKey:@"key" required:YES error:&error];
    XCTAssertNotNil(error);
    if (error) {
        XCTAssertEqual(error.code, expectedError.code);
        XCTAssertEqualObjects(error.userInfo, expectedError.userInfo);
    } else {
        XCTFail(@"Error should have a value");
    }
    XCTAssertNil(value);

    value = [json _gptds_arrayForKey:@"key" arrayElementType:[JSONDecodableTestObject class] required:YES error:&error];
    XCTAssertNotNil(error);
    if (error) {
        XCTAssertEqual(error.code, expectedError.code);
        XCTAssertEqualObjects(error.userInfo, expectedError.userInfo);
    } else {
        XCTFail(@"Error should have a value");
    }
    XCTAssertNil(value);

    value = [json _gptds_urlForKey:@"key" required:YES error:&error];
    XCTAssertNotNil(error);
    if (error) {
        XCTAssertEqual(error.code, expectedError.code);
        XCTAssertEqualObjects(error.userInfo, expectedError.userInfo);
    } else {
        XCTFail(@"Error should have a value");
    }
    XCTAssertNil(value);

    value = [json _gptds_dictionaryForKey:@"key" required:YES error:&error];
    XCTAssertNotNil(error);
    if (error) {
        XCTAssertEqual(error.code, expectedError.code);
        XCTAssertEqualObjects(error.userInfo, expectedError.userInfo);
    } else {
        XCTFail(@"Error should have a value");
    }
    XCTAssertNil(value);
}

- (void)testInvalidType {
    // Every getter should fail the same way if the value is not the expected type
    NSDictionary *json = @{@"key": [NSObject new]};
    NSError *expectedError = [NSError _gptds_invalidJSONFieldError:@"key"];
    NSError *error;
    id value;

    value = [json _gptds_stringForKey:@"key" required:YES error:&error];
    XCTAssertNotNil(error);
    if (error) {
        XCTAssertEqual(error.code, expectedError.code);
        XCTAssertEqualObjects(error.userInfo, expectedError.userInfo);
    } else {
        XCTFail(@"Error should have a value");
    }
    XCTAssertNil(value);

    value = [json _gptds_stringForKey:@"key" validator:^BOOL (NSString *value) {
        return NO;
    } required:YES error:&error];
    XCTAssertNotNil(error);
    if (error) {
        XCTAssertEqual(error.code, expectedError.code);
        XCTAssertEqualObjects(error.userInfo, expectedError.userInfo);
    } else {
        XCTFail(@"Error should have a value");
    }
    XCTAssertNil(value);

    value = [json _gptds_boolForKey:@"key" required:YES error:&error];
    XCTAssertNotNil(error);
    if (error) {
        XCTAssertEqual(error.code, expectedError.code);
        XCTAssertEqualObjects(error.userInfo, expectedError.userInfo);
    } else {
        XCTFail(@"Error should have a value");
    }
    XCTAssertNil(value);

    value = [json _gptds_arrayForKey:@"key" arrayElementType:[JSONDecodableTestObject class] required:YES error:&error];
    XCTAssertNotNil(error);
    if (error) {
        XCTAssertEqual(error.code, expectedError.code);
        XCTAssertEqualObjects(error.userInfo, expectedError.userInfo);
    } else {
        XCTFail(@"Error should have a value");
    }
    XCTAssertNil(value);

    value = [json _gptds_urlForKey:@"key" required:YES error:&error];
    XCTAssertNotNil(error);
    if (error) {
        XCTAssertEqual(error.code, expectedError.code);
        XCTAssertEqualObjects(error.userInfo, expectedError.userInfo);
    } else {
        XCTFail(@"Error should have a value");
    }
    XCTAssertNil(value);

    value = [json _gptds_dictionaryForKey:@"key" required:YES error:&error];
    XCTAssertNotNil(error);
    if (error) {
        XCTAssertEqual(error.code, expectedError.code);
        XCTAssertEqualObjects(error.userInfo, expectedError.userInfo);
    } else {
        XCTFail(@"Error should have a value");
    }
    XCTAssertNil(value);
}

#pragma mark NSString

- (void)testString {
    NSDictionary *json = [self _basicJSONDictionary];
    NSError *error;
    NSString *value = [json _gptds_stringForKey:@"key" required:YES error:&error];
    XCTAssertNil(error);
    XCTAssertNotNil(value);
    XCTAssertEqualObjects(value, @"value");
}

- (void)testEmptyString {
    NSDictionary *json = @{@"key": @""};
    NSError *expectedError = [NSError _gptds_missingJSONFieldError:@"key"];
    NSError *error;
    id value;
    
    // Required empty string should produce a missing error
    value = [json _gptds_stringForKey:@"key" required:YES error:&error];
    if (error) {
        XCTAssertEqual(error.code, expectedError.code);
        XCTAssertEqualObjects(error.userInfo, expectedError.userInfo);
    } else {
        XCTFail(@"Error should have a value");
    }
    XCTAssertNil(value);
    
    // Not required empty string should produce an invalid error
    expectedError = [NSError _gptds_invalidJSONFieldError:@"key"];
    value = [json _gptds_stringForKey:@"key" required:NO error:&error];
    if (error) {
        XCTAssertEqual(error.code, expectedError.code);
        XCTAssertEqualObjects(error.userInfo, expectedError.userInfo);
    } else {
        XCTFail(@"Error should have a value");
    }
    XCTAssertNil(value);
}

- (void)testInvalidValueString {
    NSDictionary *json = [self _basicJSONDictionary];
    NSError *expectedError = [NSError _gptds_invalidJSONFieldError:@"key"];
    NSError *error;
    NSString *value = [json _gptds_stringForKey:@"key" validator:^BOOL (NSString *value) {
        return NO;
    } required:YES error:&error];
    XCTAssertNotNil(error);
    if (error) {
        XCTAssertEqual(error.code, expectedError.code);
        XCTAssertEqualObjects(error.userInfo, expectedError.userInfo);
    } else {
        XCTFail(@"Error should have a value");
    }
    XCTAssertNil(value);
}

#pragma mark NSArray

- (void)testArray {
    NSDictionary *json = @{
                           @"key": @[@{@"key": @"value"}]
                           };
    NSError *error;
    NSArray<JSONDecodableTestObject *> *array = [json _gptds_arrayForKey:@"key" arrayElementType:[JSONDecodableTestObject class] required:YES error:&error];
    XCTAssertNil(error);
    XCTAssertNotNil(array);
    if (array.count == 1) {
        XCTAssertEqualObjects([array[0] class], [JSONDecodableTestObject class]);
        XCTAssertEqualObjects(array[0].value, @"value");
    } else {
        XCTFail(@"Array was not populated");
    }
}

- (void)testInvalidElementTypeArray {
    NSDictionary *json = @{
                           @"key": @[@"value1", @"value2"]
                           };
    NSError *expectedError = [NSError _gptds_invalidJSONFieldError:@"key"];
    NSError *error;
    NSArray<JSONDecodableTestObject *> *value = [json _gptds_arrayForKey:@"key" arrayElementType:[JSONDecodableTestObject class] required:YES error:&error];
    XCTAssertNotNil(error);
    if (error) {
        XCTAssertEqual(error.code, expectedError.code);
        XCTAssertEqualObjects(error.userInfo, expectedError.userInfo);
    } else {
        XCTFail(@"Error should have a value");
    }
    XCTAssertNil(value);
}

#pragma mark NSDictionary

- (void)testDictionary {
    NSDictionary *nestedJSON = [self _basicJSONDictionary];
    NSDictionary *json = @{
                           @"key": nestedJSON
                           };
    NSError *error;
    NSDictionary *value = [json _gptds_dictionaryForKey:@"key" required:YES error:&error];
    XCTAssertNil(error);
    XCTAssertNotNil(value);
    XCTAssertEqualObjects(value, nestedJSON);
}

#pragma mark NSURL

- (void)testURL {
    NSDictionary *json = @{@"key": @"www.guavapay.com"};
    NSError *error;
    NSURL *value = [json _gptds_urlForKey:@"key" required:YES error:&error];
    XCTAssertNil(error);
    XCTAssertNotNil(value);
    XCTAssertEqualObjects(value, [NSURL URLWithString:@"www.guavapay.com"]);
}

#pragma mark BOOL

- (void)testBOOL {
    NSDictionary *json = @{@"key": @(YES)};
    NSError *error;
    BOOL value = [json _gptds_boolForKey:@"key" required:YES error:&error];
    XCTAssertNil(error);
    XCTAssertEqual(value, YES);
}

#pragma mark Helpers

- (NSDictionary *)_basicJSONDictionary {
    return @{@"key": @"value"};
}


@end
