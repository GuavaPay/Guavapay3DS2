//
//  GPTDSChallengeStatusReceiver.h
//  Guavapay3DS2
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class GPTDSTransaction, GPTDSCompletionEvent, GPTDSRuntimeErrorEvent, GPTDSProtocolErrorEvent;

NS_ASSUME_NONNULL_BEGIN

/**
 Implement the `GPTDSChallengeStatusReceiver` protocol to receive challenge status notifications at the end of the challenge process.
 @see `GPTDSTransaction.doChallenge`
 */
@protocol GPTDSChallengeStatusReceiver <NSObject>

/**
 Called when the challenge process is completed.
 
 @param completionEvent Information about the completion of the challenge process.  @see `GPTDSCompletionEvent`
 */
- (void)transaction:(GPTDSTransaction *)transaction didCompleteChallengeWithCompletionEvent:(GPTDSCompletionEvent *)completionEvent;

/**
 Called when the user selects the option to cancel the transaction on the challenge screen.
 */
- (void)transactionDidCancel:(GPTDSTransaction *)transaction;

/**
 Called when the challenge process reaches or exceeds the timeout interval that was passed to `GPTDSTransaction.doChallenge`
 */
- (void)transactionDidTimeOut:(GPTDSTransaction *)transaction;

/**
 Called when the 3DS SDK receives an EMV 3-D Secure protocol-defined error message from the ACS.
 
 @param protocolErrorEvent The error code and details.  @see `GPTDSProtocolErrorEvent`
 */
- (void)transaction:(GPTDSTransaction *)transaction didErrorWithProtocolErrorEvent:(GPTDSProtocolErrorEvent *)protocolErrorEvent;

/**
 Called when the 3DS SDK encounters errors during the challenge process. These errors include all errors except those covered by `didErrorWithProtocolErrorEvent`.
 
 @param runtimeErrorEvent The error code and details.  @see `GPTDSRuntimeErrorEvent`
 */
- (void)transaction:(GPTDSTransaction *)transaction didErrorWithRuntimeErrorEvent:(GPTDSRuntimeErrorEvent *)runtimeErrorEvent;

@optional

/**
 Optional method that will be called when the transaction displays a new challenge screen.
 */
- (void)transactionDidPresentChallengeScreen:(GPTDSTransaction *)transaction;

/**
 Optional method for custom dismissal of the challenge view controller. Meant only for internal use by Guavapay SDK.
 */
- (void)dismissChallengeViewController:(UIViewController *)challengeViewController forTransaction:(GPTDSTransaction *)transaction;

@end

NS_ASSUME_NONNULL_END
