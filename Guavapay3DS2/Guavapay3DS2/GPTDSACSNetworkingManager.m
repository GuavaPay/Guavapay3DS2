//
//  GPTDSACSNetworkingManager..m
//  Guavapay3DS2
//

#import "GPTDSACSNetworkingManager.h"

#import "GPTDSChallengeRequestParameters.h"
#import "GPTDSChallengeResponseObject.h"
#import "GPTDSJSONEncoder.h"
#import "GPTDSJSONWebEncryption.h"
#import "GPTDSGuavapay3DS2Error.h"
#import "GPTDSErrorMessage+Internal.h"
#import "NSError+Guavapay3DS2.h"

NS_ASSUME_NONNULL_BEGIN

/// [Req 239] requires us to abort if the ACS does not respond with the CRes message within 10 seconds.
static const NSTimeInterval kTimeoutInterval = 10;

@implementation GPTDSACSNetworkingManager {
    NSURL *_acsURL;
    NSData *_sdkContentEncryptionKey;
    NSData *_acsContentEncryptionKey;
    NSString *_acsTransactionIdentifier;

    NSURLSession *_urlSession;
    NSURLSessionTask * _Nullable _currentTask;
}

- (instancetype)initWithURL:(NSURL *)acsURL
    sdkContentEncryptionKey:(NSData *)sdkCEK
    acsContentEncryptionKey:(NSData *)acsCEK
   acsTransactionIdentifier:(nonnull NSString *)acsTransactionID {
    self = [super init];
    if (self) {
        _acsURL = acsURL;
        _sdkContentEncryptionKey = sdkCEK;
        _acsContentEncryptionKey = acsCEK;
        _acsTransactionIdentifier = [acsTransactionID copy];
        _urlSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration ephemeralSessionConfiguration]
                                                    delegate:nil
                                               delegateQueue:[NSOperationQueue mainQueue]];
    }

    return self;
}

- (void)dealloc {
    [_urlSession finishTasksAndInvalidate];
}

- (void)submitChallengeRequest:(GPTDSChallengeRequestParameters *)request withCompletion:(void (^)(id<GPTDSChallengeResponse> _Nullable, NSError * _Nullable))completion {
    if (_currentTask != nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(nil, [NSError errorWithDomain:GPTDSGuavapay3DS2ErrorDomain
                                                code:GPTDSErrorCodeAssertionFailed
                                            userInfo:@{@"assertion": [NSString stringWithFormat:@"%@ is not intended to handle multiple concurrent tasks.", NSStringFromClass([self class])]}]);
        });
        return;
    }

    NSDictionary *requestJSON = [GPTDSJSONEncoder dictionaryForObject:request];
    NSError *encryptionError = nil;
    NSString *encryptedRequest = [GPTDSJSONWebEncryption directEncryptJSON:requestJSON
                                                 withContentEncryptionKey:_sdkContentEncryptionKey
                                                      forACSTransactionID:_acsTransactionIdentifier
                                                                    error:&encryptionError];

    if (encryptedRequest != nil) {
        NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:_acsURL];
        urlRequest.HTTPMethod = @"POST";
        urlRequest.timeoutInterval = kTimeoutInterval;
        [urlRequest setValue:@"application/jose;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
        __weak __typeof(self) weakSelf = self;
        NSURLSessionUploadTask *requestTask = [_urlSession uploadTaskWithRequest:[urlRequest copy] fromData:[encryptedRequest dataUsingEncoding:NSUTF8StringEncoding] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

            __typeof(self) strongSelf = weakSelf;
            if (strongSelf == nil) {
                return;
            }

            strongSelf->_currentTask = nil;

            if (data != nil) {
                NSError *decryptionError = nil;
                NSDictionary *decrypted = [GPTDSJSONWebEncryption decryptData:data
                                                    withContentEncryptionKey:strongSelf->_acsContentEncryptionKey
                                                                       error:&decryptionError];
                if (decrypted != nil) {
                    NSError *challengeResponseError = nil;
                    id<GPTDSChallengeResponse> response = [strongSelf decodeJSON:decrypted error:&challengeResponseError];
                    completion(response, challengeResponseError);
                } else {
                    completion(nil, decryptionError);
                }
            } else {
                if (error.code == NSURLErrorTimedOut) {
                    // We convert timeout errors for convenience, since the SDK must treat them differently from generic network errors.
                    error = [NSError _gptds_timedOutError];
                }
                completion(nil, error);
            }

        }];
        _currentTask = requestTask;
        [requestTask resume];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(nil, encryptionError);
        });
    }
}

- (void)sendErrorMessage:(GPTDSErrorMessage *)errorMessage {
    NSDictionary *requestJSON = [GPTDSJSONEncoder dictionaryForObject:errorMessage];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:_acsURL];
    urlRequest.HTTPMethod = @"POST";
    [urlRequest setValue:@"application/jose;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    NSURLSessionUploadTask *requestTask = [_urlSession uploadTaskWithRequest:[urlRequest copy]
                                                                    fromData:[NSJSONSerialization dataWithJSONObject:requestJSON options:0 error:nil]
                                                           completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                               // no-op
                                                           }];
    [requestTask resume];
}

#pragma mark - Helpers

/**
 Returns an GPTDSChallengeResponseObject instance decoded from the given dict, or populates the error argument.
 */
- (nullable id<GPTDSChallengeResponse>)decodeJSON:(NSDictionary *)dict error:(NSError * _Nullable *)outError {
    NSString *kErrorMessageType = @"Erro";
    NSString *kChallengeResponseType = @"CRes";
    NSString *messageType = dict[@"messageType"];
    NSError *error;
    id<GPTDSChallengeResponse> decodedObject;
    
    if ([messageType isEqualToString:kErrorMessageType]) {
        // Error message type
        GPTDSErrorMessage *errorMessage = [GPTDSErrorMessage decodedObjectFromJSON:dict error:&error];
        if (errorMessage) {
            error = [NSError errorWithDomain:GPTDSGuavapay3DS2ErrorDomain
                                        code:GPTDSErrorCodeReceivedErrorMessage
                                    userInfo:@{GPTDSGuavapay3DS2ErrorMessageErrorKey: errorMessage}];
        }
    } else if ([messageType isEqualToString:kChallengeResponseType]) {
        // CRes message type
        decodedObject = [GPTDSChallengeResponseObject decodedObjectFromJSON:dict error:&error];
    } else {
        // Unknown message type
        error = [NSError errorWithDomain:GPTDSGuavapay3DS2ErrorDomain
                                    code:GPTDSErrorCodeUnknownMessageType
                                userInfo:nil];
    }
    
    if (error && outError) {
        *outError = error;
    }
    return decodedObject;
}

@end

NS_ASSUME_NONNULL_END
