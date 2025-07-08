//
//  GPTDSChallengeResponseObject.m
//  Guavapay3DS2
//

#import "GPTDSChallengeResponseObject.h"

#import "NSDictionary+DecodingHelpers.h"
#import "NSError+Guavapay3DS2.h"
#import "GPTDSChallengeResponseSelectionInfoObject.h"
#import "GPTDSChallengeResponseImageObject.h"
#import "GPTDSChallengeResponseMessageExtensionObject.h"
#import "NSString+JWEHelpers.h"
#import "GPTDSGuavapay3DS2Error.h"

NS_ASSUME_NONNULL_BEGIN

@implementation GPTDSChallengeResponseObject

@synthesize threeDSServerTransactionID = _threeDSServerTransactionID;
@synthesize acsCounterACStoSDK = _acsCounterACStoSDK;
@synthesize acsTransactionID = _acsTransactionID;
@synthesize acsHTML = _acsHTML;
@synthesize acsHTMLRefresh = _acsHTMLRefresh;
@synthesize acsUIType = _acsUIType;
@synthesize challengeCompletionIndicator = _challengeCompletionIndicator;
@synthesize challengeInfoHeader = _challengeInfoHeader;
@synthesize challengeInfoLabel = _challengeInfoLabel;
@synthesize challengeInfoText = _challengeInfoText;
@synthesize challengeAdditionalInfoText = _challengeAdditionalInfoText;
@synthesize showChallengeInfoTextIndicator = _showChallengeInfoTextIndicator;
@synthesize challengeSelectInfo = _challengeSelectInfo;
@synthesize expandInfoLabel = _expandInfoLabel;
@synthesize expandInfoText = _expandInfoText;
@synthesize issuerImage = _issuerImage;
@synthesize messageExtensions = _messageExtensions;
@synthesize messageType = _messageType;
@synthesize messageVersion = _messageVersion;
@synthesize oobAppURL = _oobAppURL;
@synthesize oobAppLabel = _oobAppLabel;
@synthesize oobContinueLabel = _oobContinueLabel;
@synthesize paymentSystemImage = _paymentSystemImage;
@synthesize resendInformationLabel = _resendInformationLabel;
@synthesize sdkTransactionID = _sdkTransactionID;
@synthesize submitAuthenticationLabel = _submitAuthenticationLabel;
@synthesize whitelistingInfoText = _whitelistingInfoText;
@synthesize whyInfoLabel = _whyInfoLabel;
@synthesize whyInfoText = _whyInfoText;
@synthesize transactionStatus = _transactionStatus;

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ -- completion: %@, count: %@", [super description], @(self.challengeCompletionIndicator), self.acsCounterACStoSDK];
}

