//
//  PaymentDetailsView.swift
//  Guavapay3DS2
//

import UIKit

/// View for payment details: amount and currency
final class PaymentDetailsView: UIView {
    /// Currency with its standard string code as raw value
    enum Currency: String, CaseIterable {
        case gbp = "GBP"
        case usd = "USD"
        case eur = "EUR"
    }

    /// Payment amount
    var amount: Decimal? {
        Decimal(string: amountTextField.text ?? "")
    }

    /// Selected payment currency
    var currency: String? {
        currencyControl.titleForSegment(at: currencyControl.selectedSegmentIndex)
    }

    /// Set payment amount
    /// - Parameter amount: payment amount
    func setAmount(_ amount: Decimal) {
        amountTextField.text = String(describing: amount)
    }

    /// Set payment currency
    /// - Parameter currency: payment currency
    func setCurrency(_ currency: Currency) {
        if let index = Currency.allCases.firstIndex(where: { $0 == currency }) {
            currencyControl.selectedSegmentIndex = index
        }
    }

    private let amountTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "Amount"
        field.keyboardType = .decimalPad
        field.borderStyle = .roundedRect
        return field
    }()

    private let currencyControl: UISegmentedControl = {
        let items = Currency.allCases.map { $0.rawValue }
        let segmented = UISegmentedControl(items: items)
        segmented.selectedSegmentIndex = 0
        return segmented
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    private func setupViews() {
        addSubview(amountTextField)
        addSubview(currencyControl)

        amountTextField.translatesAutoresizingMaskIntoConstraints = false
        currencyControl.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            amountTextField.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            amountTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            amountTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            amountTextField.heightAnchor.constraint(equalToConstant: 44),

            currencyControl.topAnchor.constraint(equalTo: amountTextField.bottomAnchor, constant: 12),
            currencyControl.leadingAnchor.constraint(equalTo: amountTextField.leadingAnchor),
            currencyControl.trailingAnchor.constraint(equalTo: amountTextField.trailingAnchor),
            currencyControl.heightAnchor.constraint(equalToConstant: 32),
            currencyControl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])

        // Formatting handler for two-decimal limit
        amountTextField.addTarget(self, action: #selector(formatAmount), for: .editingChanged)
    }

    // MARK: - Input Formatting
    @objc
    private func formatAmount(_ textField: UITextField) {
        // Allow only digits and decimal separator, limit to two decimals
        let text = textField.text ?? ""
        // Split on separator
        let parts = text.components(separatedBy: ".")
        let integerPart = parts.first?.filter { $0.isNumber } ?? ""
        var result = integerPart

        if parts.count > 1 {
            let fractional = parts[1].filter { $0.isNumber }
            let limitedFrac = String(fractional.prefix(2))
            result += "." + limitedFrac
        }
        textField.text = result
    }
}
