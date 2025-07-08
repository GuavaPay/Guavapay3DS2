//
//  ExecuteErrorDTO.swift
//  Guavapay3DS2
//

import Foundation

struct ExecuteErrorDTO: Codable {
    struct Validation: Codable {
        let field: String
        let error: String
    }

    let code: String
    let message: String
    let validations: [Validation]?
}
