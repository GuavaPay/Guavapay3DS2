//
//  GPTDSTransaction.h
//  Guavapay3DS2
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^GPTDSTransactionVoidBlock)(void);

@class GPTDSAuthenticationRequestParameters, GPTDSChallengeParameters;
@protocol GPTDSChallengeStatusReceiver;
@protocol GPTDSChallengeResponseViewControllerDelegate;

NS_ASSUME_NONNULL_BEGIN

/**
 `GPTDSTransaction` holds parameters that the 3DS Server requires to create AReq messages and to perform the Challenge Flow.
 */
@interface GPTDSTransaction : NSObject

/**
 The UI type of the presented challenge for this transaction if applicable. Will be one of
 "none"
 "text"
 "single_select"
 "multi_select"
 "oob"
 "html"
 */
@property (nonatomic, readonly, copy) NSString *presentedChallengeUIType;

/**
 Encrypts device information collected during initialization and returns it along with SDK details.

 @return Encrypted device information and details about this SDK.  @see GPTDSAuthenticationRequestParameters

 @exception SDKRuntimeException Thrown if an internal error is encountered.
 */
- (GPTDSAuthenticationRequestParameters *)createAuthenticationRequestParameters;

/**
 Returns a UIViewController instance displaying the Directory Server logo and a spinner.  Present this during the Authentication Request/Response.
 */
- (UIViewController *)createProgressViewControllerWithDidCancel:(GPTDSTransactionVoidBlock)didCancel;

/**
 Initiates the challenge process, displaying challenge UI as needed.

 @param presentingViewController        The UIViewController used to present the challenge response UIViewController
 @param challengeParameters             Details required to conduct the challenge process.  @see GPTDSChallengeParameters
 @param messageExtensions               Optional list of dictionaries for OOB challenge
 @param challengeStatusReceiver         A callback object to receive the status of the challenge.  See @GPTDSChallengeStatusReceiver
 @param oobDelegate                     Delegate responsible to open bank application with oobAppURL.  See @GPTDSChallengeResponseViewControllerOOBDelegate
 @param timeout                         An interval in seconds within which the challenge process will finish.  Must be at least 5 minutes.

 @exception GPTDSInvalidInputException    Thrown if an argument is invalid (e.g. timeout less than 5 minutes).  @see GPTDSInvalidInputException
 @exception GPTDSSDKRuntimeException      Thrown if an internal error is encountered, and if you call this method after calling `close`.  @see SDKRuntimeException

 @note challengeStatusReceiver must conform to <GPTDSChallengeStatusReceiver>. This is a workaround: When the static Guavapay3DS2 is compiled into Guavapay.framework, the resulting swiftinterface and generated .h files reference this protocol. To allow users to build without including Guavapay3DS2 directly, we'll take an `id` here instead.
 */
- (void)doChallengeWithViewController:(UIViewController *)presentingViewController
                  challengeParameters:(GPTDSChallengeParameters *)challengeParameters
                    messageExtensions:(nullable NSArray<NSDictionary *> *)messageExtensions
              challengeStatusReceiver:(id)challengeStatusReceiver
                          oobDelegate:(nullable id) oobDelegate
                              timeout:(NSTimeInterval)timeout;

/**
 Returns the version of the Guavapay3DS2 SDK, e.g. @"1.0"
 */
- (NSString *)sdkVersion;

- (void)setCertificatesWithCustomCertificate:(NSString *)customCertificate
                            rootCertificates:(NSArray<NSString *> *)rootCertificateStrings;

/**
 Cleans up resources held by `GPTDSTransaction`.  Call this when the transaction is completed, if `doChallengeWithChallengeParameters:challengeStatusReceiver:timeout` is not called.

 @note Don't use this object after calling this method.  Calling `doChallengeWithViewController:challengeParameters:challengeStatusReceiver:timeout` after calling this method will throw an `GPTDSSDKRuntimeException`
 */
- (void)close;

/**
 Alternate challenge initiation method meant only for internal use by Guavapay SDK.
 */
- (void)doChallengeWithChallengeParameters:(GPTDSChallengeParameters *)challengeParameters
                         messageExtensions:(nullable NSArray<NSDictionary *> *)messageExtensions
                   challengeStatusReceiver:(id)challengeStatusReceiver
                               oobDelegate:(nullable id) delegate
                                   timeout:(NSTimeInterval)timeout
                         presentationBlock:(void (^)(UIViewController *, void(^)(void)))presentationBlock;

/**
 Function to manually cancel the challenge flow.
 */
- (void)cancelChallengeFlow;

@end

NS_ASSUME_NONNULL_END
