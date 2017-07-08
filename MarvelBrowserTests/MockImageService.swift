import XCTest
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

let AIM_IMAGE_URL = URL(string: "http://i.annihil.us/u/prod/marvel/i/mg/6/20/52602f21f29ec/standard_medium.jpg")!

extension XCTestCase {
    var marvelMockImageService: MockImageService {
        let aimImage = loadImage(named: "aim")

        return MockImageService ([
            AIM_IMAGE_URL.absoluteString: aimImage
            ]
        )
    }
}
