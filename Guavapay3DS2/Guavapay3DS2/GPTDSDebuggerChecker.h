//
//  GPTDSDebuggerChecker.h
//  Guavapay3DS2
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GPTDSDebuggerChecker : NSObject

+ (BOOL)processIsCurrentlyAttachedToDebugger;

@end

NS_ASSUME_NONNULL_END
