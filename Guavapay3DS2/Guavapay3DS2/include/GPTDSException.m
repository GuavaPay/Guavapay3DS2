//
//  GPTDSException.m
//  Guavapay3DS2
//

#import "GPTDSException.h"

NS_ASSUME_NONNULL_BEGIN

@implementation GPTDSException

+ (instancetype)exceptionWithMessage:(NSString *)format, ... {
    va_list args;
    va_start(args, format);
    NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    GPTDSException *exception = [[[self class] alloc] initWithName:NSStringFromClass([self class]) reason:message userInfo:nil];
    exception->_message = [message copy];
    return exception;
}

@end

NS_ASSUME_NONNULL_END
