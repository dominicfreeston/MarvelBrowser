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
        self.diff = DiffedList.diff(lhs: previous, rhs: next)
        let totalTime = Date().timeIntervalSince(start)
        print("**** TOTAL TIME \(totalTime) *****")
    }

    static var empty: DiffedList {
        return DiffedList(
            sectionedValues: SectionedValues([(0, []),(1, [])]),
            diff: []
        )
    }

    private static func diff(lhs: SectionedValues<Int, CharactersListItem>,
                             rhs: SectionedValues<Int, CharactersListItem>) -> [SectionedDiffStep<Int, CharactersListItem>] {
        // Append new items
        let charactersSectionIndex = 0
        let count = lhs.sectionsAndValues[charactersSectionIndex].1.count
        let newValues = rhs.sectionsAndValues[charactersSectionIndex].1.suffix(from: count)

        var operations = [SectionedDiffStep<Int, CharactersListItem>]()

        for (index, value) in newValues.enumerated() {
            operations.append(.insert(charactersSectionIndex, index + count, value))
        }

        // Update bottom cell
        let messagingSectionIndex = 1
        let previousState = lhs.sectionsAndValues[messagingSectionIndex].1.first
        let nextState = rhs.sectionsAndValues[messagingSectionIndex].1.first

        switch (previousState, nextState) {
        case (nil, .some(let value)):
            operations.append(.insert(messagingSectionIndex, 0, value))
        case (.some(let value), nil):
            operations.append(.delete(messagingSectionIndex, 0, value))
        case (.some(let val1), .some(let val2)):
            if val1 != val2 {
                operations.append(.delete(messagingSectionIndex, 0, val1))
                operations.append(.insert(messagingSectionIndex, 0, val2))
            }
        case (nil, nil):
            break
        }
        
        return operations
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
