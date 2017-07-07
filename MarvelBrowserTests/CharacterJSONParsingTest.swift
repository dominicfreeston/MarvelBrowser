import XCTest
@testable import MarvelBrowser

class CharacterJSONParsingTest: XCTestCase {

    func testCharacterHasCorrectIdentifier() {
        let json = loadJSON(named: "character")
        let character = try? Character(json: json)

        XCTAssertEqual(character?.identifier, 1009144)
    }
}
