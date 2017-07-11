import UIKit
import PureLayout
import RxSwift
import RxCocoa
import Dwifft

let MARVEL_USE_CASE = MarvelCharactersUseCase(
    apiDataSource: MarvelAPICharactersDataSource(),
    storageDataSource: MarvelCharactersDiskDataSource()
)

struct DiffedList {
    let sectionedValues: SectionedValues<Int, CharactersListItem>
    let diff: [SectionedDiffStep<Int, CharactersListItem>]
}

extension DiffedList {
    init(_ previous: DiffedList, _ next: MarvelCharactersList) {
        let previous = previous.sectionedValues
        let next = next.asSectionedValues()

        self.sectionedValues = next

        let start = Date()
        self.diff = Dwifft.diff(lhs: previous, rhs: next)
        let totalTime = Date().timeIntervalSince(start)
        print("**** TOTAL TIME \(totalTime) *****")
    }

    static var empty: DiffedList {
        return DiffedList(
            sectionedValues: SectionedValues([]),
            diff: []
        )
    }
}

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

        Logging.URLRequests = { _ in return false }

        setupViews()
        setupLayout()

        listView.adapter.loadMoreAction = useCase.loadMoreCharacters

        useCase
            .characters()
            .scan(DiffedList.empty, accumulator: DiffedList.init)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: listView.update)
            .addDisposableTo(disposeBag)
    }

    @objc private func attributionButtonTapped() {
        navigator.goToMarvel()
    }

    private func setupViews() {
        title = L10n.Allcharacters.title
        attributionButton.setTitle(L10n.Marvel.attribution, for: .normal)
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
