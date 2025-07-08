//
//  GPTDSPackedSDKChallengeParameters.h
//  Guavapay3DS2
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GPTDSPackedSDKChallengeParameters : NSObject

@property (nonatomic, copy)   NSString *acsSignedContent;
@property (nonatomic, copy)   NSString *threeDsServerTransactionId;
@property (nonatomic, copy)   NSString *acsTransactionId;
@property (nonatomic, copy)   NSString *acsRefNumber;

- (instancetype)initWithDictionary:(NSDictionary<NSString *, id> *)dict;

@end

NS_ASSUME_NONNULL_END
