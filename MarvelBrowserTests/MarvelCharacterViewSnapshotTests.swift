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
        let characterJSON = loadJSON(named: "character")
        let character = try! MarvelCharacter(json: characterJSON)
        let image = loadImage(named: "aim")
        let mockImageService = MockImageService([
            "http://i.annihil.us/u/prod/marvel/i/mg/6/20/52602f21f29ec/standard_medium.jpg": image
            ])

        let characterView = MarvelCharacterView(imageService: mockImageService)

        let contentView = UIView()
        contentView.addSubview(characterView)

        contentView.autoSetDimension(.width, toSize: 375)
        characterView.autoPinEdgesToSuperviewEdges()

        characterView.update(with: character)

        FBSnapshotVerifyView(characterView)
    }
}
