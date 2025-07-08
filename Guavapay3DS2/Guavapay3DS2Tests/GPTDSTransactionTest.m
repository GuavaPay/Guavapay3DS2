//
//  GPTDSTransactionTest.m
//  Guavapay3DS2Tests
//

#import <XCTest/XCTest.h>

#import "GPTDSTransaction+Private.h"
#import "GPTDSInvalidInputException.h"
#import "GPTDSChallengeParameters.h"
#import "GPTDSChallengeStatusReceiver.h"
#import "GPTDSRuntimeErrorEvent.h"
#import "GPTDSProtocolErrorEvent.h"
#import "GPTDSGuavapay3DS2Error.h"
#import "GPTDSTransaction.h"
#import "GPTDSErrorMessage.h"
#import "NSError+Guavapay3DS2.h"

@interface GPTDSTransaction (Private)
@property (nonatomic, weak) id<GPTDSChallengeStatusReceiver> challengeStatusReceiver;

- (void)_handleError:(NSError *)error;
- (NSString *)_sdkAppIdentifier;
@end

@interface GPTDSTransactionTest : XCTestCase <GPTDSChallengeStatusReceiver>
@property (nonatomic, copy) void (^didErrorWithProtocolErrorEvent)(GPTDSProtocolErrorEvent *);
@property (nonatomic, copy) void (^didErrorWithRuntimeErrorEvent)(GPTDSRuntimeErrorEvent *);
@end

@implementation GPTDSTransactionTest

- (void)tearDown {
    self.didErrorWithRuntimeErrorEvent = nil;
    self.didErrorWithProtocolErrorEvent = nil;
    [super tearDown];
}

#pragma mark - Timeout

- (void)testTimeoutBelow5Throws {
    GPTDSTransaction *transaction = [GPTDSTransaction new];
    GPTDSChallengeParameters *challengeParameters = [[GPTDSChallengeParameters alloc] init];
    XCTAssertThrowsSpecific([transaction doChallengeWithViewController:[UIViewController new]
                                                   challengeParameters:challengeParameters
                                                     messageExtensions:nil
                                               challengeStatusReceiver:self
                                                           oobDelegate:nil
                                                               timeout:4 * 60], GPTDSInvalidInputException);
}

- (void)testTimeoutFires {
    GPTDSTransaction *transaction = [GPTDSTransaction new];
    GPTDSChallengeParameters *challengeParameters = [[GPTDSChallengeParameters alloc] init];
    
    // Assert timer is scheduled to fire 5 minutes from now, give or take 1 second
    NSInteger timeout = 300;
    [transaction doChallengeWithViewController:[UIViewController new]
                           challengeParameters:challengeParameters
                             messageExtensions:nil
                       challengeStatusReceiver:self
                                   oobDelegate:nil
                                       timeout:timeout];
    XCTAssertTrue(transaction.timeoutTimer.isValid);
    NSTimeInterval secondsIntoTheFutureTimerWillFire = [transaction.timeoutTimer.fireDate timeIntervalSinceNow];
    XCTAssertLessThanOrEqual(fabs(secondsIntoTheFutureTimerWillFire - (timeout)), 1);
}

#pragma mark - Error Handling

- (void)testHandleUnknownMessageTypeError {
    NSError *error = [NSError errorWithDomain:GPTDSGuavapay3DS2ErrorDomain code:GPTDSErrorCodeUnknownMessageType userInfo:nil];
    [self _expectProtocolErrorEventForError:error validator:^(GPTDSProtocolErrorEvent *protocolErrorEvent) {
        XCTAssertEqualObjects(protocolErrorEvent.errorMessage.errorCode, @"101");
    }];
}

- (void)testHandleInvalidJSONError {
    NSError *error = [NSError _gptds_invalidJSONFieldError:@"invalid field"];
    [self _expectProtocolErrorEventForError:error validator:^(GPTDSProtocolErrorEvent *protocolErrorEvent) {
        XCTAssertEqualObjects(protocolErrorEvent.errorMessage.errorCode, @"203");
        XCTAssertEqualObjects(protocolErrorEvent.errorMessage.errorDetails, @"invalid field");
    }];
}

