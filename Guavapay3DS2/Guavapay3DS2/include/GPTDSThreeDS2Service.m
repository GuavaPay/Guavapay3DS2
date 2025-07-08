//
//  GPTDSThreeDS2Service.m
//  Guavapay3DS2
//

#import "GPTDSThreeDS2Service.h"

#include <stdatomic.h>

#import "GPTDSAlreadyInitializedException.h"
#import "GPTDSConfigParameters.h"
#import "GPTDSDebuggerChecker.h"
#import "GPTDSDeviceInformationManager.h"
#import "GPTDSDirectoryServerCertificate.h"
#import "GPTDSException+Internal.h"
#import "GPTDSInvalidInputException.h"
#import "GPTDSLocalizedString.h"
#import "GPTDSJailbreakChecker.h"
#import "GPTDSIntegrityChecker.h"
#import "GPTDSNotInitializedException.h"
#import "GPTDSOSVersionChecker.h"
#import "GPTDSSecTypeUtilities.h"
#import "GPTDSSimulatorChecker.h"
#import "GPTDSThreeDSProtocolVersion.h"
#import "GPTDSTransaction+Private.h"
#import "GPTDSWarning.h"

static const int kServiceNotInitialized = 0;
static const int kServiceInitialized = 1;

static NSString * const kInternalGuavapayTestingConfigParam = @"kInternalGuavapayTestingConfigParam";
static NSString * const kIgnoreDeviceInformationRestrictionsParam = @"kIgnoreDeviceInformationRestrictionsParam";
static NSString * const kUseULTestLOAParam = @"kUseULTestLOAParam";

@implementation GPTDSThreeDS2Service
{
    atomic_int _initialized;

    GPTDSDeviceInformation *_deviceInformation;
    GPTDSUICustomization *_uiSettings;
    GPTDSConfigParameters *_configuration;
    __weak id<GPTDSAnalyticsDelegate> _analyticsDelegate;
}

@synthesize warnings = _warnings;

- (void)initializeWithConfig:(GPTDSConfigParameters *)config
                      locale:(nullable NSLocale *)locale
                  uiSettings:(nullable GPTDSUICustomization *)uiSettings
           analyticsDelegate:(nonnull id<GPTDSAnalyticsDelegate>)analyticsDelegate {
    _analyticsDelegate = analyticsDelegate;
    [self initializeWithConfig:config locale:locale uiSettings:uiSettings];
}

- (void)initializeWithConfig:(GPTDSConfigParameters *)config
                      locale:(nullable NSLocale *)locale
                  uiSettings:(nullable GPTDSUICustomization *)uiSettings {
    if (config == nil) {
        @throw [GPTDSInvalidInputException exceptionWithMessage:[NSString stringWithFormat:@"%@ config parameter must be non-nil.", NSStringFromSelector(_cmd)]];
    }

    int notInitialized = kServiceNotInitialized; // Can't pass a const to atomic_compare_exchange_strong_explicit so copy here
    if (!atomic_compare_exchange_strong_explicit(&_initialized, &notInitialized, kServiceInitialized, memory_order_release, memory_order_relaxed)) {
        @throw [GPTDSAlreadyInitializedException exceptionWithMessage:[NSString stringWithFormat:@"GPTDSThreeDS2Service instance %p has already been initialized.", self]];
    }

    _configuration = config;
    _uiSettings = uiSettings ? [uiSettings copy] : [GPTDSUICustomization defaultSettings];
    
    NSMutableArray *warnings = [NSMutableArray array];
    if ([GPTDSJailbreakChecker isJailbroken]) {
        GPTDSWarning *jailbrokenWarning = [[GPTDSWarning alloc] initWithIdentifier:@"SW01" message:GPTDSLocalizedString(@"The device is jailbroken.", @"The text for warning when a device is jailbroken") severity:GPTDSWarningSeverityHigh];
        [warnings addObject:jailbrokenWarning];
    }

    if (![GPTDSIntegrityChecker SDKIntegrityIsValid]) {
        GPTDSWarning *integrityWarning = [[GPTDSWarning alloc] initWithIdentifier:@"SW02" message:GPTDSLocalizedString(@"The integrity of the SDK has been tampered.", @"The text for warning when the integrity of the SDK has been tampered with") severity:GPTDSWarningSeverityHigh];
        [warnings addObject:integrityWarning];
    }

    if ([GPTDSSimulatorChecker isRunningOnSimulator]) {
        GPTDSWarning *simulatorWarning = [[GPTDSWarning alloc] initWithIdentifier:@"SW03" message:GPTDSLocalizedString(@"An emulator is being used to run the App.", @"The text for warning when an emulator is being used to run the application.") severity:GPTDSWarningSeverityHigh];
        [warnings addObject:simulatorWarning];
    }

    if ([GPTDSDebuggerChecker processIsCurrentlyAttachedToDebugger]) {
        GPTDSWarning *debuggerWarning = [[GPTDSWarning alloc] initWithIdentifier:@"SW04" message:GPTDSLocalizedString(@"A debugger is attached to the App.", @"The text for warning when a debugger is currently attached to the process.") severity:GPTDSWarningSeverityMedium];
        [warnings addObject:debuggerWarning];
    }
    
    if (![GPTDSOSVersionChecker isSupportedOSVersion]) {
        GPTDSWarning *versionWarning = [[GPTDSWarning alloc] initWithIdentifier:@"SW05" message:GPTDSLocalizedString(@"The OS or the OS Version is not supported.", "The text for warning when the SDK is running on an unsupported OS or OS version.") severity:GPTDSWarningSeverityHigh];
        [warnings addObject:versionWarning];
    }
    
    _warnings = [warnings copy];

    _deviceInformation = [GPTDSDeviceInformationManager deviceInformationWithWarnings:_warnings
                                                                ignoringRestrictions:[[_configuration parameterValue:kIgnoreDeviceInformationRestrictionsParam] isEqualToString:@"Y"]];

}

