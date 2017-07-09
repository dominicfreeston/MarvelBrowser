import XCTest
import FBSnapshotTestCase
import PureLayout
@testable import MarvelBrowser

class MarvelCharactersListViewSnapshotTests: FBSnapshotTestCase {

    var characters: MarvelCharactersList {
        let response = try! MarvelCharactersResponse(json: loadJSON(named: "charactersResponse"))
        return MarvelCharactersList(characters: response.characters)
    }

    override func setUp() {
        super.setUp()
        recordMode = RECORD_SNAPSHOTS
    }

    func testListViewShowsListOfCharacters() {
        let charactersListView = MarvelCharacterListView(frame: CGRect(x: 0, y: 0, width: 375, height: 667))
        charactersListView.update(with: characters)

        FBSnapshotVerifyView(charactersListView)
    }
}
