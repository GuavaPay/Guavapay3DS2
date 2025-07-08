//
//  GPTDSChallengeResponseImageObject.h
//  Guavapay3DS2
//

#import <Foundation/Foundation.h>
#import "GPTDSChallengeResponseImage.h"

#import "GPTDSJSONDecodable.h"

NS_ASSUME_NONNULL_BEGIN

/// An object used to represent information about an individual image resource inside of a challenge response.
@interface GPTDSChallengeResponseImageObject: NSObject <GPTDSChallengeResponseImage, GPTDSJSONDecodable>

- (instancetype)initWithMediumDensityURL:(NSURL * _Nullable)mediumDensityURL highDensityURL:(NSURL * _Nullable)highDensityURL extraHighDensityURL:(NSURL * _Nullable)extraHighDensityURL;

@end

NS_ASSUME_NONNULL_END
