import Foundation

struct MarvelCharactersList {
    let characters: [MarvelCharacter]
    let moreAvailable: Bool
    let errorOccured: Bool

    static var empty: MarvelCharactersList {
        return MarvelCharactersList(
            characters: [],
            moreAvailable: true,
            errorOccured: false
        )
    }
}
