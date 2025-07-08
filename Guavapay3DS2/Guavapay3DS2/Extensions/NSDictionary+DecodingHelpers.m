//
//  NSDictionary+DecodingHelpers.m
//  Guavapay3DS2
//

#import "NSDictionary+DecodingHelpers.h"

#import "NSError+Guavapay3DS2.h"

@implementation NSDictionary (DecodingHelpers)

#pragma mark - NSArray

- (nullable NSArray *)_gptds_arrayForKey:(NSString *)key arrayElementType:(Class<GPTDSJSONDecodable>)arrayElementType required:(BOOL)isRequired error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    id value = self[key];

    // Missing?
    if (value == nil
        || [value isKindOfClass:[NSNull class]]
        || ([value isKindOfClass:[NSArray class]] && ((NSArray *)value).count == 0)) {
        if (isRequired && error) {
            *error = [NSError _gptds_missingJSONFieldError:key];
        }
        return nil;
    }

    // Invalid type or value?
    if (![value isKindOfClass:[NSArray class]]) {
        if (error) {
            *error = [NSError _gptds_invalidJSONFieldError:key];
        }
        return nil;
    }

    NSMutableArray *returnArray = [NSMutableArray new];
    for (id json in value) {
        if (![json isKindOfClass:[NSDictionary class]]) {
            if (error) {
                *error = [NSError _gptds_invalidJSONFieldError:key];
            }
            return nil;
        }
        id<GPTDSJSONDecodable> element = [arrayElementType decodedObjectFromJSON:json error:error];
        if (element) {
            [returnArray addObject:element];
        }
    }

    return returnArray;
}

#pragma mark - NSURL

- (nullable NSURL *)_gptds_urlForKey:(NSString *)key required:(BOOL)isRequired error:(NSError * _Nullable __autoreleasing *)error {
    return [self _gptds_urlForKey:key validator:nil required:isRequired error:error];
}

- (nullable NSURL *)_gptds_urlForKey:(NSString *)key validator:(nullable BOOL (^)(NSString * _Nonnull))validatorBlock required:(BOOL)isRequired error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    NSString *urlRawString = [self _gptds_stringForKey:key validator:^BOOL (NSString *value) {
        return [NSURL URLWithString:value] != nil;
    } required:isRequired error:error];

    // Invalid value?
    if (validatorBlock && !validatorBlock(urlRawString)) {
        if (error) {
            *error = [NSError _gptds_invalidJSONFieldError:key];
        }
        return nil;
    }

    if (urlRawString) {
        return [NSURL URLWithString:urlRawString];
    } else {
        return nil;
    }
}

#pragma mark - NSDictionary

- (nullable NSDictionary *)_gptds_dictionaryForKey:(NSString *)key required:(BOOL)isRequired error:(NSError * _Nullable __autoreleasing *)error {
    id value = self[key];

    // Missing?
    if (value == nil) {
        if (error && isRequired) {
            *error = [NSError _gptds_missingJSONFieldError:key];
        }
        return nil;
    }

    // Invalid type?
    if (![value isKindOfClass:[NSDictionary class]]) {
        if (error) {
            *error = [NSError _gptds_invalidJSONFieldError:key];
        }
        return nil;
    }

    return value;
}

#pragma mark - NSString

- (nullable NSString *)_gptds_stringForKey:(NSString *)key required:(BOOL)isRequired error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    return [self _gptds_stringForKey:key validator:nil required:isRequired error:error];
}

- (nullable NSString *)_gptds_stringForKey:(NSString *)key validator:(nullable BOOL (^)(NSString * _Nonnull))validatorBlock required:(BOOL)isRequired error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    id value = self[key];

    // Missing?
    if (value == nil || ([value isKindOfClass:[NSString class]] && ((NSString *)value).length == 0)) {
        if (error) {
            if (isRequired) {
                *error = [NSError _gptds_missingJSONFieldError:key];
            } else if (value != nil) {
                *error = [NSError _gptds_invalidJSONFieldError:key];
            }
        }
        return nil;
    }

    // Invalid type or value?
    if (![value isKindOfClass:[NSString class]] || (validatorBlock && !validatorBlock(value))) {
        if (error) {
            *error = [NSError _gptds_invalidJSONFieldError:key];
        }
        return nil;
    }

    return value;
}

#pragma mark - NSURL

- (NSNumber *)_gptds_boolForKey:(NSString *)key required:(BOOL)isRequired error:(NSError * _Nullable __autoreleasing *)error {
    id value = self[key];

    // Missing?
    if (value == nil) {
        if (error && isRequired) {
            *error = [NSError _gptds_missingJSONFieldError:key];
        }
        return nil;
    }

    // Invalid type?
    if (![value isKindOfClass:[NSNumber class]]) {
        if (error) {
            *error = [NSError _gptds_invalidJSONFieldError:key];
        }
        return nil;
    }

    return value;
}

@end
