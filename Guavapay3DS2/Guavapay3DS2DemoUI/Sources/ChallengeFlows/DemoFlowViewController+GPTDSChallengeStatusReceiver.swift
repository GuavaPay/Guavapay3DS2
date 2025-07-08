//
//  DemoFlowViewController+GPTDSChallengeStatusReceiver.swift
//  Guavapay3DS2
//

extension DemoFlowViewController: GPTDSChallengeStatusReceiver {
    func transaction(_ transaction: GPTDSTransaction, didCompleteChallengeWith completionEvent: GPTDSCompletionEvent) {
        let message = "transaction completed challenge: \(completionEvent.transactionStatus)"
        showSnackbar(message)
        pollOrderStatus()
        navigationController?.dismiss(animated: true, completion: nil)
    }

    func transaction(_ transaction: GPTDSTransaction, didErrorWith protocolErrorEvent: GPTDSProtocolErrorEvent) {
        let errorCode = protocolErrorEvent.errorMessage.errorCode
        let errorDetails = protocolErrorEvent.errorMessage.errorDetails ?? ""
        let message = "transaction P error: \(errorCode) \(errorDetails)"
        showError(.custom(message), source: .postExecute)
        navigationController?.dismiss(animated: true, completion: nil)
    }

    func transaction(_ transaction: GPTDSTransaction, didErrorWith runtimeErrorEvent: GPTDSRuntimeErrorEvent) {
        let message = "transaction RT error: \(runtimeErrorEvent.errorMessage)"
        showError(.custom(message))
        navigationController?.dismiss(animated: true, completion: nil)
    }

    func transactionDidCancel(_ transaction: GPTDSTransaction) {
        let message = "transaction cancelled"
        showSnackbar(message)
    }

    func transactionDidTimeOut(_ transaction: GPTDSTransaction) {
        let message = "transaction timed out"
        showError(.custom(message))
    }
}
