//
//  NSData+JWEHelpers.h
//  Guavapay3DS2
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (JWEHelpers)

- (nullable NSString *)_gptds_base64URLEncodedString;
- (nullable NSString *)_gptds_base64URLDecodedString;

@end

NS_ASSUME_NONNULL_END
