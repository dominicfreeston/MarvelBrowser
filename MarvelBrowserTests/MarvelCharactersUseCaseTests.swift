import XCTest
import RxSwift

@testable import MarvelBrowser

class MarvelCharactersUseCaseTests: XCTestCase {

    var response: MarvelCharactersResponse {
        return try! MarvelCharactersResponse(json: loadJSON(named: "charactersResponse"))
    }

    class FakeDataSource: MarvelCharactersDataSource {
        let response: MarvelCharactersResponse
        var numberOfReponses = 0

        init(response: MarvelCharactersResponse) {
            self.response = response
        }

        func characters(atOffset: Int) -> Observable<MarvelCharactersResponse> {
            return Observable.just(response).do(onNext: { _ in self.numberOfReponses += 1 })
        }
    }

    var dataSource: FakeDataSource!
    var useCase: MarvelCharactersUseCase!
    var lastValue: MarvelCharactersList?
    var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()

        dataSource = FakeDataSource(response: response)
        useCase = MarvelCharactersUseCase(apiDataSource: dataSource)
        disposeBag = DisposeBag()

        useCase.characters().subscribe(onNext: { [weak self] in
            self?.lastValue = $0
        }).addDisposableTo(disposeBag)
    }

    func testUseCaseDoesntImmediatelyUseTheAPIDataSource() {
        XCTAssertEqual(dataSource.numberOfReponses, 0)
    }

    func testUseCaseImmediatelyReturnsAValueOnSubscription() {
        XCTAssertEqual(lastValue?.characters.count, 0)
        XCTAssertEqual(lastValue?.moreAvailable, true)
    }

    func testUseCaseFetchesDataFromAPIDataSourceOnLoadMore() {
        useCase.loadMoreCharacters()

        XCTAssertEqual(dataSource.numberOfReponses, 1)
        XCTAssertEqual(lastValue?.characters.count, 20)
        XCTAssertEqual(lastValue?.moreAvailable, true)
    }

    func testUseCaseAppendsNewDataToExistingData() {
        for _ in 0..<3 {
            useCase.loadMoreCharacters()
        }

        XCTAssertEqual(dataSource.numberOfReponses, 3)
        XCTAssertEqual(lastValue?.characters.count, 60)
        XCTAssertEqual(lastValue?.moreAvailable, true)
    }

    func testUseCaseSetMoreAvailableFalseWhenTotalReached() {
        for _ in 0..<75 {
            useCase.loadMoreCharacters()
        }

        XCTAssertEqual(lastValue?.moreAvailable, false)
    }
    
}
