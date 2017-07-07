import XCTest
@testable import MarvelBrowser

class MarvelCharacterJSONParsingTest: XCTestCase {

    func testCharacterHasCorrectIdentifier() {
        let json = loadJSON(named: "character")
        let character = try? MarvelCharacter(json: json)

        XCTAssertEqual(character?.identifier, 1009144)
    }

    func testCharacterHasCorrectName() {
        let json = loadJSON(named: "character")
        let character = try? MarvelCharacter(json: json)

        XCTAssertEqual(character?.name, "A.I.M.")
    }

    func testCharacterHasCorrectDescription() {
        let json = loadJSON(named: "character")
        let character = try? MarvelCharacter(json: json)

        XCTAssertEqual(
            character?.description,
            "AIM is a terrorist organization bent on destroying the world."
        )
    }
}
