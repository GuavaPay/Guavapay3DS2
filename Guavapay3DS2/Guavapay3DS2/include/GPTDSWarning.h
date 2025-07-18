//
//  GPTDSWarning.h
//  Guavapay3DS2
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 The `GPTDSWarningSeverity` enum defines the severity levels of warnings generated
 during SDK initialization. @see GPTDSThreeDS2Service
 */
typedef NS_ENUM(NSInteger, GPTDSWarningSeverity) {
    /**
     Low severity
     */
    GPTDSWarningSeverityLow = 0,

    /**
     Medium severity
     */
    GPTDSWarningSeverityMedium,

    /**
     High severity
     */
    GPTDSWarningSeverityHigh,
};

/**
 The `GPTDSWarning` class represents warnings generated by `GPTDSThreeDS2Service` during
 security checks run during initialization. @see GPTDSThreeDS2Service
 */
@interface GPTDSWarning : NSObject

/**
 Designated initializer for `GPTDSWarning`.
 */
- (instancetype)initWithIdentifier:(NSString *)identifier
                           message:(NSString *)message
                          severity:(GPTDSWarningSeverity)severity NS_DESIGNATED_INITIALIZER;

/**
 `GPTDSWarning` should not be directly initialized.
 */
- (instancetype)init NS_UNAVAILABLE;

/**
 The identifier for this warning instance.
 */
@property (nonatomic, readonly) NSString *identifier;

/**
 The descriptive message for this warning.
 */
@property (nonatomic, readonly) NSString *message;

/**
 The severity of this warning.
 */
@property (nonatomic, readonly) GPTDSWarningSeverity severity;

@end

NS_ASSUME_NONNULL_END
