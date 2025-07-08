//
//  GPTDSTransaction.m
//  Guavapay3DS2
//

#import "GPTDSTransaction.h"
#import "GPTDSTransaction+Private.h"

#import "GPTDSBundleLocator.h"
#import "NSDictionary+DecodingHelpers.h"
#import "NSError+Guavapay3DS2.h"
#import "NSString+JWEHelpers.h"
#import "GPTDSACSNetworkingManager.h"
#import "GPTDSAuthenticationRequestParameters.h"
#import "GPTDSChallengeRequestParameters.h"
#import "GPTDSCompletionEvent.h"
#import "GPTDSChallengeParameters.h"
#import "GPTDSChallengeResponseObject.h"
#import "GPTDSChallengeResponseViewController.h"
#import "GPTDSChallengeStatusReceiver.h"
#import "GPTDSDeviceInformation.h"
#import "GPTDSEllipticCurvePoint.h"
#import "GPTDSEphemeralKeyPair.h"
#import "GPTDSErrorMessage+Internal.h"
#import "GPTDSException+Internal.h"
#import "GPTDSInvalidInputException.h"
#import "GPTDSJSONWebEncryption.h"
#import "GPTDSJSONWebSignature.h"
#import "GPTDSProgressViewController.h"
#import "GPTDSProtocolErrorEvent.h"
#import "GPTDSRuntimeErrorEvent.h"
#import "GPTDSRuntimeException.h"
#import "GPTDSSecTypeUtilities.h"
#import "GPTDSGuavapay3DS2Error.h"
#import "GPTDSDeviceInformationParameter.h"
#import "GPTDSAnalyticsDelegate.h"
#import "GPTDSDirectoryServerCertificate.h"

static const NSTimeInterval kMinimumTimeout = 5 * 60;
static NSString * const kGuavapayLOA = @"3DS_LOA_SDK_UTSB_020100_00011";
static NSString * const kULTestLOA = @"3DS_LOA_SDK_PPFU_020100_00007";
static NSString * const kOobBridgingId = @"A000000802-004";
static NSString * const kMessageVersionForManualOobBridging = @"2.2.0";
static BOOL const kEnableManualOobBridging = YES;

NS_ASSUME_NONNULL_BEGIN

@interface GPTDSTransaction() <GPTDSChallengeResponseViewControllerDelegate>

@property (nonatomic, weak) id<GPTDSChallengeStatusReceiver> challengeStatusReceiver;
@property (nonatomic, strong, nullable) GPTDSChallengeResponseViewController *challengeResponseViewController;
/// Stores the most recent parameters used to make a CReq
@property (nonatomic, nullable) GPTDSChallengeRequestParameters *challengeRequestParameters;
/// YES if `close` was called or the challenge flow finished.
@property (nonatomic, getter=isCompleted) BOOL completed;
@end

@implementation GPTDSTransaction
{
    GPTDSDeviceInformation *_deviceInformation;
    GPTDSDirectoryServer _directoryServer;
    GPTDSEphemeralKeyPair *_ephemeralKeyPair;
    GPTDSThreeDSProtocolVersion _protocolVersion;
    NSString *_identifier;

    GPTDSDirectoryServerCertificate *_customDirectoryServerCertificate;
    NSArray<NSString *> *_rootCertificateStrings;
    NSString *_customDirectoryServerID;
    NSString *_serverKeyID;

    GPTDSACSNetworkingManager *_networkingManager;

    GPTDSUICustomization *_uiCustomization;

    __weak id<GPTDSAnalyticsDelegate> _analyticsDelegate;
}

- (instancetype)initWithDeviceInformation:(GPTDSDeviceInformation *)deviceInformation
                          directoryServer:(GPTDSDirectoryServer)directoryServer
                          protocolVersion:(GPTDSThreeDSProtocolVersion)protocolVersion
                          uiCustomization:(nonnull GPTDSUICustomization *)uiCustomization
                        analyticsDelegate:(nullable id<GPTDSAnalyticsDelegate>)analyticsDelegate {
    self = [super init];
    if (self) {
        _deviceInformation = deviceInformation;
        _directoryServer = directoryServer;
        _protocolVersion = protocolVersion;
        _completed = NO;
        _identifier = [NSUUID UUID].UUIDString.lowercaseString;
        _ephemeralKeyPair = [GPTDSEphemeralKeyPair ephemeralKeyPair];
        _uiCustomization = uiCustomization;
        if (_ephemeralKeyPair == nil) {
            return nil;
        }
    }

    return self;
}

