//
//  GPTDSChallengeResponseObject.h
//  Guavapay3DS2
//

#import <Foundation/Foundation.h>
#import "GPTDSChallengeResponse.h"
#import "GPTDSJSONDecodable.h"

NS_ASSUME_NONNULL_BEGIN

/// An object used to represent a challenge response from the ACS.
@interface GPTDSChallengeResponseObject: NSObject <GPTDSChallengeResponse, GPTDSJSONDecodable>

- (instancetype)initWithThreeDSServerTransactionID:(NSString *)threeDSServerTransactionID
                                acsCounterACStoSDK:(NSString *)acsCounterACStoSDK
                                  acsTransactionID:(NSString *)acsTransactionID
                                           acsHTML:(NSString * _Nullable)acsHTML
                                    acsHTMLRefresh:(NSString * _Nullable)acsHTMLRefresh
                                         acsUIType:(GPTDSACSUIType)acsUIType
                      challengeCompletionIndicator:(BOOL)challengeCompletionIndicator
                               challengeInfoHeader:(NSString * _Nullable)challengeInfoHeader
                                challengeInfoLabel:(NSString * _Nullable)challengeInfoLabel
                                 challengeInfoText:(NSString * _Nullable)challengeInfoText
                       challengeAdditionalInfoText:(NSString * _Nullable)challengeAdditionalInfoText
                    showChallengeInfoTextIndicator:(BOOL)showChallengeInfoTextIndicator
                               challengeSelectInfo:(NSArray<id<GPTDSChallengeResponseSelectionInfo>> * _Nullable)challengeSelectInfo
                                   expandInfoLabel:(NSString * _Nullable)expandInfoLabel
                                    expandInfoText:(NSString * _Nullable)expandInfoText
                                       issuerImage:(id<GPTDSChallengeResponseImage> _Nullable)issuerImage
                                 messageExtensions:(NSArray<id<GPTDSChallengeResponseMessageExtension>> * _Nullable)messageExtensions
                                    messageVersion:(NSString *)messageVersion
                                         oobAppURL:(NSURL * _Nullable)oobAppURL
                                       oobAppLabel:(NSString * _Nullable)oobAppLabel
                                  oobContinueLabel:(NSString * _Nullable)oobContinueLabel
                                paymentSystemImage:(id<GPTDSChallengeResponseImage> _Nullable)paymentSystemImage
                            resendInformationLabel:(NSString * _Nullable)resendInformationLabel
                                  sdkTransactionID:(NSString *)sdkTransactionID
                         submitAuthenticationLabel:(NSString * _Nullable)submitAuthenticationLabel
                              whitelistingInfoText:(NSString * _Nullable)whitelistingInfoText
                                      whyInfoLabel:(NSString * _Nullable)whyInfoLabel
                                       whyInfoText:(NSString * _Nullable)whyInfoText
                                 transactionStatus:(NSString * _Nullable)transactionStatus;
@end

NS_ASSUME_NONNULL_END
