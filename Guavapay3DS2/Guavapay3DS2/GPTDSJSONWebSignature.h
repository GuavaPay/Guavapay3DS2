//
//  GPTDSJSONWebSignature.h
//  Guavapay3DS2
//

#import <Foundation/Foundation.h>

@class GPTDSEllipticCurvePoint;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, GPTDSJSONWebSignatureAlgorithm) {
    GPTDSJSONWebSignatureAlgorithmES256,
    GPTDSJSONWebSignatureAlgorithmPS256,
    GPTDSJSONWebSignatureAlgorithmUnknown,
};

@interface GPTDSJSONWebSignature : NSObject

- (nullable instancetype)initWithString:(NSString *)jwsString;
- (nullable instancetype)initWithString:(NSString *)jwsString allowNilKey:(BOOL)allowNilKey;

@property (nonatomic, readonly) GPTDSJSONWebSignatureAlgorithm algorithm;

@property (nonatomic, readonly) NSData *digest;
@property (nonatomic, readonly) NSData *signature;

@property (nonatomic, readonly) NSData *payload;

/// non-nil if algorithm == GPTDSJSONWebSignatureAlgorithmES256
@property (nonatomic, nullable, readonly) GPTDSEllipticCurvePoint *ellipticCurvePoint;

/// non-nil if algorithm == GPTDSJSONWebSignatureAlgorithmPS256, can be non-nil for algorithm == GPTDSJSONWebSignatureAlgorithmES256
@property (nonatomic, nullable, readonly) NSArray<NSString *> *certificateChain;

@end

NS_ASSUME_NONNULL_END
