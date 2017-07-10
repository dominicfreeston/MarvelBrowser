import Foundation
import RxSwift

protocol MarvelCharactersUseCaseType {
    func characters() -> Observable<MarvelCharactersList>
    func loadMoreCharacters()
}

class MarvelCharactersUseCase: MarvelCharactersUseCaseType {
    private let apiDataSource: MarvelCharactersDataSource
    private let storageDataSource: MarvelCharactersCachingDataSource
    private let charactersCache = Variable(MarvelCharactersList.empty)
    private let updateDataScheduler: ImmediateSchedulerType
    private let disposeBag = DisposeBag()

    private var currentlyLoading = false

    init(apiDataSource: MarvelCharactersDataSource,
         storageDataSource: MarvelCharactersCachingDataSource,
         updateDataScheduler: ImmediateSchedulerType = ConcurrentDispatchQueueScheduler(qos: .background)) {
        self.apiDataSource = apiDataSource
        self.storageDataSource = storageDataSource
        self.updateDataScheduler = updateDataScheduler
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

        storageDataSource
            .characters(atOffset: count)
            .ifEmpty(switchTo:
                apiDataSource.characters(atOffset: count)
            )
            .observeOn(updateDataScheduler)
            .subscribe(
                onNext: updateCharactersList,
                onDisposed: stopLoading)
            .addDisposableTo(disposeBag)
    }

    private func updateCharactersList(response: MarvelCharactersResponse) {
        storageDataSource.cache(response: response)

        let currentCharacters = charactersCache.value.characters
        let allCharacters = currentCharacters + response.characters
        let moreAvailable = response.total > allCharacters.count

        charactersCache.value = MarvelCharactersList(
            characters: allCharacters,
            moreAvailable: moreAvailable,
            errorOccured: false
        )
    }
}
