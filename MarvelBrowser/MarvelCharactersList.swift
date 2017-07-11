import Foundation
import Dwifft

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

    func asSectionedValues() -> SectionedValues<Int, CharactersListItem> {
        let chars = characters.map(CharactersListItem.character)

        if errorOccured {
            return SectionedValues([(0, chars), (1, [.error])])
        } else if moreAvailable {
            return SectionedValues([(0, chars), (1, [.loadMore])])
        } else {
            return SectionedValues([(0, chars)])
        }
    }
}
