//
//  GPTDSDirectoryServerCertificate.h
//  Guavapay3DS2
//

#import <Foundation/Foundation.h>

@class GPTDSJSONWebSignature;

#import "GPTDSDirectoryServer.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, GPTDSDirectoryServerKeyType) {
    GPTDSDirectoryServerKeyTypeRSA,
    GPTDSDirectoryServerKeyTypeEC,
    GPTDSDirectoryServerKeyTypeUnknown,
};

@interface GPTDSDirectoryServerCertificate : NSObject

+ (nullable instancetype)certificateForDirectoryServer:(GPTDSDirectoryServer)directoryServer;

+ (nullable instancetype)customCertificateWithData:(NSData *)certificateData;

+ (nullable instancetype)customCertificateWithString:(NSString *)certificateString;

@property (nonatomic, readonly) GPTDSDirectoryServerKeyType keyType;

@property (nonatomic, readonly) SecKeyRef publicKey;

@property (nonatomic, readonly, copy) NSString *certificateString;

- (nullable NSData *)encryptDataUsingRSA_OAEP_SHA256:(NSData *)plaintext;

+ (BOOL)verifyJSONWebSignature:(GPTDSJSONWebSignature *)jws withRootCertificates:(NSArray<NSString *> *)rootCertificates;

@end

NS_ASSUME_NONNULL_END
