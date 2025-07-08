//
//  NSDictionary+DecodingHelpers.h
//  Guavapay3DS2
//

#import <Foundation/Foundation.h>

#import "GPTDSJSONDecodable.h"

NS_ASSUME_NONNULL_BEGIN

/**
 Errors are populated according to the following rules:
 - If the field is required and...
 - the value is nil or empty    -> GPTDSErrorCodeJSONFieldMissing
 - the value is the wrong type  -> GPTDSErrorCodeJSONFieldInvalid
 - validator returns NO         -> GPTDSErrorCodeJSONFieldInvalid

 - If the field is not required and...
 - the value is nil             -> valid, no error
 - the value is empty           -> GPTDSErrorCodeJSONFieldInvalid
 - the value is the wrong type  -> GPTDSErrorCodeJSONFieldInvalid
 - validator returns NO         -> GPTDSErrorCodeJSONFieldInvalid
 */
@interface NSDictionary (DecodingHelpers)

/// Convenience method to extract an NSArray and populate it with instances of arrayElementType.
/// If isRequired is YES, returns nil without error if the key is not present
- (nullable NSArray *)_gptds_arrayForKey:(NSString *)key arrayElementType:(Class<GPTDSJSONDecodable>)arrayElementType required:(BOOL)isRequired error:(NSError **)error;

/// Convenience method that calls `_gptds_urlForKey:validator:required:error:`, passing nil for the validator argument
- (nullable NSURL *)_gptds_urlForKey:(NSString *)key required:(BOOL)isRequired error:(NSError **)error;

- (nullable NSURL *)_gptds_urlForKey:(NSString *)key validator:(nullable BOOL (^)(NSString * _Nonnull))validatorBlock required:(BOOL)isRequired error:(NSError * _Nullable __autoreleasing * _Nullable)error;

- (nullable NSDictionary *)_gptds_dictionaryForKey:(NSString *)key required:(BOOL)isRequired error:(NSError **)error;

- (nullable NSNumber *)_gptds_boolForKey:(NSString *)key required:(BOOL)isRequired error:(NSError **)error;

/// Convenience method that calls `_gptds_stringForKey:validator:required:error:`, passing nil for the validator argument
- (nullable NSString *)_gptds_stringForKey:(NSString *)key required:(BOOL)isRequired error:(NSError **)error;

- (nullable NSString *)_gptds_stringForKey:(NSString *)key validator:(nullable BOOL (^)(NSString *))validatorBlock required:(BOOL)isRequired error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
