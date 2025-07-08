//
//  String+JWT.swift
//  Guavapay3DS2
//

import Guavapay3DS2

public extension String {
    func decodeJWTHeader() -> [String: Any]? {
        let parts = self.components(separatedBy: ".")
        guard parts.count == 3,
              let headerData = parts[0].base64URLDecodedData(),
              let jsonObj = try? JSONSerialization.jsonObject(with: headerData),
              let header = jsonObj as? [String: Any]
        else {
            return nil
        }

        return header
    }
}
