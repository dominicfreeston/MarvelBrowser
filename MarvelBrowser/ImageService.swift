import UIKit
import RxSwift

protocol ImageService {
    func image(for url: URL) -> Observable<UIImage>
}

class HTTPImageService: ImageService {
    enum ImageError: Error {
        case invalidData
    }

    func image(for url: URL) -> Observable<UIImage> {
        let request = URLRequest(url: url)
        return URLSession.shared.rx
            .data(request: request)
            .map { data in
                guard let image = UIImage(data: data) else {
                    throw ImageError.invalidData
                }
                return image
        }
    }
}
