//
//  PutPaymentDTO.swift
//  Guavapay3DS2
//

import Foundation

// MARK: - PutPaymentDTO
struct PutPaymentDTO: Codable {
    struct Requirements: Codable {
        let threedsMethod: ThreeDSMethodDTO?
        let threedsSdkCreateTransaction: ThreeDSSdkCreateTransactionDTO
    }

    let requirements: Requirements
}

struct ThreeDSSdkCreateTransactionDTO: Codable {
    let messageVersion: String
    let directoryServerID: String
}
