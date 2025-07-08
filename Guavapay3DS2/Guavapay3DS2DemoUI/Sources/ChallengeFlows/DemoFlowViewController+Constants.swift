//
//  DemoFlowViewController+Constants.swift
//  Guavapay3DS2
//

extension DemoFlowViewController {
    enum Constants {
        static let redirectUrl = "guavapay-3ds-demo://"
        static let urlBase = "https://sandbox-pgw.myguava.com/order"
        static let initialBearerToken = "some-dummy-token"
        static let contentType = "application/json"
        static let tenantId = "1234"
        static let requestId = "5f9adf5a-4796-4668-9285-07adf3c9a1aa"

        static func orderDetails(
            pan: String,
            cvv2: Int,
            expiryDate: String,
            packedSdkDataString: String?
        ) -> [String: Any] {
            [
                "paymentMethod": [
                    "type": "PAYMENT_CARD",
                    "pan": pan,
                    "cvv2": cvv2,
                    "expiryDate": expiryDate,
                    "cardholderName": "CARDHOLDER NAME"
                ],
                "deviceData": [
                    "threedsSdkData": [
                        "name": "iOS SDK",
                        "version": "1.0.0",
                        "packedAuthenticationData": packedSdkDataString
                    ]
                ]
            ].merging(Constants.paymentDetails) { _, new in new }
        }

        private static let paymentDetails: [String: Any] = [
            "payer": [
                "contactEmail": nil,
                "contactPhone": nil,
                "nationalNumber": nil
            ]
        ]
    }
}
