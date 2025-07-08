//
//  GPTDSIntegrityChecker.m
//  Guavapay3DS2
//

#import "GPTDSIntegrityChecker.h"
#import "Guavapay3DS2.h"

NS_ASSUME_NONNULL_BEGIN

@implementation GPTDSIntegrityChecker

+ (BOOL)SDKIntegrityIsValid {
    
    if (NSClassFromString(@"GPTDSIntegrityChecker") == [GPTDSIntegrityChecker class] &&
        NSClassFromString(@"GPTDSConfigParameters") == [GPTDSConfigParameters class] &&
        NSClassFromString(@"GPTDSThreeDS2Service") == [GPTDSThreeDS2Service class] &&
        NSClassFromString(@"GPTDSUICustomization") == [GPTDSUICustomization class] &&
        NSClassFromString(@"GPTDSWarning") == [GPTDSWarning class] &&
        NSClassFromString(@"GPTDSAlreadyInitializedException") == [GPTDSAlreadyInitializedException class] &&
        NSClassFromString(@"GPTDSNotInitializedException") == [GPTDSNotInitializedException class] &&
        NSClassFromString(@"GPTDSRuntimeException") == [GPTDSRuntimeException class] &&
        NSClassFromString(@"GPTDSErrorMessage") == [GPTDSErrorMessage class] &&
        NSClassFromString(@"GPTDSRuntimeErrorEvent") == [GPTDSRuntimeErrorEvent class] &&
        NSClassFromString(@"GPTDSProtocolErrorEvent") == [GPTDSProtocolErrorEvent class] &&
        NSClassFromString(@"GPTDSAuthenticationRequestParameters") == [GPTDSAuthenticationRequestParameters class] &&
        NSClassFromString(@"GPTDSChallengeParameters") == [GPTDSChallengeParameters class] &&
        NSClassFromString(@"GPTDSCompletionEvent") == [GPTDSCompletionEvent class] &&
        NSClassFromString(@"GPTDSTransaction") == [GPTDSTransaction class]) {
        return YES;
    }
    
    return NO;
}

@end

NS_ASSUME_NONNULL_END
