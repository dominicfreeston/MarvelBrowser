import XCTest
import FBSnapshotTestCase
import PureLayout
@testable import MarvelBrowser

class LoadingErrorViewSnapshotTests: FBSnapshotTestCase {

    override func setUp() {
        super.setUp()

        recordMode = RECORD_SNAPSHOTS
    }

    func testLoadingErrorViewLayout() {
        let errorView = LoadingErrorView()
        errorView.autoSetDimension(.width, toSize: 375)
        FBSnapshotVerifyView(errorView)
    }
}
