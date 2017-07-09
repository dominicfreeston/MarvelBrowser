import Foundation

func toJSON(data: Data) throws -> [String: Any] {
    return try data.toJSON()
}

extension Data {
    func toJSON() throws -> [String: Any] {
        let json = try JSONSerialization.jsonObject(with: self, options: [])

        guard let jsonDictionary = json as? [String: Any] else {
            throw HTTPImageService.ImageError.invalidData
        }

        return jsonDictionary
    }
}
