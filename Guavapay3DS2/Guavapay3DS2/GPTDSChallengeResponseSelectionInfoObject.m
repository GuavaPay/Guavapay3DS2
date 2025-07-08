//
//  GPTDSChallengeResponseSelectionInfoObject.m
//  Guavapay3DS2
//

#import "GPTDSChallengeResponseSelectionInfoObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface GPTDSChallengeResponseSelectionInfoObject()

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *value;

@end

@implementation GPTDSChallengeResponseSelectionInfoObject

- (instancetype)initWithName:(NSString *)name value:(NSString *)value {
    self = [super init];
    
    if (self) {
        _name = name;
        _value = value;
    }
    
    return self;
}

+ (nullable instancetype)decodedObjectFromJSON:(nullable NSDictionary *)json error:(NSError * _Nullable __autoreleasing * _Nullable)outError {
    if (json == nil) {
        return nil;
    }
    
    NSString *name = [json allKeys].firstObject;
    NSString *value = [json objectForKey:name];
    
    return [[GPTDSChallengeResponseSelectionInfoObject alloc] initWithName:name value:value];
}

@end

NS_ASSUME_NONNULL_END
