//
//  GPTDSAuthenticationRequestParameters.h
//  Guavapay3DS2
//

#import <Foundation/Foundation.h>

#import "GPTDSJSONEncodable.h"

NS_ASSUME_NONNULL_BEGIN

@interface GPTDSAuthenticationRequestParameters : NSObject <GPTDSJSONEncodable>

/**
 Designated initializer for `GPTDSAuthenticationRequestParameters`.
 
 @param sdkTransactionIdentifier    The SDK Transaction Identifier, as created by `[GPTDSTransaction createTransaction]`
 @param deviceData                  Optional device data collected by the SDK.
 @param sdkEphemeralPublicKey       The SDK ephemeral public key.
 @param sdkAppIdentifier            The SDK app identifier.
 @param sdkReferenceNumber          The SDK reference number.
 @param messageVersion              The protocol version that is supported by the SDK and used for the transaction.
 
 @exception InvalidInputException   Thrown if an input parameter is invalid. @see InvalidInputException
 */
- (instancetype)initWithSDKTransactionIdentifier:(NSString *)sdkTransactionIdentifier
                                      deviceData:(nullable NSString *)deviceData
                           sdkEphemeralPublicKey:(NSString *)sdkEphemeralPublicKey
                                sdkAppIdentifier:(NSString *)sdkAppIdentifier
                              sdkReferenceNumber:(NSString *)sdkReferenceNumber
                                  messageVersion:(NSString *)messageVersion;

/**
 The encrypted device data as a JWE string.
 */
@property (nonatomic, readonly, nullable) NSString *deviceData;

/**
 The SDK Transaction Identifier.
 */
@property (nonatomic, readonly) NSString *sdkTransactionIdentifier;

/**
 The SDK App Identifier.
 */
@property (nonatomic, readonly) NSString *sdkAppIdentifier;

/**
 The SDK reference number.
 */
@property (nonatomic, readonly) NSString *sdkReferenceNumber;

/**
 The SDK ephemeral public key.
 */
@property (nonatomic, readonly) NSString *sdkEphemeralPublicKey;

/**
 The protocol version that is used for the transaction.
 */
@property (nonatomic, readonly) NSString *messageVersion;

@end

NS_ASSUME_NONNULL_END
