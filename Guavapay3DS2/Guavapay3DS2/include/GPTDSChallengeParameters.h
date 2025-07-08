//
//  GPTDSChallengeParameters.h
//  Guavapay3DS2
//

#import <Foundation/Foundation.h>

@protocol GPTDSAuthenticationResponse;

NS_ASSUME_NONNULL_BEGIN

/**
 `GPTDSChallengeParameters` contains information from the 3DS Server's
 authentication response that are used by the 3DS2 SDK to initiate
 the challenge flow.
 */
@interface GPTDSChallengeParameters : NSObject

/**
 Convenience intiializer to create an instace of `GPTDSChallengeParameters` from an
 `GPTDSAuthenticationResponse`
 */
- (instancetype)initWithAuthenticationResponse:(id<GPTDSAuthenticationResponse>)authResponse;

/**
 Initialize with a base64‐encoded Packed SDK string and requestorAppURL.
 */
- (nullable instancetype)initWithPackedSDKString:(NSString *)packedSDKString
                                 requestorAppURL:(NSString *)requestorAppURL;

/**
 Transaction identifier assigned by the 3DS Server to uniquely identify
 a transaction.
 */
@property (nonatomic, copy) NSString *threeDSServerTransactionID;

/**
 Transaction identifier assigned by the Access Control Server (ACS)
 to uniquely identify a transaction.
 */
@property (nonatomic, copy) NSString *acsTransactionID;

/**
 The reference number of the relevant Access Control Server.
 */
@property (nonatomic, copy) NSString *acsReferenceNumber;

/**
 The encrypted message sent by the Access Control Server
 containing the ACS URL, epthemeral public key, and the
 3DS2 SDK ephemeral public key.
 */
@property (nonatomic, copy) NSString *acsSignedContent;

/**
 The URL for the application that is requesting 3DS2 verification.
 This property can be optionally set and will be included with the
 messages sent to the Directory Server during the challenge flow.
 */
@property (nonatomic, copy, nullable) NSString *threeDSRequestorAppURL;

@end

NS_ASSUME_NONNULL_END
