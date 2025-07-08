//
//  DemoFlowViewController+Helpers.swift
//  Guavapay3DS2
//

import Guavapay3DS2

extension DemoFlowViewController {
    func printDebug(data: Data?, response: URLResponse?) {
        let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
        let responseString = if let data, let decodedData = String(data: data, encoding: .utf8) {
            decodedData
        } else {
            "non-decodable data"
        }

        print("\n=== RESPONSE: \(statusCode)\n\(responseString)\n")
    }

    func handleURL(_ url: URL) {
        guard UIApplication.shared.canOpenURL(url) else {
            assertionFailure("Cannot open URL: \(url)")
            return
        }

        UIApplication.shared.open(url)
    }

    func extractX5C(from acsSignedContent: String) -> [String]? {
        let header = acsSignedContent.decodeJWTHeader()

        guard let x5c = header?["x5c"] as? [String] else {
            print("x5c array not found in header")
            return nil
        }

        return x5c
    }
}
