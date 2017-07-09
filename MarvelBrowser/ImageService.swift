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
    let urlSession: URLSession

    init(urlSession: URLSession = URLSession.shared) {
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
}
