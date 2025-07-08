//
//  GPTDSChallengeResponseImage.h
//  Guavapay3DS2
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// A protocol used to represent information about an individual image resource inside of a challenge response.
@protocol GPTDSChallengeResponseImage

/// A medium density image to display as the issuer image.
@property (nonatomic, readonly, nullable) NSURL *mediumDensityURL;

/// A high density image to display as the issuer image.
@property (nonatomic, readonly, nullable) NSURL *highDensityURL;

/// An extra-high density image to display as the issuer image.
@property (nonatomic, readonly, nullable) NSURL *extraHighDensityURL;

@end

NS_ASSUME_NONNULL_END
