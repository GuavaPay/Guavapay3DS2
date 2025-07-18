//
//  GPTDSConfigParameters.h
//  Guavapay3DS2
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 The default group name that will be used to group additional
 configuration parameters.
 */
extern NSString * const kGPTDSConfigDefaultGroupName;

/**
 `GPTDSConfigParameters` represents additional configuration parameters
 that can be passed to the Guavapay3DS2 SDK during initialization.

 There are currently no supported additional parameters and apps can
 just pass `[GPTDSConfigParameters alloc] initWithStandardParameters`
 to the `GPTDSThreeDS2Service` instance.
 */
@interface GPTDSConfigParameters : NSObject

/**
 Convenience initializer to get an `GPTDSConfigParameters` instance
 with the default expected configuration parameters.
 */
- (instancetype)initWithStandardParameters;

/**
 Adds the parameter to this instance.

 @param paramName The name of the parameter to add
 @param paramValue The value of the parameter to add
 @param paramGroup The group to which this parameter will be added. If `nil` the parameter will be added to `kGPTDSConfigDefaultGroupName`

 @exception GPTDSInvalidInputException Will throw an `GPTDSInvalidInputException` if `paramName` or `paramValue` are `nil`. @see GPTDSInvalidInputException
 */
- (void)addParameterNamed:(NSString *)paramName withValue:(NSString *)paramValue toGroup:(nullable NSString *)paramGroup;

/**
 Adds the parameter to the default group in this instance.

 @param paramName The name of the parameter to add
 @param paramValue The value of the parameter to add

 @exception GPTDSInvalidInputException Will throw an `GPTDSInvalidInputException` if `paramName` or `paramValue` are `nil`. @see GPTDSInvalidInputException
 */
- (void)addParameterNamed:(NSString *)paramName withValue:(NSString *)paramValue;

/**
 Returns the value for `paramName` in `paramGroup` or `nil` if the parameter value is not set.

 @param paramName The name of the parameter to return
 @param paramGroup The group from which to fetch the parameter value. If `nil` will default to `kGPTDSConfigDefaultGroupName`

 @exception GPTDSInvalidInputException Will throw an `GPTDSInvalidInputException` if `paramName` is `nil`. @see GPTDSInvalidInputException
 */
- (nullable NSString *)parameterValue:(NSString *)paramName inGroup:(nullable NSString *)paramGroup;

/**
 Returns the value for `paramName` in the default group or `nil` if the parameter value is not set.

 @param paramName The name of the parameter to return

 @exception GPTDSInvalidInputException Will throw an `GPTDSInvalidInputException` if `paramName` is `nil`. @see GPTDSInvalidInputException
 */
- (nullable NSString *)parameterValue:(NSString *)paramName;

/**
 Removes the specified parameter from the group and returns the value or `nil` if the parameter was not found.

 @param paramName The name of the parameter to remove
 @param paramGroup The group from which to remove this parameter. If `nil` will default to `kGPTDSConfigDefaultGroupName`

 @exception GPTDSInvalidInputException Will throw an `GPTDSInvalidInputException` if `paramName` is `nil`. @see GPTDSInvalidInputException
 */
- (nullable NSString *)removeParameterNamed:(NSString *)paramName fromGroup:(nullable NSString *)paramGroup;

/**
 Removes the specified parameter from the default group and returns the value or `nil` if the parameter was not found.

 @param paramName The name of the parameter to remove

 @exception GPTDSInvalidInputException Will throw an `GPTDSInvalidInputException` if `paramName` is `nil`. @see GPTDSInvalidInputException
 */
- (nullable NSString *)removeParameterNamed:(NSString *)paramName;

@end

NS_ASSUME_NONNULL_END
