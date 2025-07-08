//
//  GPTDSThreeDS2Service.h
//  Guavapay3DS2
//

#import <Foundation/Foundation.h>

@class GPTDSConfigParameters;
@class GPTDSTransaction;
@class GPTDSUICustomization;
@class GPTDSWarning;
@protocol GPTDSAnalyticsDelegate;

NS_ASSUME_NONNULL_BEGIN

/**
 `GPTDSThreeDS2Service` is the main 3DS SDK interface and provides methods to process transactions.
 */
@interface GPTDSThreeDS2Service : NSObject

/**
 A list of warnings that may be populated once the SDK has been initialized.
 */
@property (nonatomic, readonly, nullable) NSArray<GPTDSWarning *> *warnings;

/**
 Returns the version of the Guavapay3DS2 SDK, e.g. @"1.0"
 */
- (NSString *)sdkVersion;

/**
 Initializes the 3DS SDK instance.

 This method should be called at the start of the payment stage of a transaction.
 **Note: Until the `GPTDSThreeDS2Service instance is initialized, it will be unusable.**

 - Performs security checks
 - Collects device information

 @param config Configuration information that will be used during initialization. @see GPTDSConfigParameters
 @param locale Optional override for the locale to use in UI. If `nil`, will default to the current system locale.
 @param uiSettings Optional custom UI settings.  If `nil`, will default to `[GPTDSUICustomization defaultSettings]`.
 This argument is copied; any further changes to the customization object have no effect.  @see GPTDSUICustomization

 @exception GPTDSInvalidInputException Will throw an `GPTDSInvalidInputException` if `config` is `nil` or any of `config`, `locale`, or `uiSettings` are invalid. @see GPTDSInvalidInputException
 @exception GPTDSAlreadyInitializedException Will throw an `GPTDSAlreadyInitializedException` if the 3DS SDK instance has already been initialized. @see GPTDSSDKAlreadyInitializedException
 @exception GPTDSRuntimeException Will throw an `GPTDSRuntimeException` if there is an internal error in the SDK. @see GPTDSRuntimeException
 */
- (void)initializeWithConfig:(GPTDSConfigParameters *)config
                      locale:(nullable NSLocale *)locale
                  uiSettings:(nullable GPTDSUICustomization *)uiSettings;

- (void)initializeWithConfig:(GPTDSConfigParameters *)config
                      locale:(nullable NSLocale *)locale
                  uiSettings:(nullable GPTDSUICustomization *)uiSettings
           analyticsDelegate:(nonnull id<GPTDSAnalyticsDelegate>)analyticsDelegate;

/**
 Creates and returns an instance of `GPTDSTransaction`.

 @param directoryServerID The Directory Server identifier returned in the authentication response
 @param protocolVersion 3DS protocol version according to which the transaction will be created. Uses the default value of 2.2.0 if nil

 @exception GPTDSNotInitializedException Will throw an `GPTDSNotInitializedException` if the the `GPTDSThreeDS2Service` instance hasn't been initialized with a call to `initializeWithConfig:locale:uiSettings:`. @see GPTDSNotInitializedException
 @exception GPTDSInvalidInputException Will throw an `GPTDSInvalidInputException` if `directoryServerID` is not recognized or if the `protocolVersion` is not supported by this version of the SDK. @see GPTDSInvalidInputException
 @exception GPTDSRuntimeException Will throw an `GPTDSRuntimeException` if there is an internal error in the SDK. @see GPTDSRuntimeException
 */
- (GPTDSTransaction *)createTransactionForDirectoryServer:(NSString *)directoryServerID
                                     withProtocolVersion:(nullable NSString *)protocolVersion;

/**
 Creates and returns an instance of `GPTDSTransaction` using a custom directory server certificate.
 Will return nil if unable to create a certificate from the provided params.

 @param directoryServerID The Directory Server identifier returned in the authentication response
 @param serverKeyID An additional authentication key used by some Directory Servers
 @param certificateString A Base64-encoded PEM or DER formatted certificate string containing the directory server's public key
 @param rootCertificateStrings An arry of base64-encoded PEM or DER formatted certificate strings containing the DS root certificate used for signature checks
 @param protocolVersion 3DS protocol version according to which the transaction will be created. Uses the default value of 2.2.0 if nil

 @exception GPTDSNotInitializedException Will throw an `GPTDSNotInitializedException` if the the `GPTDSThreeDS2Service` instance hasn't been initialized with a call to `initializeWithConfig:locale:uiSettings:`. @see GPTDSNotInitializedException
 @exception GPTDSInvalidInputException Will throw an `GPTDSInvalidInputException` if the `protocolVersion` is not supported by this version of the SDK. @see GPTDSInvalidInputException
 */
- (nullable GPTDSTransaction *)createTransactionForDirectoryServer:(NSString *)directoryServerID
                                                      serverKeyID:(nullable NSString *)serverKeyID
                                                certificateString:(NSString *)certificateString
                                           rootCertificateStrings:(NSArray<NSString *> *)rootCertificateStrings
                                              withProtocolVersion:(nullable NSString *)protocolVersion;

@end

NS_ASSUME_NONNULL_END
