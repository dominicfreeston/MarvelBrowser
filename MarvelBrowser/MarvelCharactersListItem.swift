import Foundation

enum CharactersListItem: Equatable {
    case character(MarvelCharacter)
    case loadMore

    static func ==(lhs: CharactersListItem, rhs: CharactersListItem) -> Bool {
        switch (lhs, rhs) {
        case (.character(let a), .character(let b)):
            return a.identifier == b.identifier
        case (.loadMore, .loadMore):
            return true
        default:
            return false
        }
    }
}
