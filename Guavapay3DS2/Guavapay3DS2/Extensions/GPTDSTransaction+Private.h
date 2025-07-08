//
//  GPTDSTransaction+Private.h
//  Guavapay3DS2
//

#import "GPTDSTransaction.h"

@class GPTDSDeviceInformation;
@class GPTDSDirectoryServerCertificate;
@protocol GPTDSAnalyticsDelegate;

#import "GPTDSDirectoryServer.h"
#import "GPTDSThreeDSProtocolVersion+Private.h"
#import "GPTDSUICustomization.h"

NS_ASSUME_NONNULL_BEGIN

@interface GPTDSTransaction ()

- (instancetype)initWithDeviceInformation:(GPTDSDeviceInformation *)deviceInformation
                          directoryServer:(GPTDSDirectoryServer)directoryServer
                          protocolVersion:(GPTDSThreeDSProtocolVersion)protocolVersion
                          uiCustomization:(GPTDSUICustomization *)uiCustomization
                        analyticsDelegate:(nullable id<GPTDSAnalyticsDelegate>)analyticsDelegate;

- (instancetype)initWithDeviceInformation:(GPTDSDeviceInformation *)deviceInformation
                        directoryServerID:(NSString *)directoryServerID
                              serverKeyID:(nullable NSString *)serverKeyID
               directoryServerCertificate:(GPTDSDirectoryServerCertificate *)directoryServerCertificate
                   rootCertificateStrings:(NSArray<NSString *> *)rootCertificateStrings
                          protocolVersion:(GPTDSThreeDSProtocolVersion)protocolVersion
                          uiCustomization:(GPTDSUICustomization *)uiCustomization
                        analyticsDelegate:(nullable id<GPTDSAnalyticsDelegate>)analyticsDelegate;

@property (nonatomic, strong) NSTimer *timeoutTimer;
@property (nonatomic) BOOL bypassTestModeVerification; // Should be used during internal testing ONLY
@property (nonatomic) BOOL useULTestLOA; // Should only be used when running tests with the UL reference app

@end

NS_ASSUME_NONNULL_END
