//
//  STPCardFormViewStyle.swift
//  Guavapay3DS2
//

import UIKit

/// View for card payment method information
final class CardFormView: UIView {
    /// Card number
    var pan: String? {
        cardNumberField.text?.filter { $0.isNumber }
    }

    /// Card expiry date month
    var expiryMonth: String? {
        getDate().month
    }

    /// Card expiry date year
    var expiryYear: String? {
        getDate().year
    }

    /// Card CVC code
    var cvc: String? {
        cvcField.text
    }

    private func getDate() -> (month: String?, year: String?) {
        // Expiry parsing: remove non-digits, split into MM and YY
        let rawExpiry = expiryField.text?.filter { $0.isNumber } ?? ""
        var month: String?
        var year: String?
        if rawExpiry.count >= 2 {
            month = String(rawExpiry.prefix(2))
            if rawExpiry.count > 2 {
                let start = rawExpiry.index(rawExpiry.startIndex, offsetBy: 2)
                year = String(rawExpiry[start...])
            }
        }
        return (month, year)
    }

    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.lightGray.cgColor
        return view
    }()

    private let cardNumberField: UITextField = {
        let field = UITextField()
        field.placeholder = "Card number"
        field.keyboardType = .numberPad
        field.borderStyle = .none
        return field
    }()

    private let expiryField: UITextField = {
        let field = UITextField()
        field.placeholder = "MM / YY"
        field.keyboardType = .numberPad
        field.borderStyle = .none
        return field
    }()

    private let cvcField: UITextField = {
        let field = UITextField()
        field.placeholder = "CVC"
        field.keyboardType = .numberPad
        field.borderStyle = .none
        return field
    }()

    private let expiryCVCStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 16
        return stack
    }()

    private let separator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    /// Set card number
    /// - Parameter pan: card number
    func setPan(_ pan: String) {
        cardNumberField.text = pan
    }

    /// Set card expiry date
    /// - Parameters:
    ///   - month: expiry month
    ///   - year: expiry year
    func setExpiry(month: String, year: String) {
        expiryField.text = "\(month)/\(year)"
    }

    /// Set card CVC code
    /// - Parameter cvc: CVC code
    func setCVC(_ cvc: String) {
        cvcField.text = cvc
    }

    private func setupViews() {
        // Container
        addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])

        // Add subviews
        [cardNumberField, separator, expiryCVCStack].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview($0)
        }

        // Stack fields
        expiryCVCStack.addArrangedSubview(expiryField)
        expiryCVCStack.addArrangedSubview(cvcField)

        // Constraints
        NSLayoutConstraint.activate([
            // Card number
            cardNumberField.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            cardNumberField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            cardNumberField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            cardNumberField.heightAnchor.constraint(equalToConstant: 44),

            // Separator 1
            separator.topAnchor.constraint(equalTo: cardNumberField.bottomAnchor),
            separator.leadingAnchor.constraint(equalTo: cardNumberField.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: cardNumberField.trailingAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1),

            // Expiry / CVC stack
            expiryCVCStack.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 8),
            expiryCVCStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            expiryCVCStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            expiryCVCStack.heightAnchor.constraint(equalToConstant: 44),
            expiryCVCStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8)
        ])

        // Formatting handlers
        cardNumberField.addTarget(self, action: #selector(formatCardNumber), for: .editingChanged)
        expiryField.addTarget(self, action: #selector(formatExpiry), for: .editingChanged)
        cvcField.addTarget(self, action: #selector(formatCVC), for: .editingChanged)
    }

    // MARK: - Input Formatting

    @objc
    private func formatCardNumber(_ textField: UITextField) {
        let digits = textField.text?.filter { $0.isNumber } ?? ""
        let limited = String(digits.prefix(16))
        var result = ""
        for (index, char) in limited.enumerated() {
            if index != 0 && index % 4 == 0 {
                result.append(" ")
            }
            result.append(char)
        }
        textField.text = result

        // Move to expiry when card number complete (16 digits + 3 spaces)
        if result.count == 19 {
            expiryField.becomeFirstResponder()
        }
    }

    @objc
    private func formatExpiry(_ textField: UITextField) {
        // Strip non-digits and limit to 4 characters (MMYY)
        let digits = textField.text?.filter { $0.isNumber } ?? ""
        let limited = String(digits.prefix(4))

        // Build formatted string
        var result = ""
        if limited.count >= 2 {
            // Always show month and slash
            let month = String(limited.prefix(2))
            result = month + "/"
            // Append year digits if any
            let yearDigits = String(limited.dropFirst(2))
            result += yearDigits
        } else {
            // Only month digits so far
            result = limited
        }
        
        textField.text = result

        // Move to CVC when expiry complete (MM/YY: 5 characters)
        if result.count == 5 {
            cvcField.becomeFirstResponder()
        }
    }

    @objc
    private func formatCVC(_ textField: UITextField) {
        let digits = textField.text?.filter { $0.isNumber } ?? ""
        textField.text = String(digits.prefix(4))

        if textField.text?.count == 4 {
            textField.resignFirstResponder()
        }
    }
}
