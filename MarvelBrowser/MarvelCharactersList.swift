import Foundation

struct MarvelCharactersList {
    let characters: [MarvelCharacter]
    let moreAvailable: Bool

    static var empty: MarvelCharactersList {
        return MarvelCharactersList(
            characters: [],
            moreAvailable: true
        )
    }
}

extension MarvelCharactersList {
    init(characters: [MarvelCharacter]) {
        self.characters = characters
        self.moreAvailable = true
    }
}
