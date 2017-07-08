import XCTest
import FBSnapshotTestCase
import RxSwift
@testable import MarvelBrowser

class URLImageViewSnapshotTests: FBSnapshotTestCase {
    override func setUp() {
        super.setUp()

        recordMode = false
    }

    func testURLImageViewGetsImageFromService() {
        let url = URL(string: "http://some.com")!
        let image = loadImage(named: "aim")

        let mockImageService = MockImageService([url.absoluteString: image])
        let urlImageView = URLImageView(
            frame: CGRect(x: 0, y: 0, width: 64, height: 64),
            imageService: mockImageService
        )

        urlImageView.update(with: url)

        FBSnapshotVerifyView(urlImageView)
    }
}
