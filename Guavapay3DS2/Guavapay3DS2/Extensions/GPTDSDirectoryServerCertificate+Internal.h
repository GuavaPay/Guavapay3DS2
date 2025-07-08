//
//  GPTDSDirectoryServerCertificate+Internal.h
//  Guavapay3DS2
//

#import <Foundation/Foundation.h>

#import "GPTDSDirectoryServerCertificate.h"

NS_ASSUME_NONNULL_BEGIN

@interface GPTDSDirectoryServerCertificate (Internal)

/// Verifies the certificate chain represented by certificates where each element is a base64 encoded (NOT base64url) certificate
+ (BOOL)_verifyCertificateChain:(NSArray<NSString *> *)certificates withRootCertificates:(NSArray<NSString *> *)rootCertificates;

@end

NS_ASSUME_NONNULL_END
