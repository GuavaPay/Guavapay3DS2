//
//  NSString+EmptyChecking.m
//  Guavapay3DS2
//

#import "NSString+EmptyChecking.h"

@implementation NSString (EmptyChecking)

+ (BOOL)_gptds_isStringEmpty:(NSString *)string {
    if (string.length == 0) {
        return YES;
    }
    
    if(![string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length) {
        return YES;
    }
    
    return NO;
}

@end
