//
//  GPTDSAlreadyInitializedException.h
//  Guavapay3DS2
//

#import "GPTDSException.h"

NS_ASSUME_NONNULL_BEGIN

/**
 `GPTDSAlreadyInitializedException` represents an exception that will be thrown in the `GPTDSThreeDS2Service` instance has already been initialized.

 @see GPTDSThreeDS2Service
 */
@interface GPTDSAlreadyInitializedException : GPTDSException

@end

NS_ASSUME_NONNULL_END