- (instancetype)initWithDeviceInformation:(GPTDSDeviceInformation *)deviceInformation
                        directoryServerID:(NSString *)directoryServerID
                              serverKeyID:(nullable NSString *)serverKeyID
               directoryServerCertificate:(GPTDSDirectoryServerCertificate *)directoryServerCertificate
                   rootCertificateStrings:(NSArray<NSString *> *)rootCertificateStrings
                          protocolVersion:(GPTDSThreeDSProtocolVersion)protocolVersion
                          uiCustomization:(GPTDSUICustomization *)uiCustomization
                        analyticsDelegate:(nullable id<GPTDSAnalyticsDelegate>)analyticsDelegate {
    self = [super init];
    if (self) {
        _deviceInformation = deviceInformation;
        _directoryServer = GPTDSDirectoryServerCustom;
        _customDirectoryServerCertificate = directoryServerCertificate;
        _rootCertificateStrings = rootCertificateStrings;
        _customDirectoryServerID = [directoryServerID copy];
        _serverKeyID = [serverKeyID copy];
        _protocolVersion = protocolVersion;
        _completed = NO;
        _identifier = [NSUUID UUID].UUIDString.lowercaseString;
        _ephemeralKeyPair = [GPTDSEphemeralKeyPair ephemeralKeyPair];
        _uiCustomization = uiCustomization;
        if (_ephemeralKeyPair == nil) {
            return nil;
        }
    }

    return self;
}

