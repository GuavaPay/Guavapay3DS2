//
//  GPTDSJSONEncoderTest.m
//  Guavapay3DS2Tests
//

#import <XCTest/XCTest.h>

#import "GPTDSJSONEncoder.h"

#pragma mark - GPTDSJSONEncodableObject

@interface GPTDSJSONEncodableObject : NSObject <GPTDSJSONEncodable>
@property (nonatomic, copy) NSString *testProperty;
@property (nonatomic, copy) NSArray *testArrayProperty;
@property (nonatomic, copy) NSDictionary *testDictionaryProperty;
@property (nonatomic) GPTDSJSONEncodableObject *testNestedObjectProperty;
@end

@implementation GPTDSJSONEncodableObject

+ (NSDictionary *)propertyNamesToJSONKeysMapping {
    return @{
             NSStringFromSelector(@selector(testProperty)): @"test_property",
             NSStringFromSelector(@selector(testArrayProperty)): @"test_array_property",
             NSStringFromSelector(@selector(testDictionaryProperty)): @"test_dictionary_property",
             NSStringFromSelector(@selector(testNestedObjectProperty)): @"test_nested_property",
             };
}

@end

#pragma mark - GPTDSJSONEncoderTest

@interface GPTDSJSONEncoderTest : XCTestCase
@end

@implementation GPTDSJSONEncoderTest

- (void)testEmptyEncodableObject {
    GPTDSJSONEncodableObject *object = [GPTDSJSONEncodableObject new];
    XCTAssertEqualObjects([GPTDSJSONEncoder dictionaryForObject:object], @{});
}

- (void)testNestedObject {
    GPTDSJSONEncodableObject *object = [GPTDSJSONEncodableObject new];
    GPTDSJSONEncodableObject *nestedObject = [GPTDSJSONEncodableObject new];
    nestedObject.testProperty = @"nested_object_property";
    object.testProperty = @"object_property";
    object.testNestedObjectProperty = nestedObject;
    NSDictionary *jsonDictionary = [GPTDSJSONEncoder dictionaryForObject:object];
    NSDictionary *expected = @{
                               @"test_property": @"object_property",
                               @"test_nested_property": @{
                                       @"test_property": @"nested_object_property",
                                       }
                               };
    XCTAssertEqualObjects(jsonDictionary, expected);
    XCTAssertTrue([NSJSONSerialization isValidJSONObject:jsonDictionary]);
}

- (void)testSerializeDeserialize {
    GPTDSJSONEncodableObject *object = [GPTDSJSONEncodableObject new];
    object.testProperty = @"test";
    NSDictionary *expected = @{@"test_property": @"test"};
    NSData *data = [NSJSONSerialization dataWithJSONObject:[GPTDSJSONEncoder dictionaryForObject:object] options:0 error:nil];
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    XCTAssertEqualObjects(expected, jsonObject);
}

- (void)testBoolAndNumbers {
    GPTDSJSONEncodableObject *testObject = [GPTDSJSONEncodableObject new];
    testObject.testArrayProperty = @[@0,
                                     @1,
                                     [NSNumber numberWithBool:NO],
                                     [[NSNumber alloc] initWithBool:YES],
                                     @YES];
    NSDictionary *jsonDictionary = [GPTDSJSONEncoder dictionaryForObject:testObject];
    NSDictionary *expected = @{
                               @"test_array_property": @[
                                       @0,
                                       @1,
                                       [NSNumber numberWithBool:NO],
                                       [[NSNumber alloc] initWithBool:YES],
                                       @YES],
                               };
    XCTAssertEqualObjects(jsonDictionary, expected);
    XCTAssertTrue([NSJSONSerialization isValidJSONObject:jsonDictionary]);
    
}

#pragma mark NSArray

- (void)testArrayValueEmpty {
    GPTDSJSONEncodableObject *testObject = [GPTDSJSONEncodableObject new];
    testObject.testProperty = @"success";
    testObject.testArrayProperty = @[];
    NSDictionary *jsonDictionary = [GPTDSJSONEncoder dictionaryForObject:testObject];
    NSDictionary *expected = @{
                               @"test_property": @"success",
                               @"test_array_property": @[]
                               };
    XCTAssertEqualObjects(jsonDictionary, expected);
    XCTAssertTrue([NSJSONSerialization isValidJSONObject:jsonDictionary]);
}

