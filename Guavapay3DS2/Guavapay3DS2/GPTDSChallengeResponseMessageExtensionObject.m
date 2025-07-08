//
//  GPTDSChallengeResponseMessageExtensionObject.m
//  Guavapay3DS2
//

#import "GPTDSChallengeResponseMessageExtensionObject.h"

#import "NSDictionary+DecodingHelpers.h"
#import "NSError+Guavapay3DS2.h"

NS_ASSUME_NONNULL_BEGIN

static const NSInteger kMaximumStringFieldLength = 64;
static const NSInteger kMaximumDataFieldLength = 8059;

@implementation GPTDSChallengeResponseMessageExtensionObject

@synthesize name = _name;
@synthesize identifier = _identifier;
@synthesize criticalityIndicator = _criticalityIndicator;
@synthesize data = _data;

- (instancetype)initWithName:(NSString *)name identifier:(NSString *)identifier criticalityIndicator:(BOOL)criticalityIndicator data:(NSDictionary *)data {
    self = [super init];
    if (self) {
        _name = [name copy];
        _identifier = [identifier copy];
        _criticalityIndicator = criticalityIndicator;
        _data = data;
    }
    return self;
}

+ (nullable instancetype)decodedObjectFromJSON:(nullable NSDictionary *)json error:(NSError * _Nullable __autoreleasing * _Nullable)outError {
    if (json == nil) {
        return nil;
    }
    NSError *error;
    
    NSString *name = [json _gptds_stringForKey:@"name" validator:^BOOL (NSString *value) {
        return value.length <= kMaximumStringFieldLength;
    }required:YES error:&error];
    NSString *identifier = [json _gptds_stringForKey:@"id" validator:^BOOL (NSString *value) {
        return value.length <= kMaximumStringFieldLength;
    } required:YES error:&error];
    BOOL criticalityIndicator= [json _gptds_boolForKey:@"criticalityIndicator" required:YES error:&error].boolValue;
    NSDictionary *data = [json _gptds_dictionaryForKey:@"data" required:YES error:&error];
    // The spec requires data to be "Maximum 8059 characters"
    if (data && [NSJSONSerialization dataWithJSONObject:data options:0 error:nil].length > kMaximumDataFieldLength) {
        error = [NSError _gptds_invalidJSONFieldError:@"data"];
    }
    
    if (error) {
        if (outError) {
            *outError = error;
        }
        return nil;
    }
    
    if (data != nil) {
        return [[GPTDSChallengeResponseMessageExtensionObject alloc] initWithName:name identifier:identifier criticalityIndicator:criticalityIndicator data:data];
    } else {
        return nil;
    }
}

@end

NS_ASSUME_NONNULL_END
