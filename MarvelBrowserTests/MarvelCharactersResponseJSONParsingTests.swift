import XCTest
@testable import MarvelBrowser

class MarvelCharactersResponseJSONParsingTests: XCTestCase {

    var charactersResponse: MarvelCharactersResponse? {
        let json = loadJSON(named: "charactersResponse")
        return try? MarvelCharactersResponse(json: json)
    }

    func testCharacterReponseHasExpectedOffset() {
        XCTAssertEqual(charactersResponse?.offset, 0)
    }

    func testCharacterResponseIncludesTotalNumberOfAvailableCharacters() {
        XCTAssertEqual(charactersResponse?.total, 1485)
    }

    func testCharacterReponseHasExpectedNumberOfCharacters() {
        XCTAssertEqual(charactersResponse?.characters.count, 20)
    }

}
