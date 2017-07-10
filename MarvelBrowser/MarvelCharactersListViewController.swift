import UIKit
import PureLayout
import RxSwift

let MARVEL_USE_CASE = MarvelCharactersUseCase(
    apiDataSource: MarvelAPICharactersDataSource(),
    storageDataSource: MarvelCharactersDiskDataSource()
)

class MarvelCharacterListViewController: UIViewController {
    private let listView: MarvelCharacterListView
    private let useCase: MarvelCharactersUseCaseType
    private let disposeBag = DisposeBag()

    init(useCase: MarvelCharactersUseCaseType = MARVEL_USE_CASE,
        listView: MarvelCharacterListView = MarvelCharacterListView()) {
        self.useCase = useCase
        self.listView = listView
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "All Characters"

        view.addSubview(listView)
        listView.autoPinEdgesToSuperviewEdges()

        listView.adapter.loadMoreAction = useCase.loadMoreCharacters

        useCase
            .characters()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: listView.update)
            .addDisposableTo(disposeBag)
    }
}
