//
//  String+Base64.swift
//  Guavapay3DS2
//

import Guavapay3DS2

public extension String {
    func base64URLEncodedString() -> String? {
        (self as NSString)._gptds_base64URLEncoded()
    }

    func base64URLDecodedString() -> String? {
        (self as NSString)._gptds_base64URLDecoded()
    }

    func base64URLDecodedData() -> Data? {
        (self as NSString)._gptds_base64URLDecodedData()
    }
}
