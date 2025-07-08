//
//  GPTDSJSONEncoder.m
//  Guavapay3DS2
//

#import "GPTDSJSONEncoder.h"

@implementation GPTDSJSONEncoder

+ (NSDictionary *)dictionaryForObject:(nonnull NSObject<GPTDSJSONEncodable> *)object {
    NSMutableDictionary *keyPairs = [NSMutableDictionary dictionary];
    [[object.class propertyNamesToJSONKeysMapping] enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull propertyName, NSString *  _Nonnull keyName, __unused BOOL * _Nonnull stop) {
        id value = [self jsonEncodableValueForObject:[object valueForKey:propertyName]];
        if (value != [NSNull null]) {
            keyPairs[keyName] = value;
        }
    }];
    return [keyPairs copy];
}

+ (id)jsonEncodableValueForObject:(NSObject *)object {
    if ([object conformsToProtocol:@protocol(GPTDSJSONEncodable)]) {
        return [self dictionaryForObject:(NSObject<GPTDSJSONEncodable>*)object];
    } else if ([object isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = (NSDictionary *)object;
        NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:dict.count];
        
        [dict enumerateKeysAndObjectsUsingBlock:^(id _Nonnull key, id  _Nonnull value, __unused BOOL * _Nonnull stop) {
            result[key] = [self jsonEncodableValueForObject:value];
        }];
        
        return result;
    } else if ([object isKindOfClass:[NSArray class]]) {
        NSArray *array = (NSArray *)object;
        NSMutableArray *result = [NSMutableArray arrayWithCapacity:array.count];
        
        for (NSObject *element in array) {
            [result addObject:[self jsonEncodableValueForObject:element]];
        }
        return result;
    } else if ([object isKindOfClass:[NSString class]] || [object isKindOfClass:[NSNumber class]]) {
        return object;
    } else {
        return [NSNull null];
    }
}

@end
