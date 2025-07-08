//
//  GPTDSJSONWebEncryption.h
//  Guavapay3DS2
//

#import <Foundation/Foundation.h>

#import "GPTDSDirectoryServer.h"

@class GPTDSDirectoryServerCertificate;
@class GPTDSJSONWebSignature;

NS_ASSUME_NONNULL_BEGIN

@interface GPTDSJSONWebEncryption : NSObject

+ (nullable NSString *)encryptJSON:(NSDictionary *)json
                forDirectoryServer:(GPTDSDirectoryServer)directoryServer
                             error:(out NSError * _Nullable *)error;

+ (nullable NSString *)encryptJSON:(NSDictionary *)json
                   withCertificate:(GPTDSDirectoryServerCertificate *)certificate
                 directoryServerID:(NSString *)directoryServerID
                       serverKeyID:(nullable NSString *)serverKeyID
                             error:(out NSError * _Nullable *)error;

+ (nullable NSString *)directEncryptJSON:(NSDictionary *)json
                withContentEncryptionKey:(NSData *)contentEncryptionKey
                     forACSTransactionID:(NSString *)acsTransactionID
                                   error:(out NSError * _Nullable *)error;

+ (nullable NSDictionary *)decryptData:(NSData *)data
              withContentEncryptionKey:(NSData *)contentEncryptionKey
                                 error:(out NSError * _Nullable *)error;

+ (BOOL)verifyJSONWebSignature:(GPTDSJSONWebSignature *)jws forDirectoryServer:(GPTDSDirectoryServer)directoryServer;

+ (BOOL)verifyJSONWebSignature:(GPTDSJSONWebSignature *)jws withCertificate:(GPTDSDirectoryServerCertificate *)certificate rootCertificates:(NSArray<NSString *> *)rootCertificates;

@end

NS_ASSUME_NONNULL_END
