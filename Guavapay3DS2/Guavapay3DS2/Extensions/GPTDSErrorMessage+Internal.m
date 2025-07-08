//
//  GPTDSErrorMessage+Internal.m
//  Guavapay3DS2
//

#import "GPTDSErrorMessage+Internal.h"
#import "GPTDSGuavapay3DS2Error.h"

@implementation GPTDSErrorMessage (Internal)

+ (NSString *)_stringForErrorCode:(GPTDSErrorMessageCode)errorCode {
    return [NSString stringWithFormat:@"%ld", (long)errorCode];
}

+ (instancetype)errorForInvalidMessageWithACSTransactionID:(nonnull NSString *)acsTransactionID messageVersion:(nonnull NSString *)messageVersion {
    return [[[self class] alloc] initWithErrorCode:[self _stringForErrorCode:GPTDSErrorMessageCodeInvalidMessage]
                                    errorComponent:@"C"
                                  errorDescription:@"Message not recognized"
                                      errorDetails:@"Unknown message type"
                                    messageVersion:messageVersion
                          acsTransactionIdentifier:acsTransactionID
                                  errorMessageType:@"CRes"];
    
}

+ (nullable instancetype)errorForJSONFieldMissingWithACSTransactionID:(NSString *)acsTransactionID messageVersion:(NSString *)messageVersion error:(NSError *)error {
    return [[[self class] alloc] initWithErrorCode:[self _stringForErrorCode:GPTDSErrorMessageCodeRequiredDataElementMissing]
                                    errorComponent:@"C"
                                  errorDescription:@"Missing Field"
                                      errorDetails:error.userInfo[GPTDSGuavapay3DS2ErrorFieldKey]
                                    messageVersion:messageVersion
                          acsTransactionIdentifier:acsTransactionID
                                  errorMessageType:@"CRes"];
}

+ (nullable instancetype)errorForJSONFieldInvalidWithACSTransactionID:(NSString *)acsTransactionID
                                                 threeDSServerTransID:(NSString *)threeDSServerTransID
                                             sdkTransactionID:(NSString *)sdkTransactionIdentifier
                                                       messageVersion:(NSString *)messageVersion
                                                                error:(NSError *)error {
    return [[[self class] alloc] initWithErrorCode:[self _stringForErrorCode:GPTDSErrorMessageErrorInvalidDataElement]
                                    errorComponent:@"C"
                                  errorDescription:@"Invalid Field"
                                      errorDetails:error.userInfo[GPTDSGuavapay3DS2ErrorFieldKey]
                                    messageVersion:messageVersion
                          acsTransactionIdentifier:acsTransactionID
                              threeDSServerTransID:threeDSServerTransID
                                  sdkTransactionID:sdkTransactionIdentifier
                                  errorMessageType:@"CRes"];
}

+ (instancetype)errorForDecryptionErrorWithACSTransactionID:(NSString *)acsTransactionID messageVersion:(NSString *)messageVersion {
    return [[[self class] alloc] initWithErrorCode:[self _stringForErrorCode:GPTDSErrorMessageErrorDataDecryptionFailure]
                                    errorComponent:@"C"
                                  errorDescription:@"Response could not be decrypted."
                                      errorDetails:@"Response could not be decrypted.s"
                                    messageVersion:messageVersion
                          acsTransactionIdentifier:acsTransactionID
                                  errorMessageType:@"CRes"];
}

+ (instancetype)errorForTimeoutWithACSTransactionID:(NSString *)acsTransactionID messageVersion:(NSString *)messageVersion {
    return [[[self class] alloc] initWithErrorCode:[self _stringForErrorCode:GPTDSErrorMessageErrorTimeout]
                                    errorComponent:@"C"
                                  errorDescription:@"Transaction timed out."
                                      errorDetails:@"Transaction timed out."
                                    messageVersion:messageVersion
                          acsTransactionIdentifier:acsTransactionID
                                  errorMessageType:@"CRes"];
}

+ (instancetype)errorForUnrecognizedIDWithACSTransactionID:(NSString *)acsTransactionID messageVersion:(NSString *)messageVersion {
    return [[[self class] alloc] initWithErrorCode:[self _stringForErrorCode:GPTDSErrorMessageErrorTransactionIDNotRecognized]
                                    errorComponent:@"C"
                                  errorDescription:@"Unrecognized transaction ID"
                                      errorDetails:@"Unrecognized transaction ID"
                                    messageVersion:messageVersion
                          acsTransactionIdentifier:acsTransactionID
                                  errorMessageType:@"CRes"];
}

+ (instancetype)errorForUnrecognizedCriticalMessageExtensionsWithACSTransactionID:(NSString *)acsTransactionID messageVersion:(NSString *)messageVersion error:(NSError *)error {
    NSArray *unrecognizedIDs = error.userInfo[GPTDSGuavapay3DS2UnrecognizedCriticalMessageExtensionsKey];
    
    return [[[self class] alloc] initWithErrorCode:[self _stringForErrorCode:GPTDSErrorMessageCodeUnrecognizedCriticalMessageExtension]
                                    errorComponent:@"C"
                                  errorDescription:@"Critical message extension not recognised."
                                      errorDetails:[unrecognizedIDs componentsJoinedByString:@","]
                                    messageVersion:messageVersion
                          acsTransactionIdentifier:acsTransactionID
                                  errorMessageType:@"CRes"];
}

@end
