//
//  GPTDSPackedSDKChallengeParameters.m
//  Guavapay3DS2
//

#import "GPTDSPackedSDKChallengeParameters.h"

@implementation GPTDSPackedSDKChallengeParameters

- (instancetype)initWithDictionary:(NSDictionary<NSString *, id> *)dict {
    self = [super init];
    if (self) {
        _acsSignedContent = [dict[@"acsSignedContent"] copy];
        _threeDsServerTransactionId = [dict[@"threeDsServerTransactionId"] copy];
        _acsTransactionId = [dict[@"acsTransactionId"] copy];
        _acsRefNumber = [dict[@"acsRefNumber"] copy];
    }
    return self;
}

@end
