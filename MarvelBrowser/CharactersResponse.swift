import Foundation
import Unbox

struct CharactersResponse {
    let characters: [MarvelCharacter]
}

extension CharactersResponse: Unboxable {
    init(json: [String: Any]) throws {
        try self.init(unboxer: Unboxer(dictionary: json))
    }

    init(unboxer: Unboxer) throws {
        let data: [String: Any] = try unboxer.unbox(key: "data")
        let dataUnboxer = Unboxer(dictionary: data)

        self.characters = try dataUnboxer.unbox(key: "results", allowInvalidElements: false)
    }
}
