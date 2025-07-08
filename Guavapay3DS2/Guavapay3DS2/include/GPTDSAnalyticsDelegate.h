//
//  GPTDSAnalyticsDelegate.h
//  Guavapay3DS2
//
//

NS_ASSUME_NONNULL_BEGIN

@protocol GPTDSAnalyticsDelegate <NSObject>

- (void)didReceiveChallengeResponseWithTransactionID:(NSString *)transactionID flow:(NSString *)type;

- (void)cancelButtonTappedWithTransactionID:(NSString *)transactionID;

- (void)OTPSubmitButtonTappedWithTransactionID:(NSString *)transactionID;

- (void)OOBContinueButtonTappedWithTransactionID:(NSString *)transactionID;

- (void)OOBDidEnterBackground:(NSString *)transactionID;
- (void)OOBWillEnterForeground:(NSString *)transactionID;

@end

NS_ASSUME_NONNULL_END
