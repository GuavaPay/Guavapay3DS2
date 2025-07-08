//
//  NSString+JWEHelpers.h
//  Guavapay3DS2
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (JWEHelpers)

- (nullable NSString *)_gptds_base64URLEncodedString;
- (nullable NSString *)_gptds_base64URLDecodedString;
- (nullable NSData *)_gptds_base64URLDecodedData;

@end

NS_ASSUME_NONNULL_END
