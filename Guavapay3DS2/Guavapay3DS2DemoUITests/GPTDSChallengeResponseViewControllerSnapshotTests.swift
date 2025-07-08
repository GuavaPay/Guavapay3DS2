//
//  SnapshotTests.swift
//  Guavapay3DS2
//
//  Created by Nikolai Kriuchkov on 16.04.2025.
//

import XCTest
import iOSSnapshotTestCaseCore
@testable import Guavapay3DS2DemoUI

class GPTDSChallengeResponseViewControllerSnapshotTests: FBSnapshotTestCase {

    override func setUp() {
        super.setUp()

        /// Recorded on an iPhone 16 running iOS 18.3.1
        recordMode = false
    }

    func testVerifyTextChallengeDesign() {
        let response = DemoViewController.textChallengeResponse(withWhitelist: false, resendCode: false)
        let vc = challengeResponseViewController(forResponse: response, directoryServer: .custom)
        _ = vc.view
        waitForChallengeResponseTimer()
        snapshotVerifyView(vc.view, identifier: "TextChallengeResponse")
    }

    func testVerifySingleSelectDesign() {
        let response = DemoViewController.singleSelectChallengeResponse()
        let vc = challengeResponseViewController(forResponse: response, directoryServer: .custom)
        _ = vc.view
        waitForChallengeResponseTimer()
        snapshotVerifyView(vc.view, identifier: "SingleSelectResponse")
    }

    func testVerifyMultiSelectDesign() {
        let response = DemoViewController.multiSelectChallengeResponse()
        let vc = challengeResponseViewController(forResponse: response, directoryServer: .custom)
        _ = vc.view
        waitForChallengeResponseTimer()
        snapshotVerifyView(vc.view, identifier: "MultiSelectResponse")
    }

    func testVerifyOOBDesign() {
        let response = DemoViewController.OOBChallengeResponse()
        let vc = challengeResponseViewController(forResponse: response, directoryServer: .custom)
        _ = vc.view
        waitForChallengeResponseTimer()
        snapshotVerifyView(vc.view, identifier: "OOBResponse")
    }

    func testLoadingAmex() {
        let vc = challengeResponseViewController(forResponse: nil, directoryServer: .amex)
        _ = vc.view
        vc.setLoading()
        snapshotVerifyView(vc.view, identifier: "LoadingAmex")
    }

    func testLoadingDiscover() {
        let vc = challengeResponseViewController(forResponse: nil, directoryServer: .discover)
        _ = vc.view
        vc.setLoading()
        snapshotVerifyView(vc.view, identifier: "LoadingDiscover")
    }

    func testLoadingMastercard() {
        let vc = challengeResponseViewController(forResponse: nil, directoryServer: .mastercard)
        _ = vc.view
        vc.setLoading()
        snapshotVerifyView(vc.view, identifier: "LoadingMastercard")
    }

    func testLoadingVisa() {
        let vc = challengeResponseViewController(forResponse: nil, directoryServer: .visa)
        _ = vc.view
        vc.setLoading()
        snapshotVerifyView(vc.view, identifier: "LoadingVisa")
    }

    // MARK: - Helper methods

    func challengeResponseViewController(forResponse response: GPTDSChallengeResponse?, directoryServer: GPTDSDirectoryServer) -> GPTDSChallengeResponseViewController {
        let imageLoader = GPTDSImageLoader(urlSession: URLSession.shared)
        let vc = GPTDSChallengeResponseViewController(
            uiCustomization: GPTDSUICustomization.defaultSettings(),
            imageLoader: imageLoader,
            directoryServer: directoryServer,
            analyticsDelegate: nil
        )
        if let response {
            vc.setChallengeResponse(response, animated: false)
        }
        return vc
    }

    func waitForChallengeResponseTimer() {
        let expectation = self.expectation(description: "Wait for challenge response timer")
        _ = XCTWaiter.wait(for: [expectation], timeout: 2.5)
    }

    func snapshotVerifyView(_ view: UIView, identifier: String) {
        snapshotVerifyViewOrLayer(
            view,
            identifier: identifier,
            suffixes: FBSnapshotTestCaseDefaultSuffixes(),
            perPixelTolerance: 0.02,
            overallTolerance: 0,
            defaultReferenceDirectory: nil,
            defaultImageDiffDirectory: nil
        )
    }
}
