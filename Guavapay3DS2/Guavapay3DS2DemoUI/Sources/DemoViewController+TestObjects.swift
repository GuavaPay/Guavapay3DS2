//
//  GPTDSChallengeResponseObject+TestObjects.m
//  Guavapay3DS2DemoUI
//

import Foundation
import Guavapay3DS2

// swiftlint:disable line_length

extension DemoViewController {
    static func textChallengeResponse(withWhitelist whitelist: Bool, resendCode: Bool) -> GPTDSChallengeResponse {
        GPTDSChallengeResponseObject(
            threeDSServerTransactionID: "",
            acsCounterACStoSDK: "",
            acsTransactionID: "",
            acsHTML: nil,
            acsHTMLRefresh: nil,
            acsUIType: .text,
            challengeCompletionIndicator: false,
            challengeInfoHeader: "Purchase Authentication",
            challengeInfoLabel: "Enter your code",
            challengeInfoText: "Enter the code sent to your phone number +1 234 *** *89",
            challengeAdditionalInfoText: nil,
            showChallengeInfoTextIndicator: false,
            challengeSelectInfo: nil,
            expandInfoLabel: "Need some help",
            expandInfoText: "This field displays expandable information text provided by the ACS.",
            issuerImage: issuerImage(),
            messageExtensions: nil,
            messageVersion: "",
            oobAppURL: nil,
            oobAppLabel: nil,
            oobContinueLabel: nil,
            paymentSystemImage: paymentImage(),
            resendInformationLabel: resendCode ? "Resend code" : nil,
            sdkTransactionID: "",
            submitAuthenticationLabel: "Confirm",
            whitelistingInfoText: whitelist ? "Would you like to add this Merchant to your whitelist?" : nil,
            whyInfoLabel: "Learn more about authentication",
            whyInfoText: "This is additional information about authentication. You are being provided extra information you wouldn't normally see, because you've tapped on the above label.",
            transactionStatus: nil
        )
    }

    static func singleSelectChallengeResponse() -> GPTDSChallengeResponse {
        let infoObject1 = GPTDSChallengeResponseSelectionInfoObject(name: "Text Message", value: "(123) ***-**12")
        let infoObject2 = GPTDSChallengeResponseSelectionInfoObject(name: "Email", value: "a***b@example.com")
        return GPTDSChallengeResponseObject(
            threeDSServerTransactionID: "",
            acsCounterACStoSDK: "",
            acsTransactionID: "",
            acsHTML: nil,
            acsHTMLRefresh: nil,
            acsUIType: .singleSelect,
            challengeCompletionIndicator: false,
            challengeInfoHeader: "Get verification code",
            challengeInfoLabel: nil,
            challengeInfoText: "For added security, Digital Bank will send you a one-time code. Choose how to receive your code:",
            challengeAdditionalInfoText: nil,
            showChallengeInfoTextIndicator: false,
            challengeSelectInfo: [infoObject1, infoObject2],
            expandInfoLabel: "Need some help?",
            expandInfoText: "You've indicated that you need help! We'd be happy to assist with that, by providing helpful text here that makes sense in context.",
            issuerImage: issuerImage(),
            messageExtensions: nil,
            messageVersion: "",
            oobAppURL: nil,
            oobAppLabel: nil,
            oobContinueLabel: nil,
            paymentSystemImage: paymentImage(),
            resendInformationLabel: nil,
            sdkTransactionID: "",
            submitAuthenticationLabel: "Next",
            whitelistingInfoText: nil,
            whyInfoLabel: "Learn more about authentication",
            whyInfoText: "This is additional information about authentication. You are being provided extra information you wouldn't normally see, because you've tapped on the above label.",
            transactionStatus: nil
        )
    }

    static func multiSelectChallengeResponse() -> GPTDSChallengeResponse {
        let infoObject1 = GPTDSChallengeResponseSelectionInfoObject(name: "Option1", value: "Chicago, Illinois")
        let infoObject2 = GPTDSChallengeResponseSelectionInfoObject(name: "Option2", value: "Portland, Oregon")
        let infoObject3 = GPTDSChallengeResponseSelectionInfoObject(name: "Option3", value: "Dallas, Texas")
        let infoObject4 = GPTDSChallengeResponseSelectionInfoObject(name: "Option4", value: "St Louis, Missouri")
        return GPTDSChallengeResponseObject(
            threeDSServerTransactionID: "",
            acsCounterACStoSDK: "",
            acsTransactionID: "",
            acsHTML: nil,
            acsHTMLRefresh: nil,
            acsUIType: .multiSelect,
            challengeCompletionIndicator: false,
            challengeInfoHeader: "Verify your payment",
            challengeInfoLabel: "Question 2\nWhat cities have you lived in?",
            challengeInfoText: "Please answer 3 security questions from YourBank to complete your payment.\n\nSelect all that apply",
            challengeAdditionalInfoText: nil,
            showChallengeInfoTextIndicator: false,
            challengeSelectInfo: [infoObject1, infoObject2, infoObject3, infoObject4],
            expandInfoLabel: nil,
            expandInfoText: nil,
            issuerImage: issuerImage(),
            messageExtensions: nil,
            messageVersion: "",
            oobAppURL: nil,
            oobAppLabel: nil,
            oobContinueLabel: nil,
            paymentSystemImage: paymentImage(),
            resendInformationLabel: nil,
            sdkTransactionID: "",
            submitAuthenticationLabel: "Next",
            whitelistingInfoText: nil,
            whyInfoLabel: "Learn more about authentication",
            whyInfoText: "This is additional information about authentication. You are being provided extra information you wouldn't normally see, because you've tapped on the above label.",
            transactionStatus: nil
        )
    }

