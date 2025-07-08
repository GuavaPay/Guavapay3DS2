//
//  GPTDSChallengeResponseSelectionInfoObject.h
//  Guavapay3DS2
//

#import <Foundation/Foundation.h>
#import "GPTDSChallengeResponseSelectionInfo.h"

NS_ASSUME_NONNULL_BEGIN

/// An object used to represent information about an individual selection inside of a challenge response.
@interface GPTDSChallengeResponseSelectionInfoObject: NSObject <GPTDSChallengeResponseSelectionInfo>

- (instancetype)initWithName:(NSString *)name value:(NSString *)value;

@end

NS_ASSUME_NONNULL_END
