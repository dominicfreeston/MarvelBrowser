import Foundation
import RxSwift

protocol MarvelCharactersUseCaseType {
    func characters() -> Observable<MarvelCharactersList>
    func loadMoreCharacters()
}

class MarvelCharactersUseCase: MarvelCharactersUseCaseType {
    private let apiDataSource: MarvelCharactersDataSource
    private let charactersCache = Variable(MarvelCharactersList.empty)
    private var currentlyLoading = false
    private let disposeBag = DisposeBag()

    init(apiDataSource: MarvelCharactersDataSource) {
        self.apiDataSource = apiDataSource
    }

    func characters() -> Observable<MarvelCharactersList> {
        return charactersCache.asObservable()
    }

    func loadMoreCharacters() {
        guard !currentlyLoading else {
            return
        }

        currentlyLoading = true
        let stopLoading = { self.currentlyLoading = false }

        let count = charactersCache.value.characters.count
        apiDataSource
            .characters(atOffset: count)
            .subscribe(
                onNext: updateCharactersList,
                onDisposed: stopLoading)
            .addDisposableTo(disposeBag)
    }

    private func updateCharactersList(response: CharactersResponse) {
        let currentCharacters = charactersCache.value.characters
        let allCharacters = currentCharacters + response.characters
        let moreAvailable = response.total > allCharacters.count

        charactersCache.value = MarvelCharactersList(
            characters: allCharacters,
            moreAvailable: moreAvailable
        )
    }
}
