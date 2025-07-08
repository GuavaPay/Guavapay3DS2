//
//  GPTDSChallengeResponseImageObject.m
//  Guavapay3DS2
//

#import "GPTDSChallengeResponseImageObject.h"

#import "NSDictionary+DecodingHelpers.h"

NS_ASSUME_NONNULL_BEGIN

@interface GPTDSChallengeResponseImageObject()

@property (nonatomic, nullable) NSURL *mediumDensityURL;
@property (nonatomic, nullable) NSURL *highDensityURL;
@property (nonatomic, nullable) NSURL *extraHighDensityURL;

@end

@implementation GPTDSChallengeResponseImageObject

- (instancetype)initWithMediumDensityURL:(NSURL * _Nullable)mediumDensityURL highDensityURL:(NSURL * _Nullable)highDensityURL extraHighDensityURL:(NSURL * _Nullable)extraHighDensityURL {
    self = [super init];
    
    if (self) {
        _mediumDensityURL = mediumDensityURL;
        _highDensityURL = highDensityURL;
        _extraHighDensityURL = extraHighDensityURL;
    }
    
    return self;
}

+ (nullable instancetype)decodedObjectFromJSON:(nullable NSDictionary *)json error:(NSError * _Nullable __autoreleasing * _Nullable)outError {
    if (json == nil) {
        return nil;
    }
    
    NSURL *mediumDensityURL = [json _gptds_urlForKey:@"medium" required:NO error:nil];
    NSURL *highDensityURL = [json _gptds_urlForKey:@"high" required:NO error:nil];
    NSURL *extraHighDensityURL = [json _gptds_urlForKey:@"extraHigh" required:NO error:nil];
    
    return [[GPTDSChallengeResponseImageObject alloc] initWithMediumDensityURL:mediumDensityURL
                                                               highDensityURL:highDensityURL
                                                          extraHighDensityURL:extraHighDensityURL];
}

@end

NS_ASSUME_NONNULL_END
