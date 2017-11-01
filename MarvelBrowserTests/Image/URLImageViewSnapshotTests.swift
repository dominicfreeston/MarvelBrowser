import XCTest
import FBSnapshotTestCase
import RxSwift
@testable import MarvelBrowser

class URLImageViewSnapshotTests: FBSnapshotTestCase {
    override func setUp() {
        super.setUp()

        recordMode = RECORD_SNAPSHOTS
    }

    func testURLImageViewGetsImageFromService() {
        let urlImageView = URLImageView(
            frame: CGRect(x: 0, y: 0, width: 64, height: 64),
            imageService: marvelMockImageService
        )

        urlImageView.update(with: AIM_IMAGE_URL)

        FBSnapshotVerifyView(urlImageView)
    }
}
