//
//  GPTDSDeviceInformationManager.m
//  Guavapay3DS2
//

#import "GPTDSDeviceInformationManager.h"

#import "GPTDSDeviceInformation.h"
#import "GPTDSDeviceInformationParameter.h"
#import "GPTDSWarning.h"

NS_ASSUME_NONNULL_BEGIN

// TC_SDK_10089_001, Req 2 & 5
static const NSString * const k3DSDataVersion = @"1.7";

static const NSString * const kDataVersionKey = @"DV";
static const NSString * const kDeviceDataKey = @"DD";
static const NSString * const kDeviceParameterNotAvailableKey = @"DPNA";
static const NSString * const kDeviceWarningsKey = @"SW";

@implementation GPTDSDeviceInformationManager

+ (GPTDSDeviceInformation *)deviceInformationWithWarnings:(NSArray<GPTDSWarning *> *)warnings
                                    ignoringRestrictions:(BOOL)ignoreRestrictions {
    NSMutableDictionary *deviceInformation = [NSMutableDictionary dictionaryWithObject:k3DSDataVersion forKey:kDataVersionKey];

    for (GPTDSDeviceInformationParameter *parameter in [GPTDSDeviceInformationParameter allParameters]) {

        [parameter collectIgnoringRestrictions:ignoreRestrictions withHandler:^(BOOL collected, NSString * _Nonnull identifier, id _Nonnull value) {
            if (collected) {
                NSMutableDictionary *deviceData = deviceInformation[kDeviceDataKey];
                if (deviceData == nil) {
                    deviceData = [NSMutableDictionary dictionary];
                    deviceInformation[kDeviceDataKey] = deviceData;
                }
                deviceData[identifier] = value;
            } else {
                NSMutableDictionary *notAvailableData = deviceInformation[kDeviceParameterNotAvailableKey];
                if (notAvailableData == nil) {
                    notAvailableData = [NSMutableDictionary dictionary];
                    deviceInformation[kDeviceParameterNotAvailableKey] = notAvailableData;
                }
                notAvailableData[identifier] = value;
            }
        }];
    }

    NSMutableArray<NSString *> *warningIDs = [NSMutableArray arrayWithCapacity:warnings.count];
    for (GPTDSWarning *warning in warnings) {
        [warningIDs addObject:warning.identifier];
    }
    if (warningIDs.count > 0) {
        deviceInformation[kDeviceWarningsKey] = [warningIDs copy];
    }

    return [[GPTDSDeviceInformation alloc] initWithDictionary:deviceInformation];
}

@end

NS_ASSUME_NONNULL_END
