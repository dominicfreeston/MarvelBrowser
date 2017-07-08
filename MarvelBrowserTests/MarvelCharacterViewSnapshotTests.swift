import XCTest
import FBSnapshotTestCase
import PureLayout
@testable import MarvelBrowser

class MarvelCharacterViewSnapshotTests: FBSnapshotTestCase {
    override func setUp() {
        super.setUp()

        recordMode = false
    }

    func testCharacterView() {
        let characterView = MarvelCharacterView(imageService: marvelMockImageService)

        let contentView = UIView()
        contentView.addSubview(characterView)

        contentView.autoSetDimension(.width, toSize: 375)
        characterView.autoPinEdgesToSuperviewEdges()

        let character = try! MarvelCharacter(json: loadJSON(named: "character"))
        characterView.update(with: character)
        FBSnapshotVerifyView(characterView)
    }
}
