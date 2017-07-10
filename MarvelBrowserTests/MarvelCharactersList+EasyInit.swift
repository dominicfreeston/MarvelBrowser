@testable import MarvelBrowser

extension MarvelCharactersList {
    init(characters: [MarvelCharacter],
         moreAvailable: Bool = true,
         errorOccured: Bool = false) {
        self.characters = characters
        self.moreAvailable = moreAvailable
        self.errorOccured = errorOccured
    }
}