- (NSString *)sdkVersion {
    return [[GPTDSBundleLocator gptdsResourcesBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
}

- (NSString *)presentedChallengeUIType {
    return [self UIType:self.challengeResponseViewController.response.acsUIType];
}

- (NSString *)UIType:(GPTDSACSUIType)uiType {
    switch (uiType) {

        case GPTDSACSUITypeNone:
            return @"none";

        case GPTDSACSUITypeText:
            return @"text";

        case GPTDSACSUITypeSingleSelect:
            return @"single_select";

        case GPTDSACSUITypeMultiSelect:
            return @"multi_select";

        case GPTDSACSUITypeOOB:
            return @"oob";

        case GPTDSACSUITypeHTML:
            return @"html";
    }
}

- (GPTDSAuthenticationRequestParameters *)createAuthenticationRequestParameters {
    NSError *error = nil;
    NSString *encryptedDeviceData = nil;

    NSMutableDictionary *dictionary = [_deviceInformation.dictionaryValue mutableCopy];
    dictionary[@"DD"][@"C018"] = _identifier;

    NSString *SDKReferenceNumber = self.useULTestLOA ? kULTestLOA : kGuavapayLOA;
    dictionary[@"DD"][@"C016"] = SDKReferenceNumber;

    if (_directoryServer == GPTDSDirectoryServerCustom) {
        encryptedDeviceData = [GPTDSJSONWebEncryption encryptJSON:dictionary
                                                  withCertificate:_customDirectoryServerCertificate
                                                directoryServerID:_customDirectoryServerID
                                                      serverKeyID:_serverKeyID
                                                            error:&error];
    } else {
        encryptedDeviceData = [GPTDSJSONWebEncryption encryptJSON:dictionary
                                               forDirectoryServer:_directoryServer
                                                            error:&error];
    }
    if (encryptedDeviceData == nil) {
        @throw [GPTDSRuntimeException exceptionWithMessage:@"Error encrypting device information %@", error];
    }

    return [[GPTDSAuthenticationRequestParameters alloc] initWithSDKTransactionIdentifier:_identifier
                                                                               deviceData:encryptedDeviceData
                                                                    sdkEphemeralPublicKey:_ephemeralKeyPair.publicKeyJWK
                                                                         sdkAppIdentifier:[GPTDSDeviceInformationParameter sdkAppIdentifier]
                                                                       sdkReferenceNumber:SDKReferenceNumber
                                                                           messageVersion:[self _messageVersion]];
}

- (UIViewController *)createProgressViewControllerWithDidCancel:(void (^)(void))didCancel {
    return [[GPTDSProgressViewController alloc] initWithDirectoryServer:[self _directoryServerForUI]
                                                        uiCustomization:_uiCustomization
                                                      analyticsDelegate:_analyticsDelegate
                                                              didCancel:didCancel];
}

- (void)doChallengeWithViewController:(UIViewController *)presentingViewController
                  challengeParameters:(GPTDSChallengeParameters *)challengeParameters
                    messageExtensions:(nullable NSArray<NSDictionary *> *)messageExtensions
              challengeStatusReceiver:(id)challengeStatusReceiver
                          oobDelegate:(nullable id<GPTDSChallengeResponseViewControllerOOBDelegate>) oobDelegate
                              timeout:(NSTimeInterval)timeout {

    [self doChallengeWithChallengeParameters:challengeParameters
                           messageExtensions:messageExtensions
                     challengeStatusReceiver:challengeStatusReceiver
                                 oobDelegate:oobDelegate
                                     timeout:timeout
                           presentationBlock:^(UIViewController * _Nonnull challengeVC, void (^completion)(void)) {
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:challengeVC];
        navigationController.modalPresentationStyle = UIModalPresentationFullScreen;

        [presentingViewController presentViewController:navigationController animated:YES completion:^{
            completion();
        }];
    }];
}

- (void)doChallengeWithChallengeParameters:(GPTDSChallengeParameters *)challengeParameters
                         messageExtensions:(nullable NSArray<NSDictionary *> *)messageExtensions
                   challengeStatusReceiver:(id)challengeStatusReceiver
                               oobDelegate:(nullable id<GPTDSChallengeResponseViewControllerOOBDelegate>) oobDelegate
                                   timeout:(NSTimeInterval)timeout
                         presentationBlock:(void (^)(UIViewController *, void(^)(void)))presentationBlock {
    if (self.isCompleted) {
        @throw [GPTDSRuntimeException exceptionWithMessage:@"The transaction has already completed."];
    } else if (timeout < kMinimumTimeout) {
        @throw [GPTDSInvalidInputException exceptionWithMessage:@"Timeout value of %lf seconds is less than 5 minutes", timeout];
    }
    self.challengeStatusReceiver = challengeStatusReceiver;
    self.timeoutTimer = [NSTimer scheduledTimerWithTimeInterval:(timeout) target:self selector:@selector(_didTimeout) userInfo:nil repeats:NO];

    self.challengeRequestParameters = [[GPTDSChallengeRequestParameters alloc] initWithChallengeParameters:challengeParameters
                                                                                     transactionIdentifier:_identifier
                                                                                            messageVersion:[self _messageVersion]];

    NSMutableArray<NSDictionary *> *extensions = messageExtensions ? [messageExtensions mutableCopy] : [NSMutableArray array];

    // Check if `threeDSRequestorAppURL` is not empty
    BOOL threeDSRequestorAppURLNotEmpty = self.challengeRequestParameters.threeDSRequestorAppURL
    && ![self.challengeRequestParameters.threeDSRequestorAppURL isEqual: @""];

    // Currently OOB is available for MasterCard only
    BOOL oobAvailableForDirectoryServer = self->_directoryServer == GPTDSDirectoryServerMastercard;

    if (threeDSRequestorAppURLNotEmpty && oobAvailableForDirectoryServer && kEnableManualOobBridging) {
        // Ensure the OOB Bridging extension is present for version 2.2.0
        // to indicate support of this challenge type.
        if ([self.challengeRequestParameters.messageVersion isEqual: kMessageVersionForManualOobBridging]) {
            NSDictionary *bridgingExtension = [self _oobInitialMessageExtension];

            BOOL hasOobBridging = NO;
            for (NSDictionary *ext in extensions) {
                if ([ext[@"id"] isEqualToString: kOobBridgingId]) {
                    hasOobBridging = YES;
                    break;
                }
            }
            if (!hasOobBridging) {
                [extensions addObject:bridgingExtension];
            }
        }

        self.challengeRequestParameters.messageExtension = extensions;
    } else {
        self.challengeRequestParameters.messageExtension = nil;
    }

    GPTDSJSONWebSignature *jws = [[GPTDSJSONWebSignature alloc] initWithString:challengeParameters.acsSignedContent allowNilKey:self.bypassTestModeVerification];
    BOOL validJWS = jws != nil;
    if (validJWS && !self.bypassTestModeVerification) {
        if (_customDirectoryServerCertificate != nil) {
            if (_rootCertificateStrings.count == 0) {
                validJWS = NO;
            } else {
                validJWS = [GPTDSJSONWebEncryption verifyJSONWebSignature:jws withCertificate:_customDirectoryServerCertificate rootCertificates:_rootCertificateStrings];
            }
        } else {
            validJWS = [GPTDSJSONWebEncryption verifyJSONWebSignature:jws forDirectoryServer:_directoryServer];
        }
    }
    if (!validJWS) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [challengeStatusReceiver transaction:self
                   didErrorWithRuntimeErrorEvent:[[GPTDSRuntimeErrorEvent alloc] initWithErrorCode:kGPTDSRuntimeErrorCodeEncryptionError errorMessage:@"Error verifying JWS response."]];
            [self _cleanUp];
        });
        return;
    }

    NSError *jsonError = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jws.payload options:0 error:&jsonError];
    NSDictionary *acsEphmeralKeyJWK = [json _gptds_dictionaryForKey:@"acsEphemPubKey" required:NO error:NULL];
    GPTDSEllipticCurvePoint *acsEphemeralKey = [[GPTDSEllipticCurvePoint alloc] initWithJWK:acsEphmeralKeyJWK];
    NSString *acsURLString = [json _gptds_stringForKey:@"acsURL" required:NO error:NULL];
    NSURL *acsURL = [NSURL URLWithString:acsURLString ?: @""];
    if (acsEphemeralKey  == nil || acsURL == nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [challengeStatusReceiver transaction:self
                   didErrorWithRuntimeErrorEvent:[[GPTDSRuntimeErrorEvent alloc] initWithErrorCode:kGPTDSRuntimeErrorCodeParsingError errorMessage:[NSString stringWithFormat:@"Unable to create key or url from ACS json: %@\n\n jsonError: %@", json, jsonError]]];
            [self _cleanUp];
        });
        return;
    }

    NSData *ecdhSecret = [_ephemeralKeyPair createSharedSecretWithEllipticCurveKey:acsEphemeralKey];
    if (ecdhSecret == nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [challengeStatusReceiver transaction:self
                   didErrorWithRuntimeErrorEvent:[[GPTDSRuntimeErrorEvent alloc] initWithErrorCode:kGPTDSRuntimeErrorCodeEncryptionError errorMessage:@"Error during Diffie-Helman key exchange"]];
            [self _cleanUp];
        });
        return;
    }

    NSData *contentEncryptionKeySDKtoACS = GPTDSCreateConcatKDFWithSHA256(ecdhSecret, 32, self.useULTestLOA ? kULTestLOA : kGuavapayLOA);
    // These two keys are intentionally identical
    // ref. Protocol and Core Functions Specification Version 2.2.0 Section 6.2.3.2 & 6.2.3.3
    // "In this version of the specification [contentEncryptionKeyACStoSDK] and [contentEncryptionKeySDKtoACS]
    // are extracted with the same value."
    NSData *contentEncryptionKeyACStoSDK = [contentEncryptionKeySDKtoACS copy];

    _networkingManager = [[GPTDSACSNetworkingManager alloc] initWithURL:acsURL
                                                sdkContentEncryptionKey:contentEncryptionKeySDKtoACS
                                                acsContentEncryptionKey:contentEncryptionKeyACStoSDK
                                               acsTransactionIdentifier:self.challengeRequestParameters.acsTransactionIdentifier];
    // Start the Challenge flow
    GPTDSImageLoader *imageLoader = [[GPTDSImageLoader alloc] initWithURLSession:NSURLSession.sharedSession];
    self.challengeResponseViewController = [[GPTDSChallengeResponseViewController alloc] initWithUICustomization:_uiCustomization
                                                                                                     imageLoader:imageLoader
                                                                                                 directoryServer:[self _directoryServerForUI]
                                                                                               analyticsDelegate:_analyticsDelegate];
    self.challengeResponseViewController.delegate = self;
    self.challengeResponseViewController.oobDelegate = oobDelegate;

    presentationBlock(self.challengeResponseViewController, ^{ [self _makeChallengeRequest:self.challengeRequestParameters didCancel:NO]; });
}

