//
//  NSString+EmptyChecking.h
//  Guavapay3DS2
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (EmptyChecking)

+ (BOOL)_gptds_isStringEmpty:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
