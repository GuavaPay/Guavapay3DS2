//
//  NSError+Guavapay3DS2.h
//  Guavapay3DS2
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSError (Guavapay3DS2)


/// Represents an error where a JSON field value is not valid (e.g. expected 'Y' or 'N' but received something else).
+ (instancetype)_gptds_invalidJSONFieldError:(NSString *)fieldName;

/// Represents an error where a JSON field was either required or conditionally required but missing, empty, or null.
+ (instancetype)_gptds_missingJSONFieldError:(NSString *)fieldName;

/// Represents an error where a network request timed out.
+ (instancetype)_gptds_timedOutError;

// We explicitly do not provide any more info here based on security recommendations
// "the recipient MUST NOT distinguish between format, padding, and length errors of encrypted keys"
// https://tools.ietf.org/html/rfc7516#section-11.5
+ (instancetype)_gptds_jweError;

@end

NS_ASSUME_NONNULL_END
