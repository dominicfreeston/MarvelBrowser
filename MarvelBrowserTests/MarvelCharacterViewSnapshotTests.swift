import XCTest
import FBSnapshotTestCase
import PureLayout
@testable import MarvelBrowser

class MarvelCharacterViewSnapshotTests: FBSnapshotTestCase {

    var character: MarvelCharacter!
    var characterView: MarvelCharacterView!
    var contentView: UIView!

    override func setUp() {
        super.setUp()

        character = try! MarvelCharacter(json: loadJSON(named: "character"))

        contentView = UIView()
        contentView.autoSetDimension(.width, toSize: 375)

        characterView = MarvelCharacterView(imageService: marvelMockImageService)
        contentView.addSubview(characterView)
        characterView.autoPinEdgesToSuperviewEdges()

        recordMode = false
    }

    func testCharacterView() {
        characterView.update(with: character)
        FBSnapshotVerifyView(characterView)
    }

    func testCharacterViewWithLongDescription() {
        characterView.update(with: character.withRepeatedDescription())
        FBSnapshotVerifyView(characterView)
    }
}

private extension MarvelCharacter {
    func withRepeatedDescription(times: Int = 3) -> MarvelCharacter {
        var newDescription = self.description

        for _ in 1...times {
            newDescription += " " + self.description
        }

        return MarvelCharacter(
            identifier: identifier,
            name: name,
            description: newDescription,
            thumbnail: thumbnail
        )
    }
}
