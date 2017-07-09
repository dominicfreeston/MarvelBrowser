import Foundation

struct MarvelCharactersList {
    let characters: [MarvelCharacter]

    static var empty: MarvelCharactersList {
        return MarvelCharactersList(
            characters: []
        )
    }
}