- (instancetype)initWithThreeDSServerTransactionID:(NSString *)threeDSServerTransactionID
                                acsCounterACStoSDK:(NSString *)acsCounterACStoSDK
                                  acsTransactionID:(NSString *)acsTransactionID
                                           acsHTML:(NSString * _Nullable)acsHTML
                                    acsHTMLRefresh:(NSString * _Nullable)acsHTMLRefresh
                                         acsUIType:(GPTDSACSUIType)acsUIType
                      challengeCompletionIndicator:(BOOL)challengeCompletionIndicator
                               challengeInfoHeader:(NSString * _Nullable)challengeInfoHeader
                                challengeInfoLabel:(NSString * _Nullable)challengeInfoLabel
                                 challengeInfoText:(NSString * _Nullable)challengeInfoText
                       challengeAdditionalInfoText:(NSString * _Nullable)challengeAdditionalInfoText
                    showChallengeInfoTextIndicator:(BOOL)showChallengeInfoTextIndicator
                               challengeSelectInfo:(NSArray<id<GPTDSChallengeResponseSelectionInfo>> * _Nullable)challengeSelectInfo
                                   expandInfoLabel:(NSString * _Nullable)expandInfoLabel
                                    expandInfoText:(NSString * _Nullable)expandInfoText
                                       issuerImage:(id<GPTDSChallengeResponseImage> _Nullable)issuerImage
                                 messageExtensions:(NSArray<id<GPTDSChallengeResponseMessageExtension>> * _Nullable)messageExtensions
                                    messageVersion:(NSString *)messageVersion
                                         oobAppURL:(NSURL * _Nullable)oobAppURL
                                       oobAppLabel:(NSString * _Nullable)oobAppLabel
                                  oobContinueLabel:(NSString * _Nullable)oobContinueLabel
                                paymentSystemImage:(id<GPTDSChallengeResponseImage> _Nullable)paymentSystemImage
                            resendInformationLabel:(NSString * _Nullable)resendInformationLabel
                                  sdkTransactionID:(NSString *)sdkTransactionID
                         submitAuthenticationLabel:(NSString * _Nullable)submitAuthenticationLabel
                              whitelistingInfoText:(NSString * _Nullable)whitelistingInfoText
                                      whyInfoLabel:(NSString * _Nullable)whyInfoLabel
                                       whyInfoText:(NSString * _Nullable)whyInfoText
                                 transactionStatus:(NSString * _Nullable)transactionStatus {
    self = [super init];

    if (self) {
        _threeDSServerTransactionID = [threeDSServerTransactionID copy];
        _acsCounterACStoSDK = [acsCounterACStoSDK copy];
        _acsTransactionID = [acsTransactionID copy];
        _acsHTML = [acsHTML copy];
        _acsHTMLRefresh = [acsHTMLRefresh copy];
        _acsUIType = acsUIType;
        _challengeCompletionIndicator = challengeCompletionIndicator;
        _challengeInfoHeader = [challengeInfoHeader copy];
        _challengeInfoLabel = [challengeInfoLabel copy];
        _challengeInfoText = [challengeInfoText copy];
        _challengeAdditionalInfoText = [challengeAdditionalInfoText copy];
        _showChallengeInfoTextIndicator = showChallengeInfoTextIndicator;
        _challengeSelectInfo = [challengeSelectInfo copy];
        _expandInfoLabel = [expandInfoLabel copy];
        _expandInfoText = [expandInfoText copy];
        _issuerImage = issuerImage;
        _messageExtensions = [messageExtensions copy];
        _messageType = @"CRes";
        _messageVersion = [messageVersion copy];
        _oobAppURL = oobAppURL;
        _oobAppLabel = [oobAppLabel copy];
        _oobContinueLabel = [oobContinueLabel copy];
        _paymentSystemImage = paymentSystemImage;
        _resendInformationLabel = [resendInformationLabel copy];
        _sdkTransactionID = [sdkTransactionID copy];
        _submitAuthenticationLabel = [submitAuthenticationLabel copy];
        _whitelistingInfoText = [whitelistingInfoText copy];
        _whyInfoLabel = [whyInfoLabel copy];
        _whyInfoText = [whyInfoText copy];
        _transactionStatus = [transactionStatus copy];
    }

    return self;
}

#pragma mark Private Helpers

+ (NSDictionary<NSString *, NSNumber *> *)acsUITypeStringMapping {
    return @{
        @"01": @(GPTDSACSUITypeText),
        @"02": @(GPTDSACSUITypeSingleSelect),
        @"03": @(GPTDSACSUITypeMultiSelect),
        @"04": @(GPTDSACSUITypeOOB),
        @"05": @(GPTDSACSUITypeHTML),
    };
}

/// The message extension identifiers that we support.
+ (NSSet *)supportedMessageExtensions {
    return [NSSet new];
}

#pragma mark GPTDSJSONDecodable

