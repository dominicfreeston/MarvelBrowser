import UIKit
import RxSwift

protocol ImageService {
    func image(for url: URL) -> Observable<UIImage>
}

enum DataConversionError: Error {
    case invalidImage
    case invalidJSON
}

class HTTPImageService: ImageService {

    static let shared: HTTPImageService = {
        return HTTPImageService(urlSession: newImageCachingSession())
    }()

    let urlSession: URLSession

    init(urlSession: URLSession) {
        self.urlSession = urlSession
    }

    func image(for url: URL) -> Observable<UIImage> {
        let request = URLRequest(url: url)
        return urlSession.rx
            .data(request: request)
            .map { data in
                guard let image = UIImage(data: data) else {
                    throw DataConversionError.invalidImage
                }
                return image
        }
    }

    private static func newImageCachingSession() -> URLSession {
        let imageCache = URLCache(
            memoryCapacity: 4 * 1024 * 1024,
            diskCapacity: 40 * 1024 * 1024,
            diskPath: "ImageCache")

        let configuration = URLSessionConfiguration.default
        configuration.urlCache = imageCache
        configuration.httpCookieStorage = .shared
        configuration.urlCredentialStorage = .shared
        configuration.requestCachePolicy = .returnCacheDataElseLoad

        let session = URLSession(configuration: configuration)
        
        return session
    }
}
