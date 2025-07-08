//
//  GPTDSChallengeResponseMessageExtensionObject.h
//  Guavapay3DS2
//

#import <Foundation/Foundation.h>
#import "GPTDSChallengeResponseMessageExtension.h"

#import "GPTDSJSONDecodable.h"

NS_ASSUME_NONNULL_BEGIN

/// An object used to represent an individual message extension inside of a challenge response.
@interface GPTDSChallengeResponseMessageExtensionObject: NSObject <GPTDSChallengeResponseMessageExtension, GPTDSJSONDecodable>

@end

NS_ASSUME_NONNULL_END