- (void)testHandleMissingJSONError {
    NSError *error = [NSError _gptds_missingJSONFieldError:@"missing field"];
    [self _expectProtocolErrorEventForError:error validator:^(GPTDSProtocolErrorEvent *protocolErrorEvent) {
        XCTAssertEqualObjects(protocolErrorEvent.errorMessage.errorCode, @"201");
        XCTAssertEqualObjects(protocolErrorEvent.errorMessage.errorDetails, @"missing field");
    }];
}

- (void)testHandleReceivedErrorMessage {
    GPTDSErrorMessage *receivedErrorMessage = [[GPTDSErrorMessage alloc] initWithErrorCode:@"" errorComponent:@"" errorDescription:@"" errorDetails:nil messageVersion:@"" acsTransactionIdentifier:@"" errorMessageType:@""];
    NSError *error = [NSError errorWithDomain:GPTDSGuavapay3DS2ErrorDomain
                                         code:GPTDSErrorCodeReceivedErrorMessage
                                     userInfo:@{GPTDSGuavapay3DS2ErrorMessageErrorKey: receivedErrorMessage}];

    [self _expectProtocolErrorEventForError:error validator:^(GPTDSProtocolErrorEvent *protocolErrorEvent) {
        XCTAssertEqualObjects(protocolErrorEvent.errorMessage, receivedErrorMessage);
    }];
}

- (void)testHandleNetworkConnectionLostError {
    NSError *error = [NSError errorWithDomain:NSURLErrorDomain
                                         code:NSURLErrorNetworkConnectionLost
                                     userInfo:nil];
    [self _expectRuntimeErrorEventForError:error validator:^(GPTDSRuntimeErrorEvent *runtimeErrorEvent) {
        XCTAssertEqualObjects(runtimeErrorEvent.errorCode, [@(NSURLErrorNetworkConnectionLost) stringValue]);
    }];
}

- (void)_expectProtocolErrorEventForError:(NSError *)error validator:(void (^)(GPTDSProtocolErrorEvent *))protocolErrorEventChecker {
    GPTDSTransaction *transaction = [GPTDSTransaction new];
    transaction.challengeStatusReceiver = self;
    XCTestExpectation *expectation = [self expectationWithDescription:@"Call didErrorWithProtocolErrorEvent"];
    self.didErrorWithProtocolErrorEvent = ^(GPTDSProtocolErrorEvent *protocolErrorEvent) {
        protocolErrorEventChecker(protocolErrorEvent);
        [expectation fulfill];
    };
    [transaction _handleError:error];
    [self waitForExpectationsWithTimeout:1 handler:nil];
}

- (void)_expectRuntimeErrorEventForError:(NSError *)error validator:(void (^)(GPTDSRuntimeErrorEvent *))runtimeErrorEventChecker {
    GPTDSTransaction *transaction = [GPTDSTransaction new];
    transaction.challengeStatusReceiver = self;
    XCTestExpectation *expectation = [self expectationWithDescription:@"Call didErrorWithRuntimeErrorEvent"];
    self.didErrorWithRuntimeErrorEvent = ^(GPTDSRuntimeErrorEvent *runtimeErrorEvent) {
        runtimeErrorEventChecker(runtimeErrorEvent);
        [expectation fulfill];
    };
    [transaction _handleError:error];
    [self waitForExpectationsWithTimeout:1 handler:nil];
}

#pragma mark - GPTDSChallengeStatusReceiver

- (void)transaction:(nonnull GPTDSTransaction *)transaction didCompleteChallengeWithCompletionEvent:(nonnull GPTDSCompletionEvent *)completionEvent {}

- (void)transaction:(nonnull GPTDSTransaction *)transaction didErrorWithProtocolErrorEvent:(nonnull GPTDSProtocolErrorEvent *)protocolErrorEvent {
    if (self.didErrorWithProtocolErrorEvent) {
        self.didErrorWithProtocolErrorEvent(protocolErrorEvent);
    }
}

- (void)transaction:(nonnull GPTDSTransaction *)transaction didErrorWithRuntimeErrorEvent:(nonnull GPTDSRuntimeErrorEvent *)runtimeErrorEvent {
    if (self.didErrorWithRuntimeErrorEvent) {
        self.didErrorWithRuntimeErrorEvent(runtimeErrorEvent);
    }
}

- (void)transactionDidCancel:(nonnull GPTDSTransaction *)transaction {}

- (void)transactionDidTimeOut:(nonnull GPTDSTransaction *)transaction {}

@end
