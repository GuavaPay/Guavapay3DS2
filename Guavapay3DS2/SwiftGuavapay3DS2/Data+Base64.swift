//
//  Data+Base64.swift
//  Guavapay3DS2
//

import Guavapay3DS2

public extension Data {
    func base64URLEncodedString() -> String? {
        (self as NSData)._gptds_base64URLEncodedString()
    }

    func base64URLDecodedString() -> String? {
        (self as NSData)._gptds_base64URLDecodedString()
    }
}