- (void)setCertificatesWithCustomCertificate:(NSString *)customCertificate
                            rootCertificates:(NSArray<NSString *> *)rootCertificateStrings {
    GPTDSDirectoryServerCertificate *certificate = [GPTDSDirectoryServerCertificate customCertificateWithString:customCertificate];

    _customDirectoryServerCertificate = certificate;
    _rootCertificateStrings = rootCertificateStrings;
}

- (void)close {
    [self _cleanUp];
}

- (void)cancelChallengeFlow {
    [self challengeResponseViewControllerDidCancel:self.challengeResponseViewController];
}

- (void)dealloc {
    [self _cleanUp];
}

#pragma mark - Private

// When we get a directory certificate and ID from the server, we mark it as Custom for encryption,
// but may have a correct mapping to a DS logo for the UI
- (GPTDSDirectoryServer)_directoryServerForUI {
    return (_customDirectoryServerID != nil) ? GPTDSDirectoryServerForID(_customDirectoryServerID) : _directoryServer;
}

- (void)_makeChallengeRequest:(GPTDSChallengeRequestParameters *)challengeRequestParameters didCancel:(BOOL)didCancel {
    [self.challengeResponseViewController setLoading];
    __weak GPTDSTransaction *weakSelf = self;
    [_networkingManager submitChallengeRequest:self.challengeRequestParameters
                                withCompletion:^(id<GPTDSChallengeResponse> _Nullable response, NSError * _Nullable error) {
        GPTDSTransaction *strongSelf = weakSelf;
        if (strongSelf == nil || strongSelf.isCompleted) {
            return;
        }
        // Parsing or network errors
        if (response == nil || error) {
            if (!error) {
                error = [NSError errorWithDomain:GPTDSGuavapay3DS2ErrorDomain code:GPTDSErrorCodeUnknownError userInfo:nil];
            }
            [strongSelf _handleError:error];
            return;
        }
        // Consistency errors (e.g. acsTransID changes)
        NSError *validationError;
        if (![strongSelf _validateChallengeResponse:response error:&validationError]) {
            [strongSelf _handleError:validationError];
            return;
        }
        [strongSelf _handleChallengeResponse:response didCancel:didCancel];
    }];
}

