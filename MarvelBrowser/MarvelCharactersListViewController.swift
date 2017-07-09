import UIKit
import PureLayout
import RxSwift

let MARVEL_USE_CASE = MarvelCharactersUseCase(apiDataSource: FakeMarvelCharactersDataSource())

class MarvelCharacterListViewController: UIViewController {
    private let listView = MarvelCharacterListView()
    private let useCase: MarvelCharactersUseCaseType
    private let disposeBag = DisposeBag()

    init(useCase: MarvelCharactersUseCaseType = MARVEL_USE_CASE) {
        self.useCase = useCase

        super.init(nibName: nil, bundle: nil)

        listView.adapter.loadMoreAction = { [useCase] in
            useCase.loadMoreCharacters()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "All Characters"

        view.addSubview(listView)
        listView.autoPinEdgesToSuperviewEdges()

        useCase
            .characters()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: listView.update)
            .addDisposableTo(disposeBag)
    }
}
