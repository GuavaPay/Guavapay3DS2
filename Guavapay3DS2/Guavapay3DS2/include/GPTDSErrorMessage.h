//
//  GPTDSErrorMessage.h
//  Guavapay3DS2
//

#import <Foundation/Foundation.h>

#import "GPTDSJSONEncodable.h"
#import "GPTDSJSONDecodable.h"

NS_ASSUME_NONNULL_BEGIN

/// Error codes as defined by the 3DS2 spec.
typedef NS_ENUM(NSInteger, GPTDSErrorMessageCode) {
    /// The SDK received a message that is not an ARes, CRes, or ErrorMessage.
    GPTDSErrorMessageCodeInvalidMessage = 101,
    
    /// A required data element is missing from the network response.
    GPTDSErrorMessageCodeRequiredDataElementMissing = 201,
    
    // Critical message extension not recognised
    GPTDSErrorMessageCodeUnrecognizedCriticalMessageExtension = 202,
    
    /// A data element is not in the required format or the value is invalid.
    GPTDSErrorMessageErrorInvalidDataElement = 203,
    
    // Transaction ID not recognized
    GPTDSErrorMessageErrorTransactionIDNotRecognized = 301,
    
    /// A network response could not be decrypted or verified.
    GPTDSErrorMessageErrorDataDecryptionFailure = 302,
    
    /// The SDK timed out
    GPTDSErrorMessageErrorTimeout = 402,
};

/**
 `GPTDSErrorMessage` represents an error message that is returned by the ACS or to be sent to the ACS.
 */
@interface GPTDSErrorMessage : NSObject <GPTDSJSONEncodable, GPTDSJSONDecodable>

/**
 Convenience initializer for `GPTDSErrorMessage`.

 @param errorCode                   The error code.
 @param errorComponent              The component that identified the error.
 @param errorDescription            Text describing the error.
 @param errorDetails                Additional error details.  Optional.
 @param messageVersion              The protocol version identifier.
 @param acsTransactionIdentifier    The ACS transaction identifier.
 @param errorMessageType            The message type that was identified as erroneous.
 */
- (instancetype)initWithErrorCode:(NSString *)errorCode
                   errorComponent:(NSString *)errorComponent
                 errorDescription:(NSString *)errorDescription
                     errorDetails:(nullable NSString *)errorDetails
                   messageVersion:(NSString *)messageVersion
         acsTransactionIdentifier:(nullable NSString *)acsTransactionIdentifier
                 errorMessageType:(NSString *)errorMessageType;

/**
 Designated initializer for `GPTDSErrorMessage`.
 
 @param errorCode                   The error code.
 @param errorComponent              The component that identified the error.
 @param errorDescription            Text describing the error.
 @param errorDetails                Additional error details.  Optional.
 @param messageVersion              The protocol version identifier.
 @param acsTransactionIdentifier    The ACS transaction identifier.
 @param threeDSServerTransID        Transaction identifier
 @param sdkTransactionID            The SDK Transaction Identifier.
 @param errorMessageType            The message type that was identified as erroneous.
 */
- (instancetype)initWithErrorCode:(NSString *)errorCode
                   errorComponent:(NSString *)errorComponent
                 errorDescription:(NSString *)errorDescription
                     errorDetails:(nullable NSString *)errorDetails
                   messageVersion:(NSString *)messageVersion
         acsTransactionIdentifier:(nullable NSString *)acsTransactionIdentifier
             threeDSServerTransID:(nullable NSString *)threeDSServerTransID
                 sdkTransactionID:(nullable NSString *)sdkTransactionID
                 errorMessageType:(NSString *)errorMessageType;

/**
 The error code.
 */
@property (nonatomic, readonly) NSString *errorCode;

/**
 The 3-D Secure component that identified the error.
 */
@property (nonatomic, readonly) NSString *errorComponent;

/**
 Text describing the error.
 */
@property (nonatomic, readonly) NSString *errorDescription;

/**
 Additional error details.
 */
@property (nonatomic, readonly, nullable) NSString *errorDetails;

/**
 Transaction identifier assigned by the 3DS Server to uniquely identify
 a transaction.
 */
@property (nonatomic, readonly, nullable) NSString *threeDSServerTransID;

/**
 Directory Server Transaction Identifier.
 */
@property (nonatomic, readonly, nullable) NSString *dsTransID;

/**
 The SDK Transaction Identifier.
 */
@property (nonatomic, readonly, nullable) NSString *sdkTransactionID;

/**
 The protocol version identifier.
 */
@property (nonatomic, readonly) NSString *messageVersion;

/**
 The ACS transaction identifier.
 */
@property (nonatomic, readonly, nullable) NSString *acsTransactionIdentifier;

/**
 The message type that was identified as erroneous.
 */
@property (nonatomic, readonly, nullable) NSString *errorMessageType;

/**
 A representation of the `GPTDSErrorMessage` as an `NSError`
 */
- (NSError *)NSErrorValue;

@end

NS_ASSUME_NONNULL_END
