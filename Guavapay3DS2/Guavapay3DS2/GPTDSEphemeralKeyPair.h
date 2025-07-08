//
//  GPTDSEphemeralKeyPair.h
//  Guavapay3DS2
//

#import <Foundation/Foundation.h>

@class GPTDSDirectoryServerCertificate;
@class GPTDSEllipticCurvePoint;

#import "GPTDSDirectoryServer.h"

NS_ASSUME_NONNULL_BEGIN

@interface GPTDSEphemeralKeyPair : NSObject

/// Creates a returns a new elliptic curve key pair using curve P-256
+ (nullable instancetype)ephemeralKeyPair;

- (instancetype)init NS_UNAVAILABLE;

@property (nonatomic, readonly) NSString *publicKeyJWK;
@property (nonatomic, readonly) GPTDSEllipticCurvePoint *publicKeyCurvePoint;

/**
 Creates and returns a new secret key derived using Elliptic Curve Diffie-Hellman
 and the certificate's public key (return nil on failure).
 Per OpenSSL documentation: Never use a derived secret directly. Typically it is passed through some
 hash function to produce a key (e.g. pass the secret as the first argument to GPTDSCreateConcatKDFWithSHA256)
 */
- (nullable NSData *)createSharedSecretWithEllipticCurveKey:(GPTDSEllipticCurvePoint *)ecKey;
- (nullable NSData *)createSharedSecretWithCertificate:(GPTDSDirectoryServerCertificate *)certificate;

@end

NS_ASSUME_NONNULL_END
