//
//  GPTDSDeviceInformationManager.h
//  Guavapay3DS2
//

#import <Foundation/Foundation.h>

@class GPTDSDeviceInformation;
@class GPTDSWarning;

NS_ASSUME_NONNULL_BEGIN

@interface GPTDSDeviceInformationManager : NSObject

+ (GPTDSDeviceInformation *)deviceInformationWithWarnings:(NSArray<GPTDSWarning *> *)warnings
                                    ignoringRestrictions:(BOOL)ignoreRestrictions;

@end

NS_ASSUME_NONNULL_END
