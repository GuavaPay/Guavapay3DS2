//
//  GPTDSChallengeResponseSelectionInfo.h
//  Guavapay3DS2
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// A protocol that encapsulates information about an individual selection inside of a challenge response.
@protocol GPTDSChallengeResponseSelectionInfo

/// The name of the selection option.
@property (nonatomic, readonly) NSString *name;

/// The value of the selection option.
@property (nonatomic, readonly) NSString *value;

@end

NS_ASSUME_NONNULL_END
