//
//  GPTDSEllipticCurvePoint.h
//  Guavapay3DS2
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GPTDSEllipticCurvePoint : NSObject

- (nullable instancetype)initWithX:(NSData *)x y:(NSData *)y;
- (nullable instancetype)initWithCertificateData:(NSData *)certificateData;
- (nullable instancetype)initWithKey:(SecKeyRef)key;
- (nullable instancetype)initWithJWK:(NSDictionary *)jwk;

@property (nonatomic, readonly) NSData *x;
@property (nonatomic, readonly) NSData *y;

@property (nonatomic, readonly) SecKeyRef publicKey;

@end
NS_ASSUME_NONNULL_END
