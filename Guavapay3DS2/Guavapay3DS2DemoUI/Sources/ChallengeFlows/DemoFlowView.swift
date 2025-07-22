//
//  DemoFlowView.swift
//  Guavapay3DS2
//

import UIKit

final class DemoFlowView: UIView {
    private enum Constants {
        static let postOrderButtonTitle = "1 – POST /order"
        static let putPaymentButtonTitle = "2 – PUT /payment"
        static let postExecuteButtonTitle = "3 – POST /execute"
        static let getOrderButtonTitle = "4 – GET /order"
    }
    
    let postOrderButton = UIButton(type: .system)
    let postOrderLabel = UILabel()
    let putPaymentButton = UIButton(type: .system)
    let putPaymentLabel = UILabel()
    let postExecuteButton = UIButton(type: .system)
    let postExecuteLabel = UILabel()
    let getOrderButton = UIButton(type: .system)
    let getOrderLabel = UILabel()
    let paymentDetailsView = PaymentDetailsView()
    let cardFormView = CardFormView()
    
    private let challengeTypeLabel = UILabel()
    private lazy var challengeTypeSegment: UISegmentedControl = {
        let items = ChallengeType.allCases.map { $0.rawValue }
        let segmented = UISegmentedControl(items: items)
        segmented.addTarget(self, action: #selector(didChangeChallengeType(_:)), for: .valueChanged)
        return segmented
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        configureButtons()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showError(message: String, source: Step?) {
        guard let source else {
            return
        }
        
        let errorMessage = "Error: \(message)"
        switch source {
        case .postOrder:
            postOrderLabel.text = errorMessage
        case .putPayment:
            putPaymentLabel.text = errorMessage
        case .postExecute:
            postExecuteLabel.text = errorMessage
        case .getOrder:
            getOrderLabel.text = errorMessage
        }
    }
    
    func showLoading(_ step: Step) {
        switch step {
        case .postOrder:
            postOrderButton.showLoading()
        case .putPayment:
            putPaymentButton.showLoading()
        case .postExecute:
            postExecuteButton.showLoading()
        case .getOrder:
            getOrderButton.showLoading()
        }
    }
    
    func hideLoading() {
        [postOrderButton, putPaymentButton, postExecuteButton, getOrderButton].forEach { $0.hideLoading() }
    }
    
    func configure(for step: Step) {
        switch step {
        case .postOrder:
            postExecuteButton.isEnabled = false
            putPaymentButton.isEnabled = true
            getOrderButton.isEnabled = true
            
            putPaymentLabel.text = "Payment: ..."
            postExecuteLabel.text = "Execute: ..."
            getOrderLabel.text = "Status: ..."
        case .putPayment:
            postExecuteButton.isEnabled = true
        case .postExecute, .getOrder:
            break
        }
        
        hideLoading()
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        backgroundColor = .systemBackground
        // Wrap content in a scroll view
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        let containerView = UIStackView()
        containerView.axis = .vertical
        containerView.spacing = 8
        containerView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(containerView)
        
        challengeTypeLabel.text = "Challenge Type"
        challengeTypeLabel.textAlignment = .center
        
        postOrderLabel.text = "Order: ..."
        putPaymentLabel.text = "Payment: ..."
        postExecuteLabel.text = "Execute: ..."
        getOrderLabel.text = "Status: ..."
        
        [postOrderLabel, putPaymentLabel, postExecuteLabel, getOrderLabel].forEach {
            $0.font = .monospacedSystemFont(ofSize: 12, weight: .thin)
            $0.numberOfLines = 4
        }
        
        [postOrderButton, putPaymentButton, postExecuteButton, getOrderButton].forEach {
            $0.backgroundColor = .systemGray5
            $0.layer.cornerRadius = 8
            $0.titleLabel?.numberOfLines = 0
            $0.titleLabel?.textAlignment = .center
        }
        
        containerView.addArrangedSubview(challengeTypeLabel)
        containerView.addArrangedSubview(challengeTypeSegment)
        containerView.addArrangedSubview(paymentDetailsView)
        containerView.addArrangedSubview(postOrderButton)
        containerView.addArrangedSubview(postOrderLabel)
        containerView.addArrangedSubview(cardFormView)
        containerView.addArrangedSubview(putPaymentButton)
        containerView.addArrangedSubview(putPaymentLabel)
        containerView.addArrangedSubview(postExecuteButton)
        containerView.addArrangedSubview(postExecuteLabel)
        containerView.addArrangedSubview(getOrderButton)
        containerView.addArrangedSubview(getOrderLabel)

        let scrollGuide = scrollView.contentLayoutGuide
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: scrollGuide.topAnchor, constant: 16),
            containerView.leadingAnchor.constraint(equalTo: scrollGuide.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: scrollGuide.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: scrollGuide.bottomAnchor, constant: -16),
            containerView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -32)
        ])
    }
    
    private func configureButtons() {
        postOrderButton.setTitle(Constants.postOrderButtonTitle, for: .normal)
        putPaymentButton.setTitle(Constants.putPaymentButtonTitle, for: .normal)
        putPaymentButton.isEnabled = false
        postExecuteButton.setTitle(Constants.postExecuteButtonTitle, for: .normal)
        postExecuteButton.isEnabled = false
        getOrderButton.setTitle(Constants.getOrderButtonTitle, for: .normal)
        getOrderButton.isEnabled = false
    }
    
    /// Prefill payment method details with data for required challenge type
    /// - Parameter type: type of required challenge
    private func prefillData(for type: ChallengeType) {
        paymentDetailsView.setAmount(11.23)
        paymentDetailsView.setCurrency(.usd)
        
        let panStub = type.pan
        let dateStub = type.date
        let cvcStub = type.cvc
        
        cardFormView.setPan(panStub)
        cardFormView.setExpiry(month: dateStub.0, year: dateStub.1)
        cardFormView.setCVC(cvcStub)
    }
    
    @objc
    private func didChangeChallengeType(_ sender: UISegmentedControl) {
        let selectedType = ChallengeType.allCases[sender.selectedSegmentIndex]
        prefillData(for: selectedType)
    }
}
