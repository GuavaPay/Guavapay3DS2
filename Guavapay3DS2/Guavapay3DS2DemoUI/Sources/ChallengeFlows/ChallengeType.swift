//
//  ChallengeType.swift
//  Guavapay3DS2
//

/// Type of 3DS challenge with corresponding payment method presets
enum ChallengeType: String, CaseIterable {
    /// Text challenge
    case text = "Text"
    /// Single select challenge
    case singleSelect = "Single"
    /// Multi select challenge
    case multipleSelect = "Multiple"
    /// Out-of-band (OOB) challenge
    case oob = "OOB"
    /// HTML form challenge
    case html = "HTML"

    /// Card number preset for selected challenge type
    var pan: String {
        switch self {
        case .text:
            "4111 1111 1111 1111"
        case .singleSelect:
            "4111 1199 2589 0861"
        case .multipleSelect:
            "4111 1100 4036 3983"
        case .oob:
            "5373 6100 1430 7239"
        case .html:
            "4295 0308 4796 7133"
        }
    }

    /// Card expiry date preset for selected challenge type
    var date: (String, String) {
        switch self {
        case .text, .singleSelect, .multipleSelect:
            ("12", "26")
        case .oob:
            ("01", "28")
        case .html:
            ("11", "26")
        }
    }

    /// Card CVC code preset for selected challenge type
    var cvc: String {
        switch self {
        case .text, .singleSelect, .multipleSelect, .oob, .html:
            "123"
        }
    }
}
