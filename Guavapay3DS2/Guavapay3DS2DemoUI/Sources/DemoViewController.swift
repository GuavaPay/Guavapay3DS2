//
//  DemoViewController.swift
//  Guavapay3DS2DemoUI
//

import UIKit
import Guavapay3DS2

/// Screen with stubbed UI examples of various challenge types
final class DemoViewController: UIViewController {
    private let imageLoader: GPTDSImageLoader

    private var shouldLoadSlowly: Bool = false
    private var customization: GPTDSUICustomization
    private var isDarkMode: Bool = false
    private var oobContinueState: Bool = false

    private let openFlowButton = UIButton(type: .system)

    init(imageLoader: GPTDSImageLoader) {
        self.imageLoader = imageLoader
        self.customization = GPTDSUICustomization.defaultSettings()
        super.init(nibName: nil, bundle: nil)
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        self.customization.navigationBarCustomization.scrollEdgeAppearance = appearance
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground

        let containerView = GPTDSStackView(alignment: .vertical)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)

        let uiStubLabel = UILabel()
        uiStubLabel.text = "UI Stubs"
        uiStubLabel.textAlignment = .center
        containerView.addArrangedSubview(uiStubLabel)

        let textChallengeActions: [(title: String, action: Selector)] = [
            ("Text Challenge", #selector(presentTextChallenge)),
            ("Text Challenge With Whitelist", #selector(presentTextChallengeWithWhitelist)),
            ("Text Challenge With Resend", #selector(presentTextChallengeWithResendCode)),
            ("Text Challenge With Whitelist and Resend", #selector(presentTextChallengeWithResendCodeAndWhitelist)),
            ("Text Challenge (loads slowly w/ initial progressView)", #selector(presentTextChallengeLoadsSlowly))
        ]

        for buttonInfo in textChallengeActions.sorted(by: { $0.title < $1.title }) {
            let button = UIButton(type: .system)
            button.titleLabel?.numberOfLines = 0
            button.titleLabel?.textAlignment = .center
            button.setTitle(buttonInfo.title, for: .normal)
            button.addTarget(self, action: buttonInfo.action, for: .touchUpInside)
            containerView.addArrangedSubview(button)
        }

        containerView.addSpacer(20)

        let challengeActions: [(title: String, action: Selector)] = [
            ("Single Select Challenge", #selector(presentSingleSelectChallenge)),
            ("Multi Select Challenge", #selector(presentMultiSelectChallenge)),
            ("OOB Challenge", #selector(presentOOBChallenge)),
            ("HTML Challenge", #selector(presentHTMLChallenge)),
            ("Progress View", #selector(presentProgressView))
        ]

        for buttonInfo in challengeActions.sorted(by: { $0.title < $1.title }) {
            let button = UIButton(type: .system)
            button.titleLabel?.numberOfLines = 0
            button.titleLabel?.textAlignment = .center
            button.setTitle(buttonInfo.title, for: .normal)
            button.addTarget(self, action: buttonInfo.action, for: .touchUpInside)
            containerView.addArrangedSubview(button)
        }
        containerView.addSpacer(20)

        let demoFlowLabel = UILabel()
        demoFlowLabel.text = "Demo Flow"
        demoFlowLabel.textAlignment = .center
        containerView.addArrangedSubview(demoFlowLabel)

        openFlowButton.setTitle("Challenge Flow", for: .normal)
        openFlowButton.addTarget(self, action: #selector(openFlow), for: .touchUpInside)
        openFlowButton.backgroundColor = .systemGray5
        openFlowButton.layer.cornerRadius = 8
        openFlowButton.titleLabel?.numberOfLines = 0
        openFlowButton.titleLabel?.textAlignment = .center

        containerView.addSpacer(15)
        containerView.addArrangedSubview(openFlowButton)

        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -16)
        ])
    }

    private func presentChallenge(for challengeResponse: GPTDSChallengeResponse) {
        let challengeResponseViewController = GPTDSChallengeResponseViewController(
            uiCustomization: self.customization,
            imageLoader: self.imageLoader,
            directoryServer: .ulTestEC,
            analyticsDelegate: nil
        )
        challengeResponseViewController.delegate = self
        challengeResponseViewController.oobDelegate = self

        let challengeNavController = UINavigationController(rootViewController: challengeResponseViewController)
        challengeNavController.modalPresentationStyle = .fullScreen
        navigationController?.present(challengeNavController, animated: true, completion: nil)

        challengeResponseViewController.setLoading()
        let delay = self.shouldLoadSlowly ? 5.0 : 0.0
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            challengeResponseViewController.setChallengeResponse(challengeResponse, animated: true)
            self.shouldLoadSlowly = false
        }
    }

    // MARK: - Button Actions

    @objc
    private func presentTextChallenge() {
        let challengeResponse = Self.textChallengeResponse(withWhitelist: false, resendCode: false)
        presentChallenge(for: challengeResponse)
    }

    @objc
    private func presentTextChallengeWithWhitelist() {
        let challengeResponse = Self.textChallengeResponse(withWhitelist: true, resendCode: false)
        presentChallenge(for: challengeResponse)
    }

    @objc
    private func presentTextChallengeWithResendCode() {
        let challengeResponse = Self.textChallengeResponse(withWhitelist: false, resendCode: true)
        presentChallenge(for: challengeResponse)
    }

    @objc
    private func presentTextChallengeWithResendCodeAndWhitelist() {
        let challengeResponse = Self.textChallengeResponse(withWhitelist: true, resendCode: true)
        presentChallenge(for: challengeResponse)
    }

    @objc
    private func presentTextChallengeLoadsSlowly() {
        shouldLoadSlowly = true
        let challengeResponse = Self.textChallengeResponse(withWhitelist: false, resendCode: false)
        presentChallenge(for: challengeResponse)
    }

    @objc
    private func presentSingleSelectChallenge() {
        let challengeResponse = Self.singleSelectChallengeResponse()
        presentChallenge(for: challengeResponse)
    }

    @objc
    private func presentMultiSelectChallenge() {
        let challengeResponse = Self.multiSelectChallengeResponse()
        presentChallenge(for: challengeResponse)
    }

    @objc
    private func presentOOBChallenge() {
        let challengeResponse = Self.OOBChallengeResponse()
        presentChallenge(for: challengeResponse)
    }

    @objc
    private func presentHTMLChallenge() {
        let challengeResponse = Self.HTMLChallengeResponse()
        presentChallenge(for: challengeResponse)
    }

    @objc
    private func presentProgressView() {
        let vc = GPTDSProgressViewController(
            directoryServer: .ulTestEC,
            uiCustomization: self.customization,
            analyticsDelegate: nil
        ) {
            self.dismiss(animated: true, completion: nil)
        }
        let challengeNavController = UINavigationController(rootViewController: vc)
        challengeNavController.modalPresentationStyle = .fullScreen
        navigationController?.present(challengeNavController, animated: true, completion: nil)
    }

    @objc
    private func openFlow() {
        let flowVC = DemoFlowViewController()
        navigationController?.pushViewController(flowVC, animated: true)
    }
}

// MARK: - GPTDSChallengeResponseViewControllerDelegate

extension DemoViewController: GPTDSChallengeResponseViewControllerDelegate {

    func challengeResponseViewController(
        _ viewController: GPTDSChallengeResponseViewController,
        didSubmitHTMLForm form: String
    ) {
        viewController.dismiss()
        let message = "HTML Submitted: \(form)"
        showSnackbar(message)
    }

    func challengeResponseViewController(
        _ viewController: GPTDSChallengeResponseViewController,
        didSubmitInput userInput: String,
        whitelistSelection: GPTDSChallengeResponseSelectionInfo
    ) {
        viewController.dismiss()
        let message = "Input Submitted: \(userInput)"
        showSnackbar(message)
    }

    func challengeResponseViewController(
        _ viewController: GPTDSChallengeResponseViewController,
        didSubmitSelection selection: [GPTDSChallengeResponseSelectionInfo],
        whitelistSelection: GPTDSChallengeResponseSelectionInfo
    ) {
        viewController.dismiss()
        let message = "Selection Submitted: \(selection)"
        showSnackbar(message)
    }

    func challengeResponseViewControllerDidCancel(
        _ viewController: GPTDSChallengeResponseViewController
    ) {
        viewController.dismiss()
        let message = "Did cancel"
        showSnackbar(message)
    }

    func challengeResponseViewControllerDidOOBContinue(
        _ viewController: GPTDSChallengeResponseViewController,
        whitelistSelection: GPTDSChallengeResponseSelectionInfo
    ) {
        let message = "OOB Continue"
        showSnackbar(message)

        viewController.setLoading()

        oobContinueState.toggle()
        if oobContinueState {
            viewController.setChallengeResponse(Self.OOBChallengeContinueResponse(), animated: true)
        } else {
            viewController.setChallengeResponse(Self.OOBChallengeResponse(), animated: true)
        }
    }

    func challengeResponseViewControllerDidRequestResend(
        _ viewController: GPTDSChallengeResponseViewController
    ) {
        let message = "Resend code requested"
        showSnackbar(message)
    }
}

extension DemoViewController: GPTDSChallengeResponseViewControllerOOBDelegate {
    func challengeResponseViewController(
        _ viewController: GPTDSChallengeResponseViewController,
        didRequestOpenApp oobAppURL: URL
    ) {
        let message = "OOB Open App"
        showSnackbar(message)

        guard UIApplication.shared.canOpenURL(oobAppURL) else {
            return
        }

        UIApplication.shared.open(oobAppURL)
    }
}
