//
//  Step.swift
//  Guavapay3DS2
//

enum Step {
    case postOrder
    case putPayment
    case postExecute
    case getOrder
}

enum ErrorType {
    case invalidRequestData
    case invalidDirectoryServerID
    case invalidResponse
    case invalidBase64String
    case invalidPackedSDK
    case noHTTPResponse
    case noData
    case noRootCertificates
    case encodingError(Error)
    case decodingError(Error)
    case responseError(Error)
    case requestError(code: String, message: String = "")
    case pollingTimedOut
    case custom(String)
    case unknown

    var message: String {
        switch self {
        case .invalidRequestData:
            "Invalid URL"
        case .invalidDirectoryServerID:
            "Invalid DirectoryServerID"
        case .invalidResponse:
            "Invalid response"
        case .invalidBase64String:
            "Failed to decode Base64"
        case .invalidPackedSDK:
            "Failed to decode packed SDK"
        case .noHTTPResponse:
            "No HTTP response"
        case .noData:
            "Data is nil"
        case .noRootCertificates:
            "No certificates found in ACS response"
        case .encodingError(let error):
            "Error serializing JSON: \(error)"
        case .decodingError(let error):
            "Decoding error: \(error)"
        case .responseError(let error):
            "\(error)"
        case .requestError(let code, let message):
            "\(code) \(message)"
        case .pollingTimedOut:
            "Polling timed out"
        case .custom(let message):
            message
        case .unknown:
            "Unknown error"
        }
    }
}
