//
//  GPTDSErrorMessage+Internal.h
//  Guavapay3DS2
//

#import <Foundation/Foundation.h>
#import "GPTDSErrorMessage.h"

NS_ASSUME_NONNULL_BEGIN

// Constructors for the circumstances in which we are required to send an ErrorMessage to the ACS
@interface GPTDSErrorMessage (Internal)

/// Received an invalid message type
+ (instancetype)errorForInvalidMessageWithACSTransactionID:(NSString *)acsTransactionID
                                            messageVersion:(NSString *)messageVersion;

/// Encountered an invalid field parsing a JSON response
+ (nullable instancetype)errorForJSONFieldInvalidWithACSTransactionID:(NSString *)acsTransactionID
                                                 threeDSServerTransID:(NSString *)threeDSServerTransID
                                                     sdkTransactionID:(NSString *)sdkTransactionID
                                                       messageVersion:(NSString *)messageVersion
                                                                error:(NSError *)error;

/// Encountered a missing field parsing a JSON response
+ (nullable instancetype)errorForJSONFieldMissingWithACSTransactionID:(NSString *)acsTransactionID messageVersion:(NSString *)messageVersion error:(NSError *)error;

/// Encountered an error decrypting a networking response
+ (instancetype)errorForDecryptionErrorWithACSTransactionID:(NSString *)acsTransactionID messageVersion:(NSString *)messageVersion;

/// Timed out
+ (instancetype)errorForTimeoutWithACSTransactionID:(NSString *)acsTransactionID messageVersion:(NSString *)messageVersion;

+ (instancetype)errorForUnrecognizedIDWithACSTransactionID:(NSString *)transactionID messageVersion:(NSString *)messageVersion;

/// Encountered unrecognized critical message extension(s)
+ (instancetype)errorForUnrecognizedCriticalMessageExtensionsWithACSTransactionID:(NSString *)acsTransactionID messageVersion:(NSString *)messageVersion error:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
