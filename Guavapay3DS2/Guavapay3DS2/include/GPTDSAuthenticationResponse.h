//
//  GPTDSAuthenticationResponse.h
//  Guavapay3DS2
//

#import <Foundation/Foundation.h>

#import "GPTDSJSONDecodable.h"

NS_ASSUME_NONNULL_BEGIN

/**
 The `GPTDSACSStatusType` enum defines the status of a transaction, as detailed in
 3DS2 Spec Seq 3.33:
 */
typedef NS_ENUM(NSInteger, GPTDSACSStatusType) {
    /// The status is unknown or invalid
    GPTDSACSStatusTypeUnknown = 0,

    /// Authenticated
    GPTDSACSStatusTypeAuthenticated = 1,
    
    /// Requires a Cardholder challenge to complete authentication
    GPTDSACSStatusTypeChallengeRequired = 2,
    
    /// Requires a Cardholder challenge using Decoupled Authentication
    GPTDSACSStatusTypeDecoupledAuthentication = 3,
    
    /// Not authenticated
    GPTDSACSStatusTypeNotAuthenticated = 4,
    
    /// Not authenticated, but a proof of authentication attempt (Authentication Value)
    /// was generated
    GPTDSACSStatusTypeProofGenerated = 5,
    
    /// Not authenticated, as authentication could not be performed due to technical or
    /// other issue
    GPTDSACSStatusTypeError = 6,
    
    /// Not authenticated because the Issuer is rejecting authentication and requesting
    /// that authorisation not be attempted
    GPTDSACSStatusTypeRejected = 7,
    
    /// Authentication not requested by the 3DS Server for data sent for informational
    /// purposes only
    GPTDSACSStatusTypeInformationalOnly = 8,
};

/**
 A native protocol representing the response sent by the 3DS Server.
 Only parameters relevant to performing 3DS2 authentication in the mobile SDK are exposed.
 */
@protocol GPTDSAuthenticationResponse <NSObject>

/// Universally unique transaction identifier assigned by the 3DS Server to identify a single transaction.
@property (nonatomic, readonly) NSString *threeDSServerTransactionID;

/// Transaction status
@property (nonatomic, readonly) GPTDSACSStatusType status;

/// Indication of whether a challenge is required.
@property (nonatomic, readonly, getter=isChallengeRequired) BOOL challengeRequired;

/// Indicates whether the ACS confirms utilisation of Decoupled Authentication and agrees to utilise Decoupled Authentication to authenticate the Cardholder.
@property (nonatomic, readonly) BOOL willUseDecoupledAuthentication;

/**
 DS assigned ACS identifier.
 Each DS can provide a unique ID to each ACS on an individual basis.
 */
@property (nonatomic, readonly, nullable) NSString *acsOperatorID;

/// Unique identifier assigned by the EMVCo Secretariat upon Testing and Approval.
@property (nonatomic, readonly, nullable) NSString *acsReferenceNumber;

/// Contains the JWS object (represented as a string) created by the ACS for the ARes message.
@property (nonatomic, readonly, nullable) NSString *acsSignedContent;

/// Universally Unique transaction identifier assigned by the ACS to identify a single transaction.
@property (nonatomic, readonly) NSString *acsTransactionID;

/// Fully qualified URL of the ACS to be used for the challenge.
@property (nonatomic, readonly, nullable) NSURL *acsURL;

/**
 Text provided by the ACS/Issuer to Cardholder during a Frictionless or Decoupled transaction. The Issuer can provide information to Cardholder.
 For example, “Additional authentication is needed for this transaction, please contact (Issuer Name) at xxx-xxx-xxxx.”
 */
@property (nonatomic, readonly, nullable) NSString *cardholderInfo;

/// EMVCo-assigned unique identifier to track approved DS.
@property (nonatomic, readonly, nullable) NSString *directoryServerReferenceNumber;

/// Universally unique transaction identifier assigned by the DS to identify a single transaction.
@property (nonatomic, readonly, nullable) NSString *directoryServerTransactionID;

/**
 Protocol version identifier This shall be the Protocol Version Number of the specification utilised by the system creating this message.
 The Message Version Number is set by the 3DS Server which originates the protocol with the AReq message.
 The Message Version Number does not change during a 3DS transaction.
 */
@property (nonatomic, readonly) NSString *protocolVersion;

/// Universally unique transaction identifier assigned by the 3DS SDK to identify a single transaction.
@property (nonatomic, readonly) NSString *sdkTransactionID;

@end

/// A utility to parse an GPTDSAuthenticationResponse from JSON
id<GPTDSAuthenticationResponse> _Nullable GPTDSAuthenticationResponseFromJSON(NSDictionary *json);

NS_ASSUME_NONNULL_END
