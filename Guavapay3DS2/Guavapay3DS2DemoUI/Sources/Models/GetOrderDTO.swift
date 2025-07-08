//
//  GetOrderDTO.swift
//  Guavapay3DS2
//
//  Created by Nikolai Kriuchkov on 16.04.2025.
//

import Foundation

struct GetOrderDTO: Codable {
    let order: OrderDTO?
    let merchant: MerchantDTO?
    let payment: PaymentDTO?
    let refunds: [RefundDTO]?
    let paymentRequirements: PaymentRequirementsDTO?
}

struct OrderDTO: Codable {
    enum Status: String, Codable {
        case created = "CREATED"
        case paid = "PAID"
        case declined = "DECLINED"
        case partiallyRefunded = "PARTIALLY_REFUNDED"
        case refunded = "REFUNDED"
        case cancelled = "CANCELLED"
        case expired = "EXPIRED"
        case recurrenceActive = "RECURRENCE_ACTIVE"
        case recurrenceClose = "RECURRENCE_CLOSE"
    }

    let referenceNumber: String?
    let terminalId: String?
    let purpose: String?
    let redirectUrl: String?
    let merchantUrl: String?
    let intermediateResultPageOptions: IntermediateResultPageOptionsDTO?
    let callbackUrl: String?
    let shippingAddress: String?
    let requestor: RequestorDTO?
    let tags: [String: String]?
    let availablePaymentMethods: [String]?
    let availableCardSchemes: [String]?
    let availableCardProductCategories: [String]?
    let availablePaymentCurrencies: [String]?
    let id: String?
    let status: Status?
    let serviceChannel: String?
    let totalAmount: AmountDTO
    let subtotals: [SubtotalDTO]?
    let refundedAmount: AmountDTO?
    let recurrence: RecurrenceDTO?
    let paymentPageUrl: String?
    let shortPaymentPageUrl: String?
    let expirationDate: String?
    let sessionToken: String?
    let description: OrderDescriptionDTO?
    let payer: PayerDTO?
    let payee: PayeeDTO?
}

struct MerchantDTO: Codable {
    let name: String?
}

struct PaymentDTO: Codable {
    let id: String?
    let date: String?
    let exchangeRate: Double?
    let amount: AmountDTO
    let referenceNumber: String?
    let result: PaymentResultDTO?
    let rrn: String?
    let authCode: String?
    let paymentMethod: PaymentMethodDTO?
    let reversal: ReversalDTO?
}

struct RefundDTO: Codable {
    let id: String?
    let date: String?
    let originalId: String?
    let result: PaymentResultDTO?
    let rrn: String?
    let authCode: String?
    let reason: String?
    let amount: AmountDTO
    let items: [ItemDTO]?
}

struct PaymentRequirementsDTO: Codable {
    let threedsMethod: ThreedsMethodDTO?
    let threedsChallenge: ThreedsChallengeDTO?
    let payerAuthorization: PayerAuthorizationDTO?
    let cryptocurrencyTransfer: CryptocurrencyTransferDTO?
    let payPalOrderApprove: PayPalOrderApproveDTO?
    let finishPageRedirect: FinishPageRedirectDTO?
}

struct IntermediateResultPageOptionsDTO: Codable {
    let successMerchantUrl: String?
    let unsuccessMerchantUrl: String?
    let autoRedirectDelaySeconds: Int?
}

struct RequestorDTO: Codable {
    let application: ApplicationDTO?
    let customData: CustomDataDTO?
}

struct ApplicationDTO: Codable {
    let name: String?
    let version: String?
}

struct CustomDataDTO: Codable {
    let shared: [String: String]?
    let secret: [String: String]?
}

struct SubtotalDTO: Codable {
    let name: String?
    let direction: String?
    let amount: AmountDTO
}

struct RecurrenceDTO: Codable {
    let execution: String?
    let initialOperation: String?
    let description: String?
    let schedule: String?
    let startDate: String?
    let endDate: String?
    let amount: AmountDTO
    let maxAmount: AmountDTO
}

struct AmountDTO: Codable {
    let baseUnits: Double
    let currency: String
    let minorSubunits: Int
    let localized: String
}

struct OrderDescriptionDTO: Codable {
    let textDescription: String?
    let items: [ItemDTO]?
}

struct ItemDTO: Codable {
    let barcodeNumber: String?
    let vendorCode: String?
    let productProvider: String?
    let name: String?
    let count: Int?
    let unitPrice: AmountDTO
    let totalCost: AmountDTO
    let discountAmount: AmountDTO
    let taxAmount: AmountDTO
}

struct PayerDTO: Codable {
    let id: String?
    let availableInputModes: [String]?
    let firstName: String?
    let lastName: String?
    let dateOfBirth: String?
    let contactEmail: String?
    let contactPhone: ContactPhoneDTO?
    let maskedFirstName: String?
    let maskedLastName: String?
    let maskedDateOfBirth: String?
    let maskedContactEmail: String?
    let maskedContactPhone: MaskedContactPhoneDTO?
    let address: AddressDTO?
}

struct ContactPhoneDTO: Codable {
    let countryCode: String?
    let nationalNumber: String?
}

struct MaskedContactPhoneDTO: Codable {
    let countryCode: String?
    let nationalNumber: String?
    let formatted: String?
}

struct AddressDTO: Codable {
    let country: String?
    let city: String?
    let state: String?
    let zipCode: String?
    let addressLine1: String?
    let addressLine2: String?
    let maskedZipCode: String?
    let maskedAddressLine1: String?
    let maskedAddressLine2: String?
}

struct PayeeDTO: Codable {
    let id: String?
    let firstName: String?
    let lastName: String?
    let dateOfBirth: String?
    let maskedFirstName: String?
    let maskedLastName: String?
    let maskedDateOfBirth: String?
    let account: AccountDTO?
    let address: AddressDTO?
}

struct AccountDTO: Codable {
    let type: String?
    let value: String?
}

struct PaymentResultDTO: Codable {
    let code: String?
    let message: String?
}

struct PaymentMethodDTO: Codable {
    let type: String?
    let maskedPan: String?
    let cardScheme: String?
    let cardholderName: String?
}

struct ReversalDTO: Codable {
    let result: PaymentResultDTO?
    let reason: String?
}

struct ThreedsMethodDTO: Codable {
    let data: String?
    let url: String?
}

struct ThreedsChallengeDTO: Codable {
    let data: String?
    let url: String?
    let packedSdkChallengeParameters: String?
}

struct FinishPageRedirectDTO: Codable {
    let url: String?
    let message: String?
}
