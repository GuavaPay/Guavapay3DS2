//
//  GPTDSRuntimeErrorEvent.m
//  Guavapay3DS2
//

#import "GPTDSRuntimeErrorEvent.h"

#import "GPTDSGuavapay3DS2Error.h"

NS_ASSUME_NONNULL_BEGIN

NSString * const kGPTDSRuntimeErrorCodeParsingError = @"GPTDSRuntimeErrorCodeParsingError";
NSString * const kGPTDSRuntimeErrorCodeEncryptionError = @"GPTDSRuntimeErrorCodeEncryptionError";

@implementation GPTDSRuntimeErrorEvent

- (instancetype)initWithErrorCode:(NSString *)errorCode errorMessage:(NSString *)errorMessage {
    self = [super init];
    if (self) {
        _errorCode = [errorCode copy];
        _errorMessage = [errorMessage copy];
    }
    return self;
}

- (NSError *)NSErrorValue {
    return [NSError errorWithDomain:GPTDSGuavapay3DS2ErrorDomain
                               code:[self.errorCode isEqualToString:kGPTDSRuntimeErrorCodeParsingError] ? GPTDSErrorCodeRuntimeParsing : GPTDSErrorCodeRuntimeEncryption
                           userInfo:@{@"errorMessage": self.errorMessage}];
}

@end

NS_ASSUME_NONNULL_END