- (void)testArrayValue {
    GPTDSJSONEncodableObject *testObject = [GPTDSJSONEncodableObject new];
    testObject.testProperty = @"success";
    testObject.testArrayProperty = @[@1, @2, @3];
    NSDictionary *jsonDictionary = [GPTDSJSONEncoder dictionaryForObject:testObject];
    NSDictionary *expected = @{
                               @"test_property": @"success",
                               @"test_array_property": @[@1, @2, @3]
                               };
    XCTAssertEqualObjects(jsonDictionary, expected);
    XCTAssertTrue([NSJSONSerialization isValidJSONObject:jsonDictionary]);

}

- (void)testArrayOfEncodable {
    GPTDSJSONEncodableObject *testObject = [GPTDSJSONEncodableObject new];

    GPTDSJSONEncodableObject *inner1 = [GPTDSJSONEncodableObject new];
    inner1.testProperty = @"inner1";
    GPTDSJSONEncodableObject *inner2 = [GPTDSJSONEncodableObject new];
    inner2.testArrayProperty = @[@"inner2"];

    testObject.testArrayProperty = @[inner1, inner2];
    NSDictionary *jsonDictionary = [GPTDSJSONEncoder dictionaryForObject:testObject];
    NSDictionary *expected = @{
                               @"test_array_property": @[
                                       @{
                                           @"test_property": @"inner1"
                                           },
                                       @{
                                           @"test_array_property": @[@"inner2"]
                                           }
                                       ]
                               };
    XCTAssertEqualObjects(jsonDictionary, expected);
    XCTAssertTrue([NSJSONSerialization isValidJSONObject:jsonDictionary]);
}

#pragma mark NSDictionary

- (void)testDictionaryValueEmpty {
    GPTDSJSONEncodableObject *testObject = [GPTDSJSONEncodableObject new];
    testObject.testProperty = @"success";
    testObject.testDictionaryProperty = @{};
    NSDictionary *jsonDictionary = [GPTDSJSONEncoder dictionaryForObject:testObject];
    NSDictionary *expected = @{
                               @"test_property": @"success",
                               @"test_dictionary_property": @{}
                               };
    XCTAssertEqualObjects(jsonDictionary, expected);
    XCTAssertTrue([NSJSONSerialization isValidJSONObject:jsonDictionary]);
}

- (void)testDictionaryValue {
    GPTDSJSONEncodableObject *testObject = [GPTDSJSONEncodableObject new];
    testObject.testProperty = @"success";
    testObject.testDictionaryProperty = @{@"foo": @"bar"};
    NSDictionary *jsonDictionary = [GPTDSJSONEncoder dictionaryForObject:testObject];
    NSDictionary *expected = @{
                               @"test_property": @"success",
                               @"test_dictionary_property": @{@"foo": @"bar"}
                               };
    XCTAssertEqualObjects(jsonDictionary, expected);
    XCTAssertTrue([NSJSONSerialization isValidJSONObject:jsonDictionary]);

}

- (void)testDictionaryOfEncodable {
    GPTDSJSONEncodableObject *testObject = [GPTDSJSONEncodableObject new];

    GPTDSJSONEncodableObject *inner1 = [GPTDSJSONEncodableObject new];
    inner1.testProperty = @"inner1";
    GPTDSJSONEncodableObject *inner2 = [GPTDSJSONEncodableObject new];
    inner2.testArrayProperty = @[@"inner2"];

    testObject.testDictionaryProperty = @{@"one": inner1, @"two": inner2};

    NSDictionary *jsonDictionary = [GPTDSJSONEncoder dictionaryForObject:testObject];
    NSDictionary *expected = @{
                               @"test_dictionary_property": @{
                                       @"one": @{
                                               @"test_property": @"inner1"
                                               },
                                       @"two": @{
                                               @"test_array_property": @[@"inner2"]
                                               }
                                       }
                               };
    XCTAssertEqualObjects(jsonDictionary, expected);
    XCTAssertTrue([NSJSONSerialization isValidJSONObject:jsonDictionary]);
}

@end
