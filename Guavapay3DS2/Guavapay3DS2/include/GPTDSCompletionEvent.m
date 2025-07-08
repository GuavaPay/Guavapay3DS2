//
//  GPTDSCompletionEvent.m
//  Guavapay3DS2
//

#import "GPTDSCompletionEvent.h"

NS_ASSUME_NONNULL_BEGIN

@implementation GPTDSCompletionEvent

- (instancetype)initWithSDKTransactionIdentifier:(NSString *)identifier transactionStatus:(NSString *)transactionStatus {
    self = [super init];
    if (self) {
        _sdkTransactionIdentifier = [identifier copy];
        _transactionStatus = [transactionStatus copy];
    }
    return self;
}

@end

NS_ASSUME_NONNULL_END
