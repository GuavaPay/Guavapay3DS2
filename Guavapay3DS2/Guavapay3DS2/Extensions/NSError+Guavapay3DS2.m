//
//  NSError+Guavapay3DS2.m
//  Guavapay3DS2
//

#import "NSError+Guavapay3DS2.h"
#import "GPTDSLocalizedString.h"

#import "GPTDSGuavapay3DS2Error.h"

@implementation NSError (Guavapay3DS2)

+ (instancetype)_gptds_invalidJSONFieldError:(NSString *)fieldName {
    return [NSError errorWithDomain:GPTDSGuavapay3DS2ErrorDomain
                               code:GPTDSErrorCodeJSONFieldInvalid
                           userInfo:@{GPTDSGuavapay3DS2ErrorFieldKey: fieldName}];
}

+ (instancetype)_gptds_missingJSONFieldError:(NSString *)fieldName {
    return [NSError errorWithDomain:GPTDSGuavapay3DS2ErrorDomain
                               code:GPTDSErrorCodeJSONFieldMissing
                           userInfo:@{GPTDSGuavapay3DS2ErrorFieldKey: fieldName}];
}

+ (instancetype)_gptds_timedOutError {
    return [NSError errorWithDomain:GPTDSGuavapay3DS2ErrorDomain
                               code:GPTDSErrorCodeTimeout
                           userInfo:@{NSLocalizedDescriptionKey : GPTDSLocalizedString(@"Timeout", @"Error description for when a network request times out. English value is as required by UL certification.")}];
}

+ (instancetype)_gptds_jweError {
    return [[NSError alloc] initWithDomain:GPTDSGuavapay3DS2ErrorDomain code:GPTDSErrorCodeDecryptionVerification userInfo:nil];
}

@end