- (GPTDSTransaction *)createTransactionForDirectoryServer:(NSString *)directoryServerID
                                     withProtocolVersion:(nullable NSString *)protocolVersion {
    if (_initialized != kServiceInitialized) {
        @throw [GPTDSNotInitializedException exceptionWithMessage:@"GPTDSThreeDS2Service instance %p has not been initialized before call to %@", self, NSStringFromSelector(_cmd)];
    }

    if (directoryServerID == nil) {
        @throw [GPTDSInvalidInputException exceptionWithMessage:@"%@ directoryServerID parameter must be non-nil.", NSStringFromSelector(_cmd)];
    }

    GPTDSDirectoryServer directoryServer = GPTDSDirectoryServerForID(directoryServerID);
    if (directoryServer == GPTDSDirectoryServerUnknown) {
        if ([[_configuration parameterValue:kInternalGuavapayTestingConfigParam] isEqualToString:@"Y"]) {
            directoryServer = GPTDSDirectoryServerULTestRSA;
        } else {
            @throw [GPTDSInvalidInputException exceptionWithMessage:@"%@ is an invalid directoryServerID value", directoryServerID];
        }
    }

    if (protocolVersion != nil && ![self _supportsProtocolVersion:protocolVersion]) {
        @throw [GPTDSInvalidInputException exceptionWithMessage:@"3DS2 Protocol Version %@ is not supported by this SDK", protocolVersion];
    }



    GPTDSTransaction *transaction = [[GPTDSTransaction alloc] initWithDeviceInformation:_deviceInformation
                                                                      directoryServer:directoryServer
                                                                      protocolVersion:(protocolVersion != nil) ? GPTDSThreeDSProtocolVersionForString(protocolVersion) : GPTDSThreeDSProtocolVersion2_2_0
                                                                      uiCustomization:_uiSettings
                                                                    analyticsDelegate:_analyticsDelegate];
    transaction.bypassTestModeVerification = [[_configuration parameterValue:kInternalGuavapayTestingConfigParam] isEqualToString:@"Y"];
    transaction.useULTestLOA = [[_configuration parameterValue:kUseULTestLOAParam] isEqualToString:@"Y"];
    return transaction;

}

- (nullable GPTDSTransaction *)createTransactionForDirectoryServer:(NSString *)directoryServerID
                                                      serverKeyID:(nullable NSString *)serverKeyID
                                                certificateString:(NSString *)certificateString
                                           rootCertificateStrings:(NSArray<NSString *> *)rootCertificateStrings
                                              withProtocolVersion:(nullable NSString *)protocolVersion {
    if (_initialized != kServiceInitialized) {
        @throw [GPTDSNotInitializedException exceptionWithMessage:@"GPTDSThreeDS2Service instance %p has not been initialized before call to %@", self, NSStringFromSelector(_cmd)];
    }

    if (protocolVersion != nil && ![self _supportsProtocolVersion:protocolVersion]) {
        @throw [GPTDSInvalidInputException exceptionWithMessage:@"3DS2 Protocol Version %@ is not supported by this SDK", protocolVersion];
    }

    GPTDSTransaction *transaction = nil;

    GPTDSDirectoryServerCertificate *certificate = [GPTDSDirectoryServerCertificate customCertificateWithString:certificateString];

    if (certificate != nil) {
        transaction = [[GPTDSTransaction alloc] initWithDeviceInformation:_deviceInformation
                                                       directoryServerID:directoryServerID
                                                             serverKeyID:serverKeyID
                                              directoryServerCertificate:certificate
                                                  rootCertificateStrings:rootCertificateStrings
                                                         protocolVersion:(protocolVersion != nil) ? GPTDSThreeDSProtocolVersionForString(protocolVersion) : GPTDSThreeDSProtocolVersion2_2_0
                                                         uiCustomization:_uiSettings
                                                       analyticsDelegate:_analyticsDelegate];
        transaction.bypassTestModeVerification = [_configuration parameterValue:kInternalGuavapayTestingConfigParam] != nil;
    }

    return transaction;
}

- (nullable NSArray<GPTDSWarning *> *)warnings {
    if (_initialized != kServiceInitialized) {
        @throw [GPTDSNotInitializedException exceptionWithMessage:@"GPTDSThreeDS2Service instance %p has not been initialized before call to %@", self, NSStringFromSelector(_cmd)];
    }
    
    return _warnings;
}

- (NSString *)sdkVersion {
    return [[GPTDSBundleLocator gptdsResourcesBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
}

#pragma mark - Internal

- (BOOL)_supportsProtocolVersion:(NSString *)protocolVersion {
    GPTDSThreeDSProtocolVersion version = GPTDSThreeDSProtocolVersionForString(protocolVersion);
    switch (version) {
        case GPTDSThreeDSProtocolVersion2_1_0:
            return YES;

        case GPTDSThreeDSProtocolVersion2_2_0:
            return YES;

        case GPTDSThreeDSProtocolVersionFallbackTest:
             // only support fallback test if we have the internal testing config param
            return [[_configuration parameterValue:kInternalGuavapayTestingConfigParam] isEqualToString:@"Y"];

        case GPTDSThreeDSProtocolVersionUnknown:
            return NO;
    }
}

@end
