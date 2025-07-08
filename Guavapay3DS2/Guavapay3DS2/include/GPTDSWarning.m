//
//  GPTDSWarning.m
//  Guavapay3DS2
//

#import "GPTDSWarning.h"

NS_ASSUME_NONNULL_BEGIN

@implementation GPTDSWarning

- (instancetype)initWithIdentifier:(NSString *)identifier
                           message:(NSString *)message
                          severity:(GPTDSWarningSeverity)severity {
    self = [super init];
    if (self) {
        _identifier = [identifier copy];
        _message = [message copy];
        _severity = severity;
    }

    return self;
}

@end

NS_ASSUME_NONNULL_END
