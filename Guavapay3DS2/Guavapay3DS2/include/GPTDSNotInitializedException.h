//
//  GPTDSNotInitializedException.h
//  Guavapay3DS2
//

#import "GPTDSException.h"

NS_ASSUME_NONNULL_BEGIN

/**
 `GPTDSNotInitializedException` represents an exception that will be thrown by
 the the Guavapay3DS2 SDK if methods are called without initializing `GPTDSThreeDS2Service`.

 @see GPTDSThreeDS2Service
 */
@interface GPTDSNotInitializedException : GPTDSException

@end

NS_ASSUME_NONNULL_END
