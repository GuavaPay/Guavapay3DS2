//
//  DemoFlowViewController+GPTDSChallengeResponseViewControllerDelegate.swift
//  Guavapay3DS2
//

extension DemoFlowViewController: GPTDSChallengeResponseViewControllerDelegate {
    func challengeResponseViewController(
        _ viewController: GPTDSChallengeResponseViewController,
        didSubmitHTMLForm form: String
    ) {
        viewController.dismiss()
        let message = "HTML Form Submitted!"
        showSnackbar(message)
    }

    func challengeResponseViewController(
        _ viewController: GPTDSChallengeResponseViewController,
        didSubmitInput userInput: String,
        whitelistSelection: GPTDSChallengeResponseSelectionInfo
    ) {
        viewController.dismiss()
        let message = "Input Submitted!"
        showSnackbar(message)
    }

    func challengeResponseViewController(
        _ viewController: GPTDSChallengeResponseViewController,
        didSubmitSelection selection: [GPTDSChallengeResponseSelectionInfo],
        whitelistSelection: GPTDSChallengeResponseSelectionInfo
    ) {
        viewController.dismiss()
        let message = "Selection Submitted!"
        showSnackbar(message)
    }

    func challengeResponseViewControllerDidCancel(
        _ viewController: GPTDSChallengeResponseViewController
    ) {
        viewController.dismiss()
        let message = "Did cancel"
        showSnackbar(message)
        getOrderStatus()
    }

    func challengeResponseViewControllerDidOOBContinue(
        _ viewController: GPTDSChallengeResponseViewController,
        whitelistSelection: GPTDSChallengeResponseSelectionInfo
    ) {
        let message = "OOB Continue"
        showSnackbar(message)
    }

    func challengeResponseViewControllerDidRequestResend(
        _ viewController: GPTDSChallengeResponseViewController
    ) {
        let message = "Resend code requested"
        showSnackbar(message)
    }
}

extension DemoFlowViewController: GPTDSChallengeResponseViewControllerOOBDelegate {
    func challengeResponseViewController(
        _ viewController: GPTDSChallengeResponseViewController,
        didRequestOpenApp oobAppURL: URL
    ) {
        let message = "OOB Open App"
        showSnackbar(message)

        handleURL(oobAppURL)
    }
}
