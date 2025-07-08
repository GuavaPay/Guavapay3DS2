//
//  GPTDSChallengeResponseViewControllerDelegate.h
//  Guavapay3DS2
//

#import "GPTDSChallengeResponse.h"

@class GPTDSChallengeResponseViewController;
@protocol GPTDSAnalyticsDelegate;

NS_ASSUME_NONNULL_BEGIN

@protocol GPTDSChallengeResponseViewControllerDelegate

/**
 Called when the user taps the Submit button after entering text in the Text flow (GPTDSACSUITypeText)
 */
- (void)challengeResponseViewController:(GPTDSChallengeResponseViewController *)viewController
                         didSubmitInput:(NSString *)userInput
                     whitelistSelection:(id<GPTDSChallengeResponseSelectionInfo>) whitelistSelection;

/**
 Called when the user taps the Submit button after selecting one or more options in the Single-Select (GPTDSACSUITypeSingleSelect) or Multi-Select (GPTDSACSUITypeMultiSelect) flow.
 */
- (void)challengeResponseViewController:(GPTDSChallengeResponseViewController *)viewController
                     didSubmitSelection:(NSArray<id<GPTDSChallengeResponseSelectionInfo>> *)selection
                     whitelistSelection:(id<GPTDSChallengeResponseSelectionInfo>) whitelistSelection;

/**
 Called when the user submits an HTML form.
 */
- (void)challengeResponseViewController:(GPTDSChallengeResponseViewController *)viewController
                      didSubmitHTMLForm:(NSString *)form;

/**
 Called when the user taps the Continue button from an Out-of-Band flow (GPTDSACSUITypeOOB).
 */
- (void)challengeResponseViewControllerDidOOBContinue:(GPTDSChallengeResponseViewController *)viewController
                                   whitelistSelection:(id<GPTDSChallengeResponseSelectionInfo>) whitelistSelection;

/**
 Called when the user taps the Cancel button.
 */
- (void)challengeResponseViewControllerDidCancel:(GPTDSChallengeResponseViewController *)viewController;

/**
 Called when the user taps the Resend button.
 */
- (void)challengeResponseViewControllerDidRequestResend:(GPTDSChallengeResponseViewController *)viewController;

@end

@protocol GPTDSChallengeResponseViewControllerOOBDelegate

/**
 Called when the user taps the button to open bank application from an Out-of-Band flow (GPTDSACSUITypeOOB).
 */
- (void)challengeResponseViewController:(GPTDSChallengeResponseViewController *)viewController
                      didRequestOpenApp:(NSURL *)oobAppURL;

@end

NS_ASSUME_NONNULL_END
