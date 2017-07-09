import XCTest
import RxSwift

@testable import MarvelBrowser

class MarvelCharactersUseCaseTests: XCTestCase {

    var response: MarvelCharactersResponse {
        return try! MarvelCharactersResponse(json: loadJSON(named: "charactersResponse"))
    }

    class FakeAPIDataSource: MarvelCharactersDataSource {
        let response: MarvelCharactersResponse
        var numberOfReponses = 0

        init(response: MarvelCharactersResponse) {
            self.response = response
        }

        func characters(atOffset offset: Int) -> Observable<MarvelCharactersResponse> {
            return Observable.just(response.with(offset: offset)).do(onNext: { _ in self.numberOfReponses += 1 })
        }
    }

    class FakeStorageDataSource: MarvelCharactersDataSource {
        var response: MarvelCharactersResponse?
        var numberOfReponses = 0

        func characters(atOffset offset: Int) -> Observable<MarvelCharactersResponse> {
            if let response = response {
                return Observable.just(response.with(offset: offset)).do(onNext: { _ in self.numberOfReponses += 1 })
            }
            return Observable.empty()
        }
    }

    var apiDataSource: FakeAPIDataSource!
    var storageDataSource: FakeStorageDataSource!
    var useCase: MarvelCharactersUseCase!
    var lastValue: MarvelCharactersList?
    var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()

        apiDataSource = FakeAPIDataSource(response: response)
        storageDataSource = FakeStorageDataSource()

        useCase = MarvelCharactersUseCase(
            apiDataSource: apiDataSource,
            storageDataSource: storageDataSource,
            updateDataScheduler: CurrentThreadScheduler.instance
        )
        disposeBag = DisposeBag()

        useCase.characters().subscribe(onNext: { [weak self] in
            self?.lastValue = $0
        }).addDisposableTo(disposeBag)
    }

    func testUseCaseDoesntImmediatelyFetchData() {
        XCTAssertEqual(apiDataSource.numberOfReponses, 0)
        XCTAssertEqual(storageDataSource.numberOfReponses, 0)
    }

    func testUseCaseImmediatelyReturnsAValueOnSubscription() {
        XCTAssertEqual(lastValue?.characters.count, 0)
        XCTAssertEqual(lastValue?.moreAvailable, true)
    }

    func testUseCaseFetchesDataFromAPIDataSourceOnLoadMore() {
        useCase.loadMoreCharacters()

        XCTAssertEqual(apiDataSource.numberOfReponses, 1)
        XCTAssertEqual(lastValue?.characters.count, 20)
        XCTAssertEqual(lastValue?.moreAvailable, true)
    }

    func testUseCaseAppendsNewDataToExistingData() {
        for _ in 0..<3 {
            useCase.loadMoreCharacters()
        }

        XCTAssertEqual(apiDataSource.numberOfReponses, 3)
        XCTAssertEqual(lastValue?.characters.count, 60)
        XCTAssertEqual(lastValue?.moreAvailable, true)
    }

    func testUseCaseSetMoreAvailableFalseWhenTotalReached() {
        for _ in 0..<75 {
            useCase.loadMoreCharacters()
        }

        XCTAssertEqual(lastValue?.moreAvailable, false)
    }

    func testUseCaseFetchesDataFromStorageFirst() {
        storageDataSource.response = response

        useCase.loadMoreCharacters()

        XCTAssertEqual(apiDataSource.numberOfReponses, 0)
        XCTAssertEqual(storageDataSource.numberOfReponses, 1)
        XCTAssertEqual(lastValue?.characters.count, 20)
    }

    func testUseCaseFallsBackOnTheAPIAndCombinesTheData() {
        storageDataSource.response = response
        useCase.loadMoreCharacters()
        storageDataSource.response = nil
        useCase.loadMoreCharacters()

        XCTAssertEqual(apiDataSource.numberOfReponses, 1)
        XCTAssertEqual(storageDataSource.numberOfReponses, 1)
        XCTAssertEqual(lastValue?.characters.count, 40)
    }
}

private extension MarvelCharactersResponse {
    func with(offset: Int) -> MarvelCharactersResponse {
        return MarvelCharactersResponse(
            offset: offset,
            total: total,
            characters: characters
        )
    }
}
