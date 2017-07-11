import Foundation

struct MarvelRequestFactory {
    private let publicKey: String
    private let privateKey: String
    private let baseURLString: String

    static var defaultFactory: MarvelRequestFactory {
        return MarvelRequestFactory(
            publicKey: MARVEL_PUBLIC_KEY,
            privateKey: MARVEL_PRIVATE_KEY,
            baseURLString: MARVEL_BASE_URL
        )
    }

    init(publicKey: String, privateKey: String, baseURLString: String) {
        self.publicKey = publicKey
        self.privateKey = privateKey
        self.baseURLString = baseURLString
    }

    func charactersRequest(offset: Int,
                           timestamp: TimeInterval = Date().timeIntervalSinceReferenceDate) -> URLRequest {
        return marvelRequest(
            path: "/v1/public/characters",
            parameters: [("offset", "\(offset)"), ("limit", "100")],
            timestamp: timestamp
        )
    }

    private func marvelRequest(path: String, parameters: [(String, String)], timestamp: TimeInterval) -> URLRequest {
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
