//
//  GPTDSRuntimeErrorEvent.h
//  Guavapay3DS2
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXTERN NSString * const kGPTDSRuntimeErrorCodeParsingError;
FOUNDATION_EXTERN NSString * const kGPTDSRuntimeErrorCodeEncryptionError;

/**
 `GPTDSRuntimeErrorEvent` contains details about run-time errors encountered during authentication.
 
 The following are examples of run-time errors:
 - ACS is unreachable
 - Unparseable message
 - Network issues
 */
@interface GPTDSRuntimeErrorEvent : NSObject

/**
 A code corresponding to the type of error this represents.
 */
@property (nonatomic, readonly) NSString *errorCode;

/**
 Details about the error.
 */
@property (nonatomic, readonly) NSString *errorMessage;

/**
 Designated initializer for `GPTDSRuntimeErrorEvent`.
 */
- (instancetype)initWithErrorCode:(NSString *)errorCode errorMessage:(NSString *)errorMessage NS_DESIGNATED_INITIALIZER;

/**
 A representation of the `GPTDSRuntimeErrorEvent` as an `NSError`
 */
- (NSError *)NSErrorValue;

/**
 `GPTDSRuntimeErrorEvent` should not be directly initialized.
 */
- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
