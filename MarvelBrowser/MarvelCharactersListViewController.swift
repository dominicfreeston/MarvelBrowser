import UIKit
import PureLayout
import RxSwift

let MARVEL_USE_CASE = MarvelCharactersUseCase(
    apiDataSource: MarvelAPICharactersDataSource(),
    storageDataSource: MarvelCharactersDiskDataSource()
)

class MarvelCharacterListViewController: UIViewController {
    private let useCase: MarvelCharactersUseCaseType
    private let listView: MarvelCharacterListView
    private let navigator: MarvelCharacterListViewNavigator
    private let attributionButton = UIButton(type: .custom)
    private let disposeBag = DisposeBag()

    init(useCase: MarvelCharactersUseCaseType = MARVEL_USE_CASE,
         listView: MarvelCharacterListView = MarvelCharacterListView(),
         navigator: MarvelCharacterListViewNavigator = SimpleMarvelCharacterListViewNavigator()) {
        self.useCase = useCase
        self.listView = listView
        self.navigator = navigator
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupLayout()

        listView.adapter.loadMoreAction = useCase.loadMoreCharacters

        useCase
            .characters()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: listView.update)
            .addDisposableTo(disposeBag)
    }

    @objc private func attributionButtonTapped() {
        navigator.goToMarvel()
    }

    private func setupViews() {
        title = "All Characters"
        attributionButton.setTitle("Data provided by Marvel. © 2017 MARVEL", for: .normal)
        attributionButton.titleLabel?.font = .systemFont(ofSize: UIFont.smallSystemFontSize)
        attributionButton.addTarget(self, action: #selector(attributionButtonTapped), for: .touchUpInside)
    }

    private func setupLayout() {
        view.addSubview(listView)
        view.addSubview(attributionButton)
        listView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .bottom)
        attributionButton.autoPinEdge(toSuperviewEdge: .bottom)
        attributionButton.autoPinEdge(toSuperviewMargin: .trailing)
        attributionButton.autoPinEdge(.top, to: .bottom, of: listView)
        attributionButton.setContentHuggingPriority(UILayoutPriorityRequired, for: .vertical)
    }
}
