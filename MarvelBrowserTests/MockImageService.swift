import UIKit
import RxSwift
@testable import MarvelBrowser

class MockImageService: ImageService {
    let images: [String: UIImage]

    init(_ images: [String: UIImage]) {
        self.images = images
    }

    func image(for url: URL) -> Observable<UIImage> {
        guard let image = images[url.absoluteString] else {
            return Observable.empty()
        }

        return Observable.just(image)
    }
}
