//
//  GPTDSAuthenticationResponseObject.h
//  Guavapay3DS2
//

#import <Foundation/Foundation.h>

#import "GPTDSAuthenticationResponse.h"
#import "GPTDSJSONDecodable.h"

NS_ASSUME_NONNULL_BEGIN

@interface GPTDSAuthenticationResponseObject : NSObject <GPTDSAuthenticationResponse, GPTDSJSONDecodable>

@end

NS_ASSUME_NONNULL_END
