//
//  GPTDSProtocolErrorEvent.h
//  Guavapay3DS2
//

#import <Foundation/Foundation.h>

@class GPTDSErrorMessage;

NS_ASSUME_NONNULL_BEGIN

/**
 `GPTDSProtocolErrorEvent` contains details about erorrs received from or sent to the ACS.
 */
@interface GPTDSProtocolErrorEvent : NSObject

/**
 Designated initializer for `GPTDSProtocolErrorEvent`.
 */
- (instancetype)initWithSDKTransactionIdentifier:(NSString *)identifier errorMessage:(GPTDSErrorMessage *)errorMessage;

/**
 `GPTDSProtocolErrorEvent` should not be directly initialized.
 */
- (instancetype)init NS_UNAVAILABLE;

/**
 Details about the error.
 */
@property (nonatomic, readonly) GPTDSErrorMessage *errorMessage;

/**
 The SDK Transaction Identifier.
 */
@property (nonatomic, readonly) NSString *sdkTransactionIdentifier;

@end

NS_ASSUME_NONNULL_END
