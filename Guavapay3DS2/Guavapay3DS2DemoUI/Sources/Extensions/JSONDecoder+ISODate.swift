//
//  JSONDecoder+ISODate.swift
//  Guavapay3DS2
//

extension JSONDecoder {
    /// Create decoder for JSON with dates in `2023-01-01T15:00:00Z` format
    static var isoDateDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateStr = try container.decode(String.self)
            guard let date = isoFormatter.date(from: dateStr) else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid date: \(dateStr)")
            }

            return date
        }
        return decoder
    }
}