- (BOOL)_validateChallengeResponse:(id<GPTDSChallengeResponse>)challengeResponse error:(NSError **)outError {
    NSError *error;
    if (![challengeResponse.acsTransactionID isEqualToString:self.challengeRequestParameters.acsTransactionIdentifier] ||
        ![challengeResponse.threeDSServerTransactionID isEqualToString:self.challengeRequestParameters.threeDSServerTransactionIdentifier] ||
        ![challengeResponse.sdkTransactionID isEqualToString:self.challengeRequestParameters.sdkTransactionIdentifier]) {
        error = [NSError errorWithDomain:GPTDSGuavapay3DS2ErrorDomain code:GPTDSErrorMessageErrorTransactionIDNotRecognized userInfo:nil];
    } else if (![challengeResponse.messageVersion isEqualToString:self.challengeRequestParameters.messageVersion]) {
        error = [NSError _gptds_invalidJSONFieldError:@"messageVersion"];
    } else if (!self.bypassTestModeVerification && ![challengeResponse.acsCounterACStoSDK isEqualToString:self.challengeRequestParameters.sdkCounterStoA]) {
        error = [NSError errorWithDomain:GPTDSGuavapay3DS2ErrorDomain code:GPTDSErrorCodeDecryptionVerification userInfo:nil];
    } else if (challengeResponse.acsUIType == GPTDSACSUITypeHTML && !challengeResponse.acsHTML) {
        error = [NSError errorWithDomain:GPTDSGuavapay3DS2ErrorDomain code:GPTDSErrorCodeDecryptionVerification userInfo:nil];
    }

    if (error && outError) {
        *outError = error;
    }
    return error == nil;
}

