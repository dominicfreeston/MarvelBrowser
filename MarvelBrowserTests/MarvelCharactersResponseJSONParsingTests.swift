import XCTest
@testable import MarvelBrowser

class MarvelCharactersResponseJSONParsingTests: XCTestCase {

    func testCharacterResponseIncludesTotalNumberOfAvailableCharacters() {
        let json = loadJSON(named: "charactersResponse")
        let charactersResponse = try? MarvelCharactersResponse(json: json)

        XCTAssertEqual(charactersResponse?.total, 1485)
    }

    func testCharacterReponseHasExpectedNumberOfCharacters() {
        let json = loadJSON(named: "charactersResponse")
        let charactersResponse = try? MarvelCharactersResponse(json: json)

        XCTAssertEqual(charactersResponse?.characters.count, 20)
    }

}
