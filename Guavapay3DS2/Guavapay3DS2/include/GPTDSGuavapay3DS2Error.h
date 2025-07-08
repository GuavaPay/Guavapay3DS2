//
//  GPTDSGuavapay3DS2Error.h
//  Guavapay3DS2
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString * const GPTDSGuavapay3DS2ErrorDomain;

/**
 NSError.userInfo contains this key if we received an ErrorMessage instead of the expected response object.
 The value of this key is the ErrorMessage.
 */
FOUNDATION_EXPORT NSString * const GPTDSGuavapay3DS2ErrorMessageErrorKey;

/**
 NSError.userInfo contains this key if we errored parsing JSON.
 The value of this key is the invalid or missing field.
 */
FOUNDATION_EXPORT NSString * const GPTDSGuavapay3DS2ErrorFieldKey;

/**
 NSError.userInfo contains this key if we couldn't recognize critical message extension(s)
 The value of this key is an array of identifiers.
 */
FOUNDATION_EXPORT NSString * const GPTDSGuavapay3DS2UnrecognizedCriticalMessageExtensionsKey;


typedef NS_ENUM(NSInteger, GPTDSErrorCode) {

    /// Code triggered an assertion
    GPTDSErrorCodeAssertionFailed = 204,
    
    // JSON Parsing
    /// Received invalid or malformed data
    GPTDSErrorCodeJSONFieldInvalid = 203,
    /// Expected field missing
    GPTDSErrorCodeJSONFieldMissing = 201,

    /// Critical message extension not recognised
    GPTDSErrorCodeUnrecognizedCriticalMessageExtension = 202,
    
    /// Decryption or verification error
    GPTDSErrorCodeDecryptionVerification = 302,

    /// Error code corresponding to a `GPTDSRuntimeErrorEvent` for an unparseable network response
    GPTDSErrorCodeRuntimeParsing = 400,
    /// Error code corresponding to a `GPTDSRuntimeErrorEvent` for an error with decrypting or verifying a network response
    GPTDSErrorCodeRuntimeEncryption = 401,
    
    // Networking
    /// We received an ErrorMessage instead of the expected response object.  `userInfo[GPTDSGuavapay3DS2ErrorMessageErrorKey]` will contain the ErrorMessage object.
    GPTDSErrorCodeReceivedErrorMessage = 1000,
    /// We received an unknown message type.
    GPTDSErrorCodeUnknownMessageType = 1001,
    /// Request timed out
    GPTDSErrorCodeTimeout = 1002,
    
    /// Unknown
    GPTDSErrorCodeUnknownError = 2000,
};

NS_ASSUME_NONNULL_END
