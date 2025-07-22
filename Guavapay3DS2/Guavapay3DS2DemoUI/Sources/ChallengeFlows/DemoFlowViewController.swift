//
//  DemoFlowViewController.swift
//  Guavapay3DS2
//

import UIKit
import Guavapay3DS2

final class DemoFlowViewController: UIViewController {
    private let contentView = DemoFlowView()
    private let threeDSService = GPTDSThreeDS2Service()

    private var orderId: String?
    private var sessionToken: String?
    private var messageVersion: String?
    private var directoryServerID: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])

        contentView.postOrderButton.addTarget(target, action: #selector(postOrderRequest), for: .touchUpInside)
        contentView.putPaymentButton.addTarget(target, action: #selector(putPaymentRequest), for: .touchUpInside)
        contentView.postExecuteButton.addTarget(target, action: #selector(postExecuteRequest), for: .touchUpInside)
        contentView.getOrderButton.addTarget(target, action: #selector(getOrderRequest), for: .touchUpInside)

        setupTDSService()
    }

    /// Fetch payment order status without polling
    func getOrderStatus() {
        contentView.hideLoading()
        getOrderStatus(withPolling: false)
    }

    /// Fetch payment order status with polling
    func pollOrderStatus() {
        contentView.hideLoading()
        getOrderStatus(withPolling: true)
    }

    /// Show error message for error message and provided flow step
    /// - Parameters:
    ///   - errorType: error type
    ///   - source: current flow step
    func showError(_ errorType: ErrorType, source: Step? = nil) {
        let message = errorType.message
        print("Error: \(message) at step \(String(describing: source))")
        DispatchQueue.main.async { [weak self] in
            self?.showSnackbar(message, isError: true)
            self?.contentView.showError(message: message, source: source)
            self?.contentView.hideLoading()
        }
    }

    // MARK: - Private Methods

    /// Setup 3DS service that will be used to create transactions
    private func setupTDSService() {
        let config = GPTDSConfigParameters()
        // Customize 3DS service configuration for test mode if needed
        // config.addParameterNamed(_ paramName: String, withValue: String)

        let customization = GPTDSUICustomization()
        // Customize UI for test mode if needed. But it should be fetched from backend
        // customization.labelCustomization.headingFont = ...
        //
        // Check "GPTDSUICustomization.h" for details

        threeDSService.initialize(
            withConfig: config,
            locale: .current,
            uiSettings: customization
        )
    }

    /// Save `orderId` to use with next requests
    private func handlePostOrderRequest(_ response: PostOrderDTO) {
        orderId = response.order.id
        sessionToken = response.order.sessionToken
        messageVersion = nil
        directoryServerID = nil

        contentView.postOrderLabel.text = "Order ID: \(response.order.id)"
        contentView.configure(for: .postOrder)

        showSnackbar(contentView.postOrderLabel.text)
    }

    /// Save `messageVersion` and `directoryServerID` to create real transaction
    private func handlePutPaymentRequest(_ response: PutPaymentDTO) {
        messageVersion = response.requirements.threedsSdkCreateTransaction.messageVersion
        directoryServerID = response.requirements.threedsSdkCreateTransaction.directoryServerID

        contentView.putPaymentLabel.text = "Payment: \(messageVersion ?? "") | \(directoryServerID ?? "")"
        contentView.configure(for: .putPayment)
    }

    /// Create `challengeParameters` from `packedSdkChallengeParameters` of response
    /// Call challenge on real transaction providing `challengeParameters`, view controller and challenge delegates
    private func handlePostExecuteRequest(_ response: PostExecuteDTO, transaction: GPTDSTransaction) {
        let appUrl = Constants.redirectUrl

        guard let packedSDK = response.requirements.threedsChallenge?.packedSdkChallengeParameters,
              let challengeParameters = GPTDSChallengeParameters(
                packedSDKString: packedSDK,
                requestorAppURL: appUrl
              ) else {
            showError(.invalidBase64String, source: .postExecute)
            return
        }

        contentView.postExecuteLabel.text = "3DSServerTransID: \(challengeParameters.threeDSServerTransactionID)"

        // - Setting Root Certs to transaction from JWT header
        // ! For test only !
        // Will be removed after certification and replaced with built-in ones
        guard let x5cArray = extractX5C(from: challengeParameters.acsSignedContent), !x5cArray.isEmpty else {
            showError(.noRootCertificates, source: .postExecute)
            return
        }

        let certificateString = x5cArray[0]
        let rootCertificateStrings = Array(x5cArray.dropFirst())

        transaction.setCertificatesWithCustomCertificate(certificateString, rootCertificates: rootCertificateStrings)
        // - Setting Root Certs to transaction from header

        transaction.doChallenge(
            with: self,
            challengeParameters: challengeParameters,
            messageExtensions: nil,
            challengeStatusReceiver: self,
            oobDelegate: self,
            timeout: 5 * 60
        )
    }

    /// Show payment order status
    private func handleGetOrderRequest(_ response: GetOrderDTO) {
        contentView.getOrderLabel.text = "Status: \(response.order?.status?.rawValue ?? "")"
        contentView.hideLoading()

        showSnackbar(contentView.getOrderLabel.text)
    }

    /// Fetch order payment status with/without polling
    private func getOrderStatus(withPolling: Bool, attempt: Int = 0, delay: TimeInterval = 1) {
        guard let orderId,
              let sessionToken,
              let url = URL(string: Constants.urlBase + "/\(orderId)") else {
            showError(.invalidRequestData, source: .postOrder)
            return
        }

        let maxAttempts = 9
        let delayFactor = 1.5

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(sessionToken)", forHTTPHeaderField: "Authorization")
        request.setValue(Constants.contentType, forHTTPHeaderField: "Content-Type")
        request.setValue(Constants.tenantId, forHTTPHeaderField: "Tenant-ID")
        request.setValue(Constants.requestId, forHTTPHeaderField: "Request-ID")

        contentView.showLoading(.getOrder)

        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let error {
                self?.showError(.responseError(error), source: .postOrder)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, let data else {
                self?.showError(.invalidResponse, source: .postOrder)
                return
            }

            switch httpResponse.statusCode {
            case 200:
                do {
                    let response = try JSONDecoder.isoDateDecoder.decode(GetOrderDTO.self, from: data)
                    guard withPolling else {
                        DispatchQueue.main.async {
                            self?.handleGetOrderRequest(response)
                        }
                        return
                    }

                    if response.order?.status == .created, attempt < maxAttempts {
                        let newDelay = delay * delayFactor
                        DispatchQueue.main.asyncAfter(deadline: .now() + newDelay) {
                            self?.showSnackbar("POLLED status \(attempt) - \(newDelay)s")
                            self?.getOrderStatus(withPolling: true, attempt: attempt + 1, delay: newDelay)
                        }
                    } else {
                        if attempt < maxAttempts {
                            DispatchQueue.main.async {
                                self?.handleGetOrderRequest(response)
                            }
                        } else {
                            self?.showError(.pollingTimedOut, source: .getOrder)
                        }
                    }
                } catch {
                    self?.showError(.decodingError(error), source: .getOrder)
                }
            default:
                self?.showError(.requestError(code: "\(httpResponse.statusCode)"), source: .getOrder)
            }
        }
        task.resume()
    }

    /// Create order with provided purchase amount and currency
    /// `Response` - `orderId` for next requests
    @objc
    private func postOrderRequest() {
        guard let url = URL(string: Constants.urlBase),
              let amount = contentView.paymentDetailsView.amount,
              let currency = contentView.paymentDetailsView.currency else {
            showError(.invalidRequestData, source: .postOrder)
            return
        }

        let json: [String: Any] = [
            "purpose": "PURCHASE",
            "referenceNumber": UUID().uuidString,
            "totalAmount": ["baseUnits": amount, "currency": currency],
            "availablePaymentMethods": ["PAYMENT_CARD"],
            "payer": ["contactEmail": "example@guavapay.com"]
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(Constants.initialBearerToken)", forHTTPHeaderField: "Authorization")
        request.setValue(Constants.contentType, forHTTPHeaderField: "Content-Type")
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: json, options: [])
        } catch {
            showError(.encodingError(error), source: .postOrder)
            return
        }

        contentView.showLoading(.postOrder)

        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            self?.printDebug(data: data, response: response)

            if let error {
                self?.showError(.responseError(error), source: .postOrder)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, let data else {
                self?.showError(.noHTTPResponse, source: .postOrder)
                return
            }

            switch httpResponse.statusCode {
            case 201:
                do {
                    let response = try JSONDecoder.isoDateDecoder.decode(PostOrderDTO.self, from: data)
                    DispatchQueue.main.async {
                        self?.handlePostOrderRequest(response)
                    }
                } catch {
                    self?.showError(.decodingError(error), source: .postOrder)
                }
            case 400:
                do {
                    let response = try JSONDecoder.isoDateDecoder.decode(ExecuteErrorDTO.self, from: data)
                    self?.showError(
                        .requestError(code: response.code, message: response.message),
                        source: .postOrder
                    )
                } catch {
                    self?.showError(.decodingError(error), source: .postOrder)
                }
            default:
                self?.showError(.requestError(code: "\(httpResponse.statusCode)"), source: .postOrder)
            }
        }
        task.resume()
    }

    /// Provide payment method details and `packedSdkData` from disposable transaction
    /// `Response` - `messageVersion` and `directoryServerID`
    @objc
    private func putPaymentRequest() {
        guard let pan = contentView.cardFormView.pan,
              let month = contentView.cardFormView.expiryMonth,
              let year = contentView.cardFormView.expiryYear,
              let cvcString = contentView.cardFormView.cvc,
              let cvv2 = Int(cvcString) else {
            showError(.invalidRequestData, source: .putPayment)
            return
        }

        let expiryDate = "\(year)\(month)"

        guard let orderId,
              let sessionToken,
              let url = URL(string: Constants.urlBase + "/\(orderId)/payment") else {
            showError(.invalidRequestData, source: .putPayment)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("Bearer \(sessionToken)", forHTTPHeaderField: "Authorization")
        request.setValue(Constants.contentType, forHTTPHeaderField: "Content-Type")
        request.setValue(Constants.tenantId, forHTTPHeaderField: "Tenant-ID")
        request.setValue(Constants.requestId, forHTTPHeaderField: "Request-ID")

        let orderDetails = Constants.orderDetails(
            pan: pan,
            cvv2: cvv2,
            expiryDate: expiryDate,
            packedSdkDataString: nil
        )

        do {
            let orderDetailsData = try JSONSerialization.data(withJSONObject: orderDetails, options: [])
            request.httpBody = orderDetailsData
        } catch {
            showError(.encodingError(error), source: .putPayment)
            return
        }

        contentView.showLoading(.putPayment)

        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            self?.printDebug(data: data, response: response)

            if let error {
                self?.showError(.responseError(error), source: .putPayment)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, let data else {
                self?.showError(.noHTTPResponse, source: .putPayment)
                return
            }

            switch httpResponse.statusCode {
            case 202:
                do {
                    let response = try JSONDecoder.isoDateDecoder.decode(PutPaymentDTO.self, from: data)
                    DispatchQueue.main.async {
                        self?.handlePutPaymentRequest(response)
                    }
                } catch {
                    self?.showError(.decodingError(error), source: .putPayment)
                }
            case 400:
                let response = try? JSONDecoder.isoDateDecoder.decode(ExecuteErrorDTO.self, from: data)
                self?.showError(
                    .requestError(code: "\(response?.code ?? "no code")", message: response?.message ?? ""),
                    source: .putPayment
                )
            default:
                self?.showError(.requestError(code: "\(httpResponse.statusCode)"), source: .putPayment)
            }
        }
        task.resume()
    }

    /// Use `messageVersion` and `directoryServerID` to create real transaction.
    /// Payment execution with payment method details, `orderId` and `packedSdkData`
    /// `Response` - challenge details if needed
    @objc
    private func postExecuteRequest() {
        guard let pan = contentView.cardFormView.pan,
              let month = contentView.cardFormView.expiryMonth,
              let year = contentView.cardFormView.expiryYear,
              let cvcString = contentView.cardFormView.cvc,
              let cvv2 = Int(cvcString),
              let directoryServerID else {
            showError(.invalidRequestData, source: .postExecute)
            return
        }

        let transaction = threeDSService.createTransaction(
            forDirectoryServer: directoryServerID,
            withProtocolVersion: messageVersion
        )

        let packedSdkData = transaction.createAuthenticationRequestParameters()
        let packedSdkDataJsonDict = GPTDSJSONEncoder.dictionary(forObject: packedSdkData)

        guard let packedSdkDataJsonData = try? JSONSerialization.data(
            withJSONObject: packedSdkDataJsonDict,
            options: []
        ) else {
            return
        }

        let packedSdkDataString = packedSdkDataJsonData.base64URLEncodedString()

        guard let orderId,
              let sessionToken,
              let packedSdkDataString,
              let url = URL(string: Constants.urlBase + "/\(orderId)/payment/execute") else {
            showError(.invalidRequestData, source: .postExecute)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(sessionToken)", forHTTPHeaderField: "Authorization")
        request.setValue(Constants.contentType, forHTTPHeaderField: "Content-Type")
        request.setValue(Constants.tenantId, forHTTPHeaderField: "Tenant-ID")
        request.setValue(Constants.requestId, forHTTPHeaderField: "Request-ID")

        let expiryDate = "\(year)\(month)"
        let json = Constants.orderDetails(
            pan: pan,
            cvv2: cvv2,
            expiryDate: expiryDate,
            packedSdkDataString: packedSdkDataString
        )

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
            request.httpBody = jsonData
        } catch {
            showError(.encodingError(error), source: .postExecute)
            return
        }

        contentView.showLoading(.postExecute)

        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            defer {
                DispatchQueue.main.async {
                    self?.getOrderStatus()
                }
            }

            self?.printDebug(data: data, response: response)

            if let error {
                self?.showError(.responseError(error), source: .postExecute)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, let data else {
                self?.showError(.noHTTPResponse, source: .postExecute)
                return
            }

            switch httpResponse.statusCode {
            case 200:
                do {
                    let response = try JSONDecoder.isoDateDecoder.decode(CompletedDTO.self, from: data)
                    DispatchQueue.main.async {
                        self?.contentView.postExecuteLabel.text = "redirectUrl: \(response.redirectUrl)"
                    }
                } catch {
                    self?.showError(.decodingError(error), source: .postExecute)
                }
            case 202:
                do {
                    let response = try JSONDecoder.isoDateDecoder.decode(PostExecuteDTO.self, from: data)
                    DispatchQueue.main.async {
                        self?.handlePostExecuteRequest(response, transaction: transaction)
                    }
                } catch {
                    self?.showError(.decodingError(error), source: .postExecute)
                }
            case 400:
                let response = try? JSONDecoder.isoDateDecoder.decode(ExecuteErrorDTO.self, from: data)
                self?.showError(
                    .requestError(code: "\(response?.code ?? "no code")", message: response?.message ?? ""),
                    source: .postExecute
                )
            default:
                self?.showError(.requestError(code: "\(httpResponse.statusCode)"), source: .postExecute)
            }
        }
        task.resume()
    }

    /// Use `messageVersion` and `directoryServerID` to create real transaction.
    /// Payment execution with payment method details, `orderId` and `packedSdkData`
    /// `Response` - payment order status:`CREATED`, `DECLINED`, `PAID`
    @objc
    private func getOrderRequest() {
        getOrderStatus()
    }
}