- (void) _handleError:(NSError *)error {
    // All the codes corresponding to errors that we treat as protocol errors (ie send to the ACS and report as an GPTDSProtocolErrorEvent)
    NSSet *protocolErrorCodes = [NSSet setWithArray:@[@(GPTDSErrorCodeUnknownMessageType),
                                                      @(GPTDSErrorCodeJSONFieldInvalid),
                                                      @(GPTDSErrorCodeJSONFieldMissing),
                                                      @(GPTDSErrorCodeReceivedErrorMessage),
                                                      @(GPTDSErrorMessageErrorTransactionIDNotRecognized),
                                                      @(GPTDSErrorCodeUnrecognizedCriticalMessageExtension),
                                                      @(GPTDSErrorCodeDecryptionVerification)]];
    if (error.domain == GPTDSGuavapay3DS2ErrorDomain) {
        NSString *sdkTransactionIdentifier = _identifier;
        NSString *threeDSServerTransID = self.challengeRequestParameters.threeDSServerTransactionIdentifier;
        NSString *acsTransactionIdentifier = self.challengeRequestParameters.acsTransactionIdentifier;
        NSString *messageVersion = [self _messageVersion];
        GPTDSErrorMessage *errorMessage;
        switch (error.code) {
            case GPTDSErrorCodeReceivedErrorMessage:
                errorMessage = error.userInfo[GPTDSGuavapay3DS2ErrorMessageErrorKey];
                break;
            case GPTDSErrorCodeUnknownMessageType:
                errorMessage = [GPTDSErrorMessage errorForInvalidMessageWithACSTransactionID:acsTransactionIdentifier messageVersion:messageVersion];
                break;
            case GPTDSErrorCodeJSONFieldInvalid:
                errorMessage = [GPTDSErrorMessage errorForJSONFieldInvalidWithACSTransactionID:acsTransactionIdentifier
                                                                          threeDSServerTransID:threeDSServerTransID
                                                                              sdkTransactionID:sdkTransactionIdentifier
                                                                                messageVersion:messageVersion
                                                                                         error:error];
                break;
            case GPTDSErrorCodeJSONFieldMissing:
                errorMessage = [GPTDSErrorMessage errorForJSONFieldMissingWithACSTransactionID:acsTransactionIdentifier messageVersion:messageVersion error:error];
                break;
            case GPTDSErrorCodeTimeout:
                errorMessage = [GPTDSErrorMessage errorForTimeoutWithACSTransactionID:acsTransactionIdentifier messageVersion:messageVersion];
                break;
            case GPTDSErrorMessageErrorTransactionIDNotRecognized:
                errorMessage = [GPTDSErrorMessage errorForUnrecognizedIDWithACSTransactionID:acsTransactionIdentifier messageVersion:messageVersion];
                break;
            case GPTDSErrorCodeUnrecognizedCriticalMessageExtension:
                errorMessage = [GPTDSErrorMessage errorForUnrecognizedCriticalMessageExtensionsWithACSTransactionID:acsTransactionIdentifier messageVersion:messageVersion error:error];
                break;
            case GPTDSErrorCodeDecryptionVerification:
                errorMessage = [GPTDSErrorMessage errorForDecryptionErrorWithACSTransactionID:acsTransactionIdentifier messageVersion:messageVersion];
                break;
            default:
                break;
        }

        // Send the ErrorMessage (unless we received one)
        if (error.code != GPTDSErrorCodeReceivedErrorMessage && errorMessage != nil) {
            [_networkingManager sendErrorMessage:errorMessage];
        }

        // If it's a protocol error, call back to the challengeStatusReceiver
        if ([protocolErrorCodes containsObject:@(error.code)] && errorMessage != nil) {
            GPTDSProtocolErrorEvent *protocolErrorEvent = [[GPTDSProtocolErrorEvent alloc] initWithSDKTransactionIdentifier:sdkTransactionIdentifier
                                                                                                               errorMessage:errorMessage];
            [self.challengeStatusReceiver transaction:self didErrorWithProtocolErrorEvent:protocolErrorEvent];
        }

    }

    if (error.domain != GPTDSGuavapay3DS2ErrorDomain || ![protocolErrorCodes containsObject:@(error.code)]) {
        // This error is not a protocol error, and therefore a runtime error.
        NSString *errorCode = [NSString stringWithFormat:@"%ld", (long)error.code];
        GPTDSRuntimeErrorEvent *runtimeErrorEvent = [[GPTDSRuntimeErrorEvent alloc] initWithErrorCode:errorCode errorMessage:error.localizedDescription];
        [self.challengeStatusReceiver transaction:self didErrorWithRuntimeErrorEvent:runtimeErrorEvent];
    }

    [self _dismissChallengeResponseViewController];
    [self _cleanUp];
}

