//
//  GPTDSSimulatorChecker.m
//  Guavapay3DS2
//

#import "GPTDSSimulatorChecker.h"

NS_ASSUME_NONNULL_BEGIN

@implementation GPTDSSimulatorChecker

+ (BOOL)isRunningOnSimulator {
#if TARGET_IPHONE_SIMULATOR
    return YES;
#else
    return NO;
#endif
}

@end

NS_ASSUME_NONNULL_END
