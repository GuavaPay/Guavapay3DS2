//
//  GPTDSErrorMessage.m
//  Guavapay3DS2
//

#import "GPTDSErrorMessage.h"

#import "NSDictionary+DecodingHelpers.h"
#import "GPTDSJSONEncoder.h"
#import "GPTDSGuavapay3DS2Error.h"

NS_ASSUME_NONNULL_BEGIN

@implementation GPTDSErrorMessage

- (instancetype)initWithErrorCode:(NSString *)errorCode
                   errorComponent:(NSString *)errorComponent
                 errorDescription:(NSString *)errorDescription
                     errorDetails:(nullable NSString *)errorDetails
                   messageVersion:(NSString *)messageVersion
         acsTransactionIdentifier:(nullable NSString *)acsTransactionIdentifier
                 errorMessageType:(NSString *)errorMessageType {
    self = [self initWithErrorCode:errorCode
                    errorComponent:errorComponent
                  errorDescription:errorDescription
                      errorDetails:errorDetails
                    messageVersion:messageVersion
          acsTransactionIdentifier:acsTransactionIdentifier
              threeDSServerTransID:nil
                  sdkTransactionID:nil
                  errorMessageType:errorMessageType];

    return self;
}

- (instancetype)initWithErrorCode:(NSString *)errorCode
                   errorComponent:(NSString *)errorComponent
                 errorDescription:(NSString *)errorDescription
                     errorDetails:(nullable NSString *)errorDetails
                   messageVersion:(NSString *)messageVersion
         acsTransactionIdentifier:(nullable NSString *)acsTransactionIdentifier
             threeDSServerTransID:(nullable NSString *)threeDSServerTransID
                 sdkTransactionID:(nullable NSString *)sdkTransactionID
                 errorMessageType:(NSString *)errorMessageType {
    self = [super init];
    if (self) {
        _errorCode = [errorCode copy];
        _errorComponent = [errorComponent copy];
        _errorDescription = [errorDescription copy];
        _errorDetails = [errorDetails copy];
        _messageVersion = [messageVersion copy];
        _acsTransactionIdentifier = [acsTransactionIdentifier copy];
        _threeDSServerTransID = [threeDSServerTransID copy];
        _sdkTransactionID = [sdkTransactionID copy];
        _errorMessageType = [errorMessageType copy];
    }
    return self;
}

- (NSString *)messageType {
    return @"Erro";
}

- (NSError *)NSErrorValue {
    return [NSError errorWithDomain:GPTDSGuavapay3DS2ErrorDomain
                               code:[self.errorCode integerValue]
                           userInfo: [GPTDSJSONEncoder dictionaryForObject:self]];
}

#pragma mark - GPTDSJSONEncodable

+ (NSDictionary *)propertyNamesToJSONKeysMapping {
    return @{
             NSStringFromSelector(@selector(errorCode)): @"errorCode",
             NSStringFromSelector(@selector(errorComponent)): @"errorComponent",
             NSStringFromSelector(@selector(errorDescription)): @"errorDescription",
             NSStringFromSelector(@selector(errorDetails)): @"errorDetail",
             NSStringFromSelector(@selector(messageType)): @"messageType",
             NSStringFromSelector(@selector(messageVersion)): @"messageVersion",
             NSStringFromSelector(@selector(acsTransactionIdentifier)): @"acsTransID",
             NSStringFromSelector(@selector(threeDSServerTransID)): @"threeDSServerTransID",
             NSStringFromSelector(@selector(sdkTransactionID)): @"sdkTransID",
             NSStringFromSelector(@selector(errorMessageType)): @"errorMessageType",
             };
}

#pragma mark - GPTDSJSONDecodable

+ (nullable instancetype)decodedObjectFromJSON:(nullable NSDictionary *)json error:(NSError * _Nullable __autoreleasing * _Nullable)outError {
    if (json == nil) {
        return nil;
    }
    NSError *error;

    // Required
    NSString *errorCode = [json _gptds_stringForKey:@"errorCode" required:YES error:&error];
    NSString *errorComponent = [json _gptds_stringForKey:@"errorComponent" required:YES error:&error];
    NSString *errorDescription = [json _gptds_stringForKey:@"errorDescription" required:YES error:&error];
    NSString *errorDetail = [json _gptds_stringForKey:@"errorDetail" required:YES error:&error];
    NSString *messageVersion = [json _gptds_stringForKey:@"messageVersion" required:YES error:&error];

    // Optional
    NSString *errorMessageType = [json _gptds_stringForKey:@"errorMessageType" required:NO error:&error];
    NSString *acsTransactionIdentifier = [json _gptds_stringForKey:@"acsTransID" required:NO error:nil];
    NSString *threeDSServerTransID = [json _gptds_stringForKey:@"threeDSServerTransID" required:NO error:nil];
    NSString *sdkTransID = [json _gptds_stringForKey:@"sdkTransID" required:NO error:nil];

    if (error) {
        if (outError) {
            *outError = error;
        }
        return nil;
    }
    return [[self alloc] initWithErrorCode:errorCode
                            errorComponent:errorComponent
                          errorDescription:errorDescription
                              errorDetails:errorDetail
                            messageVersion:messageVersion
                  acsTransactionIdentifier:acsTransactionIdentifier
                      threeDSServerTransID:threeDSServerTransID
                          sdkTransactionID:sdkTransID
                          errorMessageType:errorMessageType];
}

@end

NS_ASSUME_NONNULL_END