- (void)_handleChallengeResponse:(id<GPTDSChallengeResponse>)challengeResponse didCancel:(BOOL)didCancel {

    if (challengeResponse.challengeCompletionIndicator) {
        // Final CRes
        // We need to pass didCancel to here because we can't distinguish between cancellation and auth failure from the CRes
        // (they both result in a transactionStatus of "N")
        if (didCancel) {
            // We already dismissed the view controller
            [self.challengeStatusReceiver transactionDidCancel:self];
            [self _cleanUp];
        } else {
            [self _dismissChallengeResponseViewController];
            GPTDSCompletionEvent *completionEvent = [[GPTDSCompletionEvent alloc] initWithSDKTransactionIdentifier:_identifier
                                                                                                 transactionStatus:challengeResponse.transactionStatus];
            [self.challengeStatusReceiver transaction:self didCompleteChallengeWithCompletionEvent:completionEvent];
            [self _cleanUp];
        }
    } else {
        [self.challengeResponseViewController setChallengeResponse:challengeResponse animated:YES];

        if ([self.challengeStatusReceiver respondsToSelector:@selector(transactionDidPresentChallengeScreen:)]) {
            [self.challengeStatusReceiver transactionDidPresentChallengeScreen:self];
        }
    }

    [_analyticsDelegate didReceiveChallengeResponseWithTransactionID:challengeResponse.threeDSServerTransactionID flow:[self UIType:challengeResponse.acsUIType]];
}

- (void)_cleanUp {
    [self.timeoutTimer invalidate];
    [self _dismissChallengeResponseViewController];
    self.completed = YES;
    self.challengeResponseViewController = nil;
    self.challengeStatusReceiver = nil;
    _networkingManager = nil;
}

- (void)_didTimeout {
    [self _dismissChallengeResponseViewController];
    [_networkingManager sendErrorMessage:[GPTDSErrorMessage errorForTimeoutWithACSTransactionID:self.challengeRequestParameters.acsTransactionIdentifier messageVersion:[self _messageVersion]]];
    [self.challengeStatusReceiver transactionDidTimeOut:self];
    [self _cleanUp];
}