    static func OOBChallengeResponse() -> GPTDSChallengeResponse {
        GPTDSChallengeResponseObject(
            threeDSServerTransactionID: "",
            acsCounterACStoSDK: "",
            acsTransactionID: "",
            acsHTML: nil,
            acsHTMLRefresh: nil,
            acsUIType: .OOB,
            challengeCompletionIndicator: false,
            challengeInfoHeader: "Payment Security",
            challengeInfoLabel: nil,
            challengeInfoText: "For added security, you will be authenticated with YourBank application.\n\nStep 1 - Open your YourBank application directly from your phone and verify this payment.\n\nStep 2 - Tap continue after you have completed authentication with your YourBank application.",
            challengeAdditionalInfoText: nil,
            showChallengeInfoTextIndicator: false,
            challengeSelectInfo: nil,
            expandInfoLabel: nil,
            expandInfoText: nil,
            issuerImage: issuerImage(),
            messageExtensions: nil,
            messageVersion: "",
            oobAppURL: URL(string: "https://myguava.com/app/transfers/oob_confirm?operationId=f1802bdd-f3c9-4483-b3f7-8198bee734b4"),
            oobAppLabel: "Confirm in MyGuava",
            oobContinueLabel: nil,
            paymentSystemImage: paymentImage(),
            resendInformationLabel: nil,
            sdkTransactionID: "",
            submitAuthenticationLabel: nil,
            whitelistingInfoText: nil,
            whyInfoLabel: nil,
            whyInfoText: nil,
            transactionStatus: nil
        )
    }

    static func OOBChallengeContinueResponse() -> GPTDSChallengeResponse {
        GPTDSChallengeResponseObject(
            threeDSServerTransactionID: "",
            acsCounterACStoSDK: "",
            acsTransactionID: "",
            acsHTML: nil,
            acsHTMLRefresh: nil,
            acsUIType: .OOB,
            challengeCompletionIndicator: false,
            challengeInfoHeader: "Payment Security",
            challengeInfoLabel: nil,
            challengeInfoText: "For added security, you will be authenticated with YourBank application.\n\nStep 1 - Open your YourBank application directly from your phone and verify this payment.\n\nStep 2 - Tap continue after you have completed authentication with your YourBank application.",
            challengeAdditionalInfoText: nil,
            showChallengeInfoTextIndicator: true,
            challengeSelectInfo: nil,
            expandInfoLabel: nil,
            expandInfoText: nil,
            issuerImage: issuerImage(),
            messageExtensions: messageExtension(),
            messageVersion: "",
            oobAppURL: nil,
            oobAppLabel: nil,
            oobContinueLabel: "Continue",
            paymentSystemImage: paymentImage(),
            resendInformationLabel: nil,
            sdkTransactionID: "",
            submitAuthenticationLabel: nil,
            whitelistingInfoText: nil,
            whyInfoLabel: nil,
            whyInfoText: nil,
            transactionStatus: nil
        )
    }

    static func HTMLChallengeResponse() -> GPTDSChallengeResponse {
        let htmlFilePath = Bundle.main.path(forResource: "acs_challenge", ofType: "html") ?? ""
        let html = try? String(contentsOfFile: htmlFilePath, encoding: .utf8)
        return GPTDSChallengeResponseObject(
            threeDSServerTransactionID: "",
            acsCounterACStoSDK: "",
            acsTransactionID: "",
            acsHTML: html,
            acsHTMLRefresh: nil,
            acsUIType: .HTML,
            challengeCompletionIndicator: false,
            challengeInfoHeader: nil,
            challengeInfoLabel: nil,
            challengeInfoText: nil,
            challengeAdditionalInfoText: nil,
            showChallengeInfoTextIndicator: false,
            challengeSelectInfo: nil,
            expandInfoLabel: nil,
            expandInfoText: nil,
            issuerImage: nil,
            messageExtensions: nil,
            messageVersion: "",
            oobAppURL: nil,
            oobAppLabel: nil,
            oobContinueLabel: nil,
            paymentSystemImage: nil,
            resendInformationLabel: nil,
            sdkTransactionID: "",
            submitAuthenticationLabel: nil,
            whitelistingInfoText: nil,
            whyInfoLabel: nil,
            whyInfoText: nil,
            transactionStatus: nil
        )
    }

    // MARK: - Private Helpers

    private static func issuerImage() -> GPTDSChallengeResponseImage? {
        GPTDSChallengeResponseImageObject(
            mediumDensityURL: Bundle.main.url(forResource: "150-issuer", withExtension: "png"),
            highDensityURL: Bundle.main.url(forResource: "300-issuer", withExtension: "png"),
            extraHighDensityURL: Bundle.main.url(forResource: "450-issuer", withExtension: "png")
        )
    }

    private static func paymentImage() -> GPTDSChallengeResponseImage? {
        GPTDSChallengeResponseImageObject(
            mediumDensityURL: Bundle.main.url(forResource: "150-payment", withExtension: "png"),
            highDensityURL: Bundle.main.url(forResource: "300-payment", withExtension: "png"),
            extraHighDensityURL: Bundle.main.url(forResource: "450-payment", withExtension: "png")
        )
    }

    private static func messageExtension() -> [GPTDSChallengeResponseMessageExtension] {
        [
            try! GPTDSChallengeResponseMessageExtensionObject.decodedObject(fromJSON: messageExtensionJSON())
        ]
    }

    private static func messageExtensionJSON() -> [AnyHashable: Any] {
        [
                "name": "Bridging",
                "id": "A000000802-004",
                "criticalityIndicator": false,
                "version": "1.0",
                "data": [
                    "challengeData": [
                        "oobContinue": "02"
                    ]
                ]
        ]
    }
}

// swiftlint:enable line_length
