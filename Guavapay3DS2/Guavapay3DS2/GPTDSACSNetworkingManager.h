//
//  GPTDSACSNetworkingManager.h
//  Guavapay3DS2
//

#import <Foundation/Foundation.h>

@class GPTDSChallengeRequestParameters;
@class GPTDSErrorMessage;
@protocol GPTDSChallengeResponse;

NS_ASSUME_NONNULL_BEGIN

@interface GPTDSACSNetworkingManager : NSObject

- (instancetype)initWithURL:(NSURL *)acsURL
    sdkContentEncryptionKey:(NSData *)sdkCEK
    acsContentEncryptionKey:(NSData *)acsCEK
   acsTransactionIdentifier:(NSString *)acsTransactionID;

- (void)submitChallengeRequest:(GPTDSChallengeRequestParameters *)request withCompletion:(void (^)(id<GPTDSChallengeResponse> _Nullable, NSError * _Nullable))completion;

- (void)sendErrorMessage:(GPTDSErrorMessage *)errorMessage;

@end

NS_ASSUME_NONNULL_END
