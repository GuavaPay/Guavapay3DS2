//
//  GPTDSAuthenticationResponseObject.m
//  Guavapay3DS2
//

#import "GPTDSAuthenticationResponseObject.h"

#import "NSDictionary+DecodingHelpers.h"

NS_ASSUME_NONNULL_BEGIN

@implementation GPTDSAuthenticationResponseObject

@synthesize acsOperatorID = _acsOperatorID;
@synthesize acsReferenceNumber = _acsReferenceNumber;
@synthesize acsSignedContent = _acsSignedContent;
@synthesize acsTransactionID = _acsTransactionID;
@synthesize acsURL = _acsURL;
@synthesize cardholderInfo = _cardholderInfo;
@synthesize status = _status;
@synthesize challengeRequired = _challengeRequired;
@synthesize directoryServerReferenceNumber = _directoryServerReferenceNumber;
@synthesize directoryServerTransactionID = _directoryServerTransactionID;
@synthesize protocolVersion = _protocolVersion;
@synthesize sdkTransactionID = _sdkTransactionID;
@synthesize threeDSServerTransactionID = _threeDSServerTransactionID;
@synthesize willUseDecoupledAuthentication = _willUseDecoupledAuthentication;

+ (nullable instancetype)decodedObjectFromJSON:(nullable NSDictionary *)json error:(NSError **)outError {
    if (json == nil) {
        return nil;
    }
    GPTDSAuthenticationResponseObject *response = [[self alloc] init];
    NSError *error = nil;

    response->_threeDSServerTransactionID = [[json _gptds_stringForKey:@"threeDsServerTransactionId" required:YES error:&error] copy];
    NSString *transStatusString = [json _gptds_stringForKey:@"transStatus" required:NO error:&error];
    response->_status = [self statusTypeForString:transStatusString];
    response->_challengeRequired = (response->_status == GPTDSACSStatusTypeChallengeRequired);
    response->_willUseDecoupledAuthentication = [[json _gptds_boolForKey:@"acsDecConInd" required:NO error:&error] boolValue];
    response->_acsOperatorID = [[json _gptds_stringForKey:@"acsOperatorID" required:NO error:&error] copy];
    response->_acsReferenceNumber = [[json _gptds_stringForKey:@"acsRefNumber" required:NO error:&error] copy];
    response->_acsSignedContent = [[json _gptds_stringForKey:@"acsSignedContent" required:NO error:&error] copy];
    response->_acsTransactionID = [[json _gptds_stringForKey:@"acsTransactionId" required:YES error:&error] copy];
    response->_acsURL = [json _gptds_urlForKey:@"acsURL" required:NO error:&error];
    response->_cardholderInfo = [[json _gptds_stringForKey:@"cardholderInfo" required:NO error:&error] copy];
    response->_directoryServerReferenceNumber = [[json _gptds_stringForKey:@"dsReferenceNumber" required:NO error:&error] copy];
    response->_directoryServerTransactionID = [[json _gptds_stringForKey:@"dsTransID" required:NO error:&error] copy];
    response->_protocolVersion = [[json _gptds_stringForKey:@"messageVersion" required:NO error:&error] copy];
    response->_sdkTransactionID = [[json _gptds_stringForKey:@"sdkTransID" required:NO error:&error] copy];

    if (error != nil) {
        if (outError != nil) {
            *outError = error;
        }

        return nil;
    }

    return response;
}

+ (GPTDSACSStatusType)statusTypeForString:(NSString *)statusString {
    if ([statusString isEqualToString:@"Y"]) {
        return GPTDSACSStatusTypeAuthenticated;
    }
    if ([statusString isEqualToString:@"C"]) {
        return GPTDSACSStatusTypeChallengeRequired;
    }
    if ([statusString isEqualToString:@"D"]) {
        return GPTDSACSStatusTypeDecoupledAuthentication;
    }
    if ([statusString isEqualToString:@"N"]) {
        return GPTDSACSStatusTypeNotAuthenticated;
    }
    if ([statusString isEqualToString:@"A"]) {
        return GPTDSACSStatusTypeProofGenerated;
    }
    if ([statusString isEqualToString:@"U"]) {
        return GPTDSACSStatusTypeError;
    }
    if ([statusString isEqualToString:@"R"]) {
        return GPTDSACSStatusTypeRejected;
    }
    if ([statusString isEqualToString:@"I"]) {
        return GPTDSACSStatusTypeInformationalOnly;
    }
    return GPTDSACSStatusTypeUnknown;
}

@end

id<GPTDSAuthenticationResponse> _Nullable GPTDSAuthenticationResponseFromJSON(NSDictionary *json) {
    return [GPTDSAuthenticationResponseObject decodedObjectFromJSON:json error:NULL];
}

NS_ASSUME_NONNULL_END