+ (nullable instancetype)decodedObjectFromJSON:(nullable NSDictionary *)json error:(NSError **)outError {
    if (json == nil) {
        return nil;
    }
    NSError *error;

#pragma mark Required
    NSString *threeDSServerTransactionID = [json _gptds_stringForKey:@"threeDSServerTransID" validator:^BOOL (NSString *value) {
        return [[NSUUID alloc] initWithUUIDString:value] != nil;
    } required:YES error:&error];
    NSString *acsCounterACStoSDK = [json _gptds_stringForKey:@"acsCounterAtoS" required:YES error:&error];
    NSString *acsTransactionID = [json _gptds_stringForKey:@"acsTransID" required:YES error:&error];
    NSString *challengeCompletionIndicatorRawString = [json _gptds_stringForKey:@"challengeCompletionInd" validator:^BOOL (NSString *value) {
        return [value isEqualToString:@"N"] || [value isEqualToString:@"Y"];
    } required:YES error:&error];
    // There is only one valid messageType value for this object (@"CRes"), so we don't store it.
    [json _gptds_stringForKey:@"messageType" validator:^BOOL (NSString *value) {
        return [value isEqualToString:@"CRes"];
    } required:YES error:&error];
    NSString *messageVersion = [json _gptds_stringForKey:@"messageVersion" required:YES error:&error];
    NSString *sdkTransactionID = [json _gptds_stringForKey:@"sdkTransID" required:YES error:&error];

    BOOL challengeCompletionIndicator = challengeCompletionIndicatorRawString.boolValue;

    GPTDSACSUIType acsUIType = GPTDSACSUITypeNone;
    if (!challengeCompletionIndicator) {
        NSString *acsUITypeRawString = [json _gptds_stringForKey:@"acsUiType" validator:^BOOL (NSString *value) {
            return [self acsUITypeStringMapping][value] != nil;
        } required:YES error:&error];

        acsUIType = [self acsUITypeStringMapping][acsUITypeRawString].integerValue;
    }

    if (error) {
        // We failed to populate a required field
        if (outError) {
            *outError = error;
        }
        return nil;
    }

    // At this point all the above values are valid: e.g. raw string representations of a BOOL or enum will map to a valid value.

#pragma mark Conditional
    NSString *encodedAcsHTML = [json _gptds_stringForKey:@"acsHTML" required:(acsUIType == GPTDSACSUITypeHTML) error: &error];
    NSString *acsHTML = [encodedAcsHTML _gptds_base64URLDecodedString];
    if (encodedAcsHTML && !acsHTML) {
        // html was not valid base64url
        error = [NSError _gptds_invalidJSONFieldError:@"acsHTML"];
    }

    NSArray<id<GPTDSChallengeResponseSelectionInfo>> *challengeSelectInfo = [json _gptds_arrayForKey:@"challengeSelectInfo"
                                                                                    arrayElementType:[GPTDSChallengeResponseSelectionInfoObject class]
                                                                                            required:(acsUIType == GPTDSACSUITypeSingleSelect || acsUIType == GPTDSACSUITypeMultiSelect)
                                                                                               error:&error];
    NSString *oobContinueLabel = [json _gptds_stringForKey:@"oobContinueLabel" required:(acsUIType == GPTDSACSUITypeOOB) error:&error];
    NSString *submitAuthenticationLabel = [json _gptds_stringForKey:@"submitAuthenticationLabel" required:(acsUIType == GPTDSACSUITypeText || acsUIType == GPTDSACSUITypeSingleSelect || acsUIType == GPTDSACSUITypeMultiSelect || acsUIType == GPTDSACSUITypeText) error:&error];

#pragma mark Optional
    NSArray<id<GPTDSChallengeResponseMessageExtension>> *messageExtensions = [json _gptds_arrayForKey:@"messageExtension"
                                                                                     arrayElementType:[GPTDSChallengeResponseMessageExtensionObject class]
                                                                                             required:NO
                                                                                                error:&error];
    NSMutableArray<NSString *> *unrecognizedMessageExtensionIdentifiers = [NSMutableArray new];
    for (id<GPTDSChallengeResponseMessageExtension> messageExtension in messageExtensions) {
        if (messageExtension.criticalityIndicator && ![[self supportedMessageExtensions] containsObject:messageExtension.identifier]) {
            [unrecognizedMessageExtensionIdentifiers addObject:messageExtension.identifier];
        }
    }
    if (unrecognizedMessageExtensionIdentifiers.count > 0) {
        error = [NSError errorWithDomain:GPTDSGuavapay3DS2ErrorDomain code:GPTDSErrorCodeUnrecognizedCriticalMessageExtension userInfo:@{GPTDSGuavapay3DS2UnrecognizedCriticalMessageExtensionsKey: unrecognizedMessageExtensionIdentifiers}];
    }
    if (messageExtensions.count > 10) {
        error = [NSError _gptds_invalidJSONFieldError:@"messageExtension"];
    }

    NSString *encodedAcsHTMLRefresh = [json _gptds_stringForKey:@"acsHTMLRefresh" required:NO error: &error];
    NSString *acsHTMLRefresh = [encodedAcsHTMLRefresh _gptds_base64URLDecodedString];
    if (encodedAcsHTMLRefresh && !acsHTMLRefresh) {
        // html was not valid base64url
        error = [NSError _gptds_invalidJSONFieldError:@"acsHTMLRefresh"];
    }

    BOOL infoLabelRequired = NO;
    BOOL headerRequired = NO;
    BOOL infoTextRequired = NO;
    switch (acsUIType) {
        case GPTDSACSUITypeNone:
            break; // no-op
        case GPTDSACSUITypeText:
        case GPTDSACSUITypeSingleSelect:
        case GPTDSACSUITypeMultiSelect:
            infoLabelRequired = YES; // TC_SDK_10270_001 & TC_SDK_10276_001 & TC_SDK_10284_001
            headerRequired = YES; // TC_SDK_10268_001 & TC_SDK_10273_001 & TC_SDK_10282_001
            infoTextRequired = YES; // TC_SDK_10272_001 & TC_SDK_10278_001 & TC_SDK_10286_001
            break;
        case GPTDSACSUITypeOOB:

            break;
        case GPTDSACSUITypeHTML:
            break; // no-op
    }


    NSString *challengeInfoLabel = [json _gptds_stringForKey:@"challengeInfoLabel" validator:nil required:infoLabelRequired error:&error];
    NSString *challengeInfoHeader = [json _gptds_stringForKey:@"challengeInfoHeader" required: (oobContinueLabel != nil) || headerRequired error:&error]; // TC_SDK_10292_001
    NSString *challengeInfoText =  [json _gptds_stringForKey:@"challengeInfoText" required:(oobContinueLabel != nil) || infoTextRequired error:&error]; // TC_SDK_10292_001
    NSString *challengeAdditionalInfoText =  [json _gptds_stringForKey:@"challengeAddInfo" required:NO error:&error];

    if (acsUIType != GPTDSACSUITypeHTML) {
        if (!error && submitAuthenticationLabel && (!challengeInfoLabel && !challengeInfoHeader && !challengeInfoText)) {
            error = [NSError _gptds_missingJSONFieldError:@"challengeInfoLabel or challengeInfoText or challengeInfoHeader"];
        }
    }

    NSString *showChallengeInfoTextIndicatorRawString;
    if (json[@"challengeInfoTextIndicator"]) {
        showChallengeInfoTextIndicatorRawString = [json _gptds_stringForKey:@"challengeInfoTextIndicator" validator:^BOOL (NSString *value) {
            return [value isEqualToString:@"N"] || [value isEqualToString:@"Y"];
        } required:NO error:&error];
    }
    BOOL showChallengeInfoTextIndicator = showChallengeInfoTextIndicatorRawString ? showChallengeInfoTextIndicatorRawString.boolValue : NO; // If the field is missing, we shouldn't show the indicator
    NSString *expandInfoLabel = [json _gptds_stringForKey:@"expandInfoLabel" required:NO error:&error];
    NSString *expandInfoText = [json _gptds_stringForKey:@"expandInfoText" required:NO error:&error];

    NSURL * _Nullable oobAppURL = nil;
    NSString * _Nullable oobAppLabel = nil;
    for (id<GPTDSChallengeResponseMessageExtension> messageExtension in messageExtensions) {
        NSDictionary *data = messageExtension.data;
        NSDictionary *challengeData = [data _gptds_dictionaryForKey:@"challengeData" required:NO error:&error];
        if (challengeData[@"oobAppURL"] && challengeData[@"oobAppLabel"]) {

            // Validating "oobAppURL" so that it only has `https://` scheme and non-empty host component
            oobAppURL = [challengeData _gptds_urlForKey:@"oobAppURL" validator:^BOOL (NSString *value) {
                NSURL *url = [NSURL URLWithString:value];
                return url != nil && [[url.scheme lowercaseString] isEqualToString:@"https"] && url.host.length > 0;
            } required:NO error:&error];

            oobAppLabel = [challengeData _gptds_stringForKey:@"oobAppLabel" required:NO error:&error];
        }
    }

    NSDictionary *issuerImageJSON = [json _gptds_dictionaryForKey:@"issuerImage" required:NO error:&error];
    GPTDSChallengeResponseImageObject *issuerImage = [GPTDSChallengeResponseImageObject decodedObjectFromJSON:issuerImageJSON error:&error];
    NSDictionary *paymentSystemImageJSON = [json _gptds_dictionaryForKey:@"psImage" required:NO error:&error];
    GPTDSChallengeResponseImageObject *paymentSystemImage = [GPTDSChallengeResponseImageObject decodedObjectFromJSON:paymentSystemImageJSON error:&error];
    NSString *resendInformationLabel = [json _gptds_stringForKey:@"resendInformationLabel" required:NO error:&error];
    NSString *whitelistingInfoText = [json _gptds_stringForKey:@"whitelistingInfoText" required:NO error:&error];
    if (whitelistingInfoText.length > 64) {
        // TC_SDK_10199_001
        error = [NSError _gptds_invalidJSONFieldError:@"whitelisting text is greater than 64 characters"];
    }
    NSString *whyInfoLabel = [json _gptds_stringForKey:@"whyInfoLabel" required:NO error:&error];
    NSString *whyInfoText = [json _gptds_stringForKey:@"whyInfoText" required:NO error:&error];
    NSString *transactionStatus = [json _gptds_stringForKey:@"transStatus" required:challengeCompletionIndicator error:&error];

    if (error) {
        if (outError) {
            *outError = error;
        }
        return nil;
    }

    return [[self alloc] initWithThreeDSServerTransactionID:threeDSServerTransactionID
                                         acsCounterACStoSDK:acsCounterACStoSDK
                                           acsTransactionID:acsTransactionID
                                                    acsHTML:acsHTML
                                             acsHTMLRefresh:acsHTMLRefresh
                                                  acsUIType:acsUIType
                               challengeCompletionIndicator:challengeCompletionIndicator
                                        challengeInfoHeader:challengeInfoHeader
                                         challengeInfoLabel:challengeInfoLabel
                                          challengeInfoText:challengeInfoText
                                challengeAdditionalInfoText:challengeAdditionalInfoText
                             showChallengeInfoTextIndicator:showChallengeInfoTextIndicator
                                        challengeSelectInfo:challengeSelectInfo
                                            expandInfoLabel:expandInfoLabel
                                             expandInfoText:expandInfoText
                                                issuerImage:issuerImage
                                          messageExtensions:messageExtensions
                                             messageVersion:messageVersion
                                                  oobAppURL:oobAppURL
                                                oobAppLabel:oobAppLabel
                                           oobContinueLabel:oobContinueLabel
                                         paymentSystemImage:paymentSystemImage
                                     resendInformationLabel:resendInformationLabel
                                           sdkTransactionID:sdkTransactionID
                                  submitAuthenticationLabel:submitAuthenticationLabel
                                       whitelistingInfoText:whitelistingInfoText
                                               whyInfoLabel:whyInfoLabel
                                                whyInfoText:whyInfoText
                                          transactionStatus:transactionStatus];
}

@end

NS_ASSUME_NONNULL_END
