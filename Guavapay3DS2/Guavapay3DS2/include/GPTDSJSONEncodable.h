//
//  GPTDSJSONEncodable.h
//  Guavapay3DS2
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol GPTDSJSONEncodable <NSObject>

/**
 Returns a map of property names to their JSON representation's key value. For example, `GPTDSChallengeParameters` has a property called `acsTransactionID`, but the 3DS2 JSON spec expects a field called `acsTransID`. This dictionary represents a mapping from the former to the latter (in other words, [GPTDSChallengeParameters propertyNamesToJSONKeysMapping][@"acsTransactionID"] == @"acsTransID".)
 */
+ (NSDictionary *)propertyNamesToJSONKeysMapping;

@end

NS_ASSUME_NONNULL_END
