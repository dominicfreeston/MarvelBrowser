import XCTest
import FBSnapshotTestCase
import PureLayout
@testable import MarvelBrowser

class MarvelCharacterViewSnapshotTests: FBSnapshotTestCase {

    var character: MarvelCharacter!
    var characterView: MarvelCharacterView!

    override func setUp() {
        super.setUp()

        character = try! MarvelCharacter(json: loadJSON(named: "character"))
        characterView = MarvelCharacterView(imageService: marvelMockImageService)
        characterView.autoSetDimension(.width, toSize: 375)

        recordMode = RECORD_SNAPSHOTS
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
