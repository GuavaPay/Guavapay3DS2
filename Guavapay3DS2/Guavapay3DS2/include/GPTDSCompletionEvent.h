//
//  GPTDSCompletionEvent.h
//  Guavapay3DS2
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 `GPTDSCompletionEvent` contains information about completion of the challenge process.
 */
@interface GPTDSCompletionEvent : NSObject

/**
 Designated initializer for `GPTDSCompletionEvent`.
 */
- (instancetype)initWithSDKTransactionIdentifier:(NSString *)identifier transactionStatus:(NSString *)transactionStatus NS_DESIGNATED_INITIALIZER;

/**
 `GPTDSCompletionEvent` should not be directly initialized.
 */
- (instancetype)init NS_UNAVAILABLE;

/**
 The SDK Transaction ID.
 */
@property (nonatomic, readonly) NSString *sdkTransactionIdentifier;

/**
 The transaction status that was received in the final challenge response.
 */
@property (nonatomic, readonly) NSString *transactionStatus;

@end

NS_ASSUME_NONNULL_END
