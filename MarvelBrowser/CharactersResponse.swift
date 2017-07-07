import Foundation
import Unbox

struct CharactersResponse {
    let characters: [MarvelCharacter]
}

extension CharactersResponse: Unboxable {
    init(unboxer: Unboxer) throws {
        let data: [String: Any] = try unboxer.unbox(key: "data")
        let dataUnboxer = Unboxer(dictionary: data)

        self.characters = try dataUnboxer.unbox(key: "results", allowInvalidElements: false)
    }
}
