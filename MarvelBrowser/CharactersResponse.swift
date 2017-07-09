import Foundation
import Unbox

struct CharactersResponse {
    let total: Int
    let characters: [MarvelCharacter]
}

extension CharactersResponse: Unboxable {
    init(unboxer: Unboxer) throws {
        let data: [String: Any] = try unboxer.unbox(key: "data")
        let dataUnboxer = Unboxer(dictionary: data)

        self.total = try dataUnboxer.unbox(key: "total")
        self.characters = try dataUnboxer.unbox(key: "results", allowInvalidElements: false)
    }
}