- (void)_dismissChallengeResponseViewController {
    if ([self.challengeStatusReceiver respondsToSelector:@selector(dismissChallengeViewController:forTransaction:)]) {
        [self.challengeStatusReceiver dismissChallengeViewController:self.challengeResponseViewController forTransaction:self];
    } else {
        [self.challengeResponseViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark Helpers

- (nullable NSString *)_messageVersion {
    NSString *messageVersion = GPTDSThreeDSProtocolVersionStringValue(_protocolVersion);
    if (messageVersion == nil) {
        @throw [GPTDSRuntimeException exceptionWithMessage:@"Error determining message version."];
    }
    return messageVersion;
}

/// Convenience method to construct a CSV from the names of each GPTDSChallengeResponseSelectionInfo in the given array
- (NSString *)_csvForChallengeResponseSelectionInfo:(NSArray<id<GPTDSChallengeResponseSelectionInfo>> *)selectionInfoArray {
    NSMutableArray *selectionInfoNames = [NSMutableArray new];
    for (id<GPTDSChallengeResponseSelectionInfo> selectionInfo in selectionInfoArray) {
        [selectionInfoNames addObject:selectionInfo.name];
    }
    return [selectionInfoNames componentsJoinedByString:@","];
}

- (NSDictionary *)_oobInitialMessageExtension {
    NSDictionary *messageExtension = @{
        @"name": @"Bridging",
        @"id": kOobBridgingId,
        @"criticalityIndicator": @NO,
        @"version": @"1.0",
        @"data": @{
            @"challengeData": @{
                @"oobAppURLInd": @"01"
            }
        }
    };

    return messageExtension;
}

- (NSDictionary *)_oobContinueMessageExtension {
    NSMutableDictionary *messageExtension = [[self _oobInitialMessageExtension] mutableCopy];

    NSMutableDictionary *data = [messageExtension[@"data"] mutableCopy];
    NSMutableDictionary *challengeData = [data[@"challengeData"] mutableCopy];

    challengeData[@"oobContinue"] = @"02";
    data[@"challengeData"] = challengeData;
    messageExtension[@"data"] = data;

    return messageExtension;
}

#pragma mark - GPTDSChallengeResponseViewController

- (void)challengeResponseViewController:(nonnull GPTDSChallengeResponseViewController *)viewController didSubmitInput:(nonnull NSString *)userInput whitelistSelection:(nonnull id<GPTDSChallengeResponseSelectionInfo>)whitelistSelection {
    self.challengeRequestParameters = [self.challengeRequestParameters nextChallengeRequestParametersByIncrementCounter];
    self.challengeRequestParameters.challengeDataEntry = userInput;
    self.challengeRequestParameters.whitelistingDataEntry = whitelistSelection.name;
    [self _makeChallengeRequest:self.challengeRequestParameters didCancel:NO];
}

- (void)challengeResponseViewController:(nonnull GPTDSChallengeResponseViewController *)viewController didSubmitSelection:(nonnull NSArray<id<GPTDSChallengeResponseSelectionInfo>> *)selection whitelistSelection:(nonnull id<GPTDSChallengeResponseSelectionInfo>)whitelistSelection {
    self.challengeRequestParameters = [self.challengeRequestParameters nextChallengeRequestParametersByIncrementCounter];
    self.challengeRequestParameters.challengeDataEntry = [self _csvForChallengeResponseSelectionInfo:selection];
    self.challengeRequestParameters.whitelistingDataEntry = whitelistSelection.name;
    [self _makeChallengeRequest:self.challengeRequestParameters didCancel:NO];
}

- (void)challengeResponseViewControllerDidOOBContinue:(nonnull GPTDSChallengeResponseViewController *)viewController whitelistSelection:(nonnull id<GPTDSChallengeResponseSelectionInfo>)whitelistSelection {
    self.challengeRequestParameters = [self.challengeRequestParameters nextChallengeRequestParametersByIncrementCounter];
    self.challengeRequestParameters.oobContinue = @(YES);
    self.challengeRequestParameters.whitelistingDataEntry = whitelistSelection.name;

    // Check if `threeDSRequestorAppURL` is not empty
    BOOL threeDSRequestorAppURLNotEmpty = self.challengeRequestParameters.threeDSRequestorAppURL
        && ![self.challengeRequestParameters.threeDSRequestorAppURL isEqual: @""];

    // Currently OOB is available for MasterCard only
    BOOL oobAvailableForDirectoryServer = self->_directoryServer == GPTDSDirectoryServerMastercard;

    if (threeDSRequestorAppURLNotEmpty && oobAvailableForDirectoryServer && kEnableManualOobBridging) {
        // Adding OOB Continue messageExtension for message version `2.2.0`
        // to mark challenge flow of this type as completed.
        if ([self.challengeRequestParameters.messageVersion isEqual: kMessageVersionForManualOobBridging]) {
            NSDictionary *bridgingExtension = [self _oobContinueMessageExtension];

            if (self.challengeRequestParameters.messageExtension) {
                NSMutableArray *updatedExtensions = [self.challengeRequestParameters.messageExtension mutableCopy];
                [updatedExtensions addObject:bridgingExtension];
                self.challengeRequestParameters.messageExtension = updatedExtensions;
            } else {
                self.challengeRequestParameters.messageExtension = @[bridgingExtension];
            }
        }
    } else {
        self.challengeRequestParameters.messageExtension = nil;
    }

    [self _makeChallengeRequest:self.challengeRequestParameters didCancel:NO];
}

- (void)challengeResponseViewControllerDidCancel:(GPTDSChallengeResponseViewController *)viewController {
    self.challengeRequestParameters = [self.challengeRequestParameters nextChallengeRequestParametersByIncrementCounter];
    self.challengeRequestParameters.challengeCancel = @(GPTDSChallengeCancelTypeCardholderSelectedCancel);
    [self _dismissChallengeResponseViewController];
    [self _makeChallengeRequest:self.challengeRequestParameters didCancel:YES];
}

- (void)challengeResponseViewControllerDidRequestResend:(GPTDSChallengeResponseViewController *)viewController {
    self.challengeRequestParameters = [self.challengeRequestParameters nextChallengeRequestParametersByIncrementCounter];
    self.challengeRequestParameters.resendChallenge = @"Y";
    [self _makeChallengeRequest:self.challengeRequestParameters didCancel:NO];
}

- (void)challengeResponseViewController:(nonnull GPTDSChallengeResponseViewController *)viewController didSubmitHTMLForm:(nonnull NSString *)form {
    self.challengeRequestParameters = [self.challengeRequestParameters nextChallengeRequestParametersByIncrementCounter];
    self.challengeRequestParameters.challengeHTMLDataEntry = form;
    [self _makeChallengeRequest:self.challengeRequestParameters didCancel:NO];
}

@end

NS_ASSUME_NONNULL_END
