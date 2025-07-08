//
//  GPTDSException+Internal.h
//  Guavapay3DS2
//

#import "GPTDSException.h"

NS_ASSUME_NONNULL_BEGIN

@interface GPTDSException (Internal)

+ (instancetype)exceptionWithMessage:(NSString *)format, ...;

@end

NS_ASSUME_NONNULL_END
