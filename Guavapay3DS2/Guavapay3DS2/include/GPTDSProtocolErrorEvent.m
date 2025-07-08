//
//  GPTDSProtocolErrorEvent.m
//  Guavapay3DS2
//

#import "GPTDSProtocolErrorEvent.h"

#import "GPTDSErrorMessage.h"

NS_ASSUME_NONNULL_BEGIN

@implementation GPTDSProtocolErrorEvent

- (instancetype)initWithSDKTransactionIdentifier:(NSString *)identifier errorMessage:(GPTDSErrorMessage *)errorMessage {
    self = [super init];
    if (self) {
        _sdkTransactionIdentifier = identifier;
        _errorMessage = errorMessage;
    }
    return self;
}

@end

NS_ASSUME_NONNULL_END
