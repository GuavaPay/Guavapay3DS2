//
//  GPTDSDeviceInformationParameter.h
//  Guavapay3DS2
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GPTDSDeviceInformationParameter : NSObject

+ (NSArray<GPTDSDeviceInformationParameter *> *)allParameters;

/// Returns a UUID unique to the app version
+ (NSString *)sdkAppIdentifier;

- (void)collectIgnoringRestrictions:(BOOL)ignoreRestrictions withHandler:(void (^)(BOOL, NSString *, id))handler;

@end

NS_ASSUME_NONNULL_END
