import XCTest
import RxSwift

@testable import MarvelBrowser

class MarvelCharactersListViewControllerTests: XCTestCase {

    class MockUseCase: MarvelCharactersUseCaseType {
        let variable = Variable(MarvelCharactersList.empty)
        func characters() -> Observable<MarvelCharactersList> {
            return variable.asObservable()
        }

        func loadMoreCharacters() {

        }
    }

    func testThereIsNoRetainCycleInTheViewController() {
        weak var weak_viewController: MarvelCharacterListViewController?
        weak var weak_listView: MarvelCharacterListView?
        weak var weak_adapter: MarvelCharactersAdapter?
        weak var weak_useCase: MockUseCase?

        autoreleasepool {
            let useCase = MockUseCase()
            let listView = MarvelCharacterListView()
            let viewController = MarvelCharacterListViewController(
                useCase: useCase,
                listView: listView
            )

            weak_viewController = viewController
            weak_listView = listView
            weak_adapter = listView.adapter
            weak_useCase = useCase

            weak_viewController!.loadView()
            weak_viewController!.viewDidLoad()

            XCTAssertNotNil(weak_viewController)
            XCTAssertNotNil(weak_listView)
            XCTAssertNotNil(weak_adapter)
            XCTAssertNotNil(weak_useCase)
        }

        XCTAssertNil(weak_viewController)
        XCTAssertNil(weak_listView)
        XCTAssertNil(weak_adapter)
        XCTAssertNil(weak_useCase)
    }
}
