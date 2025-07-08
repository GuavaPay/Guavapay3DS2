//
//  NSData+JWEHelpers.m
//  Guavapay3DS2
//

#import "NSData+JWEHelpers.h"

#import "NSString+JWEHelpers.h"

NS_ASSUME_NONNULL_BEGIN

@implementation NSData (GPTDSJSONWebEncryption)

- (nullable NSString *)_gptds_base64URLEncodedString {
    // ref. https://tools.ietf.org/html/draft-ietf-jose-json-web-signature-41#appendix-C
    NSString *unpaddedBase64EncodedString = [[[[self base64EncodedStringWithOptions:0]
                                               stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"="]] // remove extra padding
                                              stringByReplacingOccurrencesOfString:@"+" withString:@"-"] // replace "+" character w/ "-"
                                             stringByReplacingOccurrencesOfString:@"/" withString:@"_"]; // replace "/" character w/ "_"
    
    return unpaddedBase64EncodedString;
}

- (nullable NSString *)_gptds_base64URLDecodedString {
    return [[[self base64EncodedStringWithOptions:0]
             stringByReplacingOccurrencesOfString:@"-" withString:@"+"] // replace "-" character w/ "+"
            stringByReplacingOccurrencesOfString:@"_" withString:@"/"]; // replace "_" character w/ "/"
}

@end

NS_ASSUME_NONNULL_END
