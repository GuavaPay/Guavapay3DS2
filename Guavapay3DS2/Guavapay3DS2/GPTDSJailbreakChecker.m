//
//  GPTDSJailbreakChecker.m
//  Guavapay3DS2
//

#import "GPTDSJailbreakChecker.h"

@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@implementation GPTDSJailbreakChecker

// This was implemented under the following guidance: https://medium.com/@pinmadhon/how-to-check-your-app-is-installed-on-a-jailbroken-device-67fa0170cf56
+ (BOOL)isJailbroken {
    
    // Check for existence of files that are common for jailbroken devices
    if ([[NSFileManager defaultManager] fileExistsAtPath:@"/Applications/Cydia.app"] ||
        [[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/MobileSubstrate.dylib"]) {
        return YES;
    }
    
    return NO;
}

@end

NS_ASSUME_NONNULL_END
