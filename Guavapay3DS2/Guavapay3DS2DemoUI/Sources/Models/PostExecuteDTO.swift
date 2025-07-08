//
//  PostExecuteDTO.swift
//  Guavapay3DS2
//

import Foundation

// MARK: - PostExecuteDTO
struct PostExecuteDTO: Codable {
    let requirements: RequirementsDTO
}

// MARK: - Requirements
struct RequirementsDTO: Codable {
    let threedsMethod: ThreeDSMethodDTO?
    let threedsChallenge: ThreeDSChallengeDTO?
    let payerAuthorization: PayerAuthorizationDTO?
    let cryptocurrencyTransfer: CryptocurrencyTransferDTO?
    let payPalOrderApprove: PayPalOrderApproveDTO?
}

// MARK: - ThreeDSMethod
struct ThreeDSMethodDTO: Codable {
    let data: String?
    let url: String?
}

// MARK: - ThreeDSChallenge
struct ThreeDSChallengeDTO: Codable {
    let data: String?
    let url: String?
    let packedSdkChallengeParameters: String?
}

// MARK: - PayerAuthorization
struct PayerAuthorizationDTO: Codable {
    let authorizationUrl: String?
    let qrCodeData: String?
    let expirationDate: Date?
}

// MARK: - CryptocurrencyTransfer
struct CryptocurrencyTransferDTO: Codable {
    let walletAddress: String?
    let expirationDate: Date?
    let networkName: String?
    let detectedAmount: DetectedAmountDTO?
}

// MARK: - DetectedAmount
struct DetectedAmountDTO: Codable {
    let baseUnits: Double
    let currency: String
    let minorSubunits: Int
    let localized: String
}

// MARK: - PayPalOrderApprove
struct PayPalOrderApproveDTO: Codable {
    let actionUrl: String?
    let orderId: String?
}

struct CompletedDTO: Codable {
    let redirectUrl: URL
}
