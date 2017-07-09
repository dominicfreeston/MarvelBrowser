import Foundation

struct MarvelRequestFactory {
    let publicKey: String
    let privateKey: String
    let baseURLString: String

    func charactersRequest(offset: Int,
        timestamp: TimeInterval = Date().timeIntervalSinceReferenceDate) -> URLRequest {
        return marvelRequest(
            path: "/v1/public/characters",
            parameters: ["offset": "\(offset)"],
            timestamp: timestamp
        )
    }

    private func marvelRequest(path: String, parameters: [String: String], timestamp: TimeInterval) -> URLRequest {
        guard var components = URLComponents(string: baseURLString) else {
            preconditionFailure("Check your BaseURL")
        }

        let queryItems = parameters.map { URLQueryItem(name: $0, value: $1) }
        components.queryItems = queryItems + defaultQueryItems(timestamp: timestamp)
        components.path = path

        guard let url = components.url else {
            preconditionFailure("Check your BaseURL")
        }

        return URLRequest(url: url)
    }

    private func defaultQueryItems(timestamp: TimeInterval) -> [URLQueryItem] {
        let timestamp = String(Int(timestamp))
        let hash = (timestamp + privateKey + publicKey).MD5()

        return [
            URLQueryItem(name: "ts", value: timestamp),
            URLQueryItem(name: "apikey", value: publicKey),
            URLQueryItem(name: "hash", value: hash)
        ]
    }
}
