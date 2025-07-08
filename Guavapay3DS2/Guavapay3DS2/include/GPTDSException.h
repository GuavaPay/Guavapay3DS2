//
//  GPTDSException.h
//  Guavapay3DS2
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 An abstract class to represent 3DS2 SDK custom exceptions
 */
@interface GPTDSException : NSException

/**
 A description of the exception.
 */
@property (nonatomic, readonly) NSString *message;

@end

NS_ASSUME_NONNULL_END
