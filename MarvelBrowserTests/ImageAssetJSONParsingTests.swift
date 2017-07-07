import XCTest
@testable import MarvelBrowser

class ImageAssetJSONParsingTests: XCTestCase {

    func testItCanParseAnImageAssetURL() {
        let json = loadJSON(named: "imageAsset")
        let imageAsset = try? ImageAsset(json: json)

        XCTAssertEqual(
            imageAsset?.path.absoluteString,
            "http://i.annihil.us/u/prod/marvel/i/mg/c/e0/535fecbbb9784"
        )
    }

    func testThatItCanParseImageAssetFileExtension() {
        let json = loadJSON(named: "imageAsset")
        let imageAsset = try? ImageAsset(json: json)

        XCTAssertEqual(imageAsset?.fileExtension, "jpg")
    }
}
