//
//  GPTDSJSONEncoder.h
//  Guavapay3DS2
//

#import <Foundation/Foundation.h>

#import "GPTDSJSONEncodable.h"

NS_ASSUME_NONNULL_BEGIN

/**
 `GPTDSJSONEncoder` is a utility class to help with converting API objects into JSON
 */
@interface GPTDSJSONEncoder : NSObject

/**
 Method to convert an GPTDSJSONEncodable object into a JSON dictionary.
 */
+ (NSDictionary *)dictionaryForObject:(NSObject<GPTDSJSONEncodable> *)object;

@end

NS_ASSUME_NONNULL_END
