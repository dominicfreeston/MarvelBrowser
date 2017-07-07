import Foundation
import Unbox

typealias CharacterIdentifier = Int

struct MarvelCharacter {
    let identifier: CharacterIdentifier
    let name: String
    let description: String
    let thumbnail: ImageAsset
}

extension MarvelCharacter: Unboxable {
    init(unboxer: Unboxer) throws {
        self.identifier = try unboxer.unbox(key: "id")
        self.name = try unboxer.unbox(key: "name")
        self.description = try unboxer.unbox(key: "description")
        self.thumbnail = try unboxer.unbox(key: "thumbnail")
    }
}
