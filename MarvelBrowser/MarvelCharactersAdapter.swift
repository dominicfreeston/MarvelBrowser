import UIKit
import Dwifft

class MarvelCharactersAdapter: NSObject, UITableViewDataSource, UITableViewDelegate {
    var charactersList = MarvelCharactersList.empty {
        didSet {
            diffCalculator.sectionedValues = charactersList.asSectionedValues()
        }
    }

    var loadMoreAction: (() -> Void)?
    var diffCalculator: TableViewDiffCalculator<Int, CharactersListItem>!

    func setup(tableView: UITableView) {
        diffCalculator = TableViewDiffCalculator(tableView: tableView)
        diffCalculator.insertionAnimation = .fade

        tableView.register(TableViewCell<MarvelCharacterView>.self)
        tableView.register(TableViewCell<LoadingMoreView>.self)
        tableView.register(TableViewCell<LoadingErrorView>.self)

        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none

        tableView.dataSource = self
        tableView.delegate = self
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return diffCalculator.numberOfSections()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diffCalculator.numberOfObjects(inSection: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = diffCalculator.value(atIndexPath: indexPath)

        switch item {
        case .character(let character):
            let cell: TableViewCell<MarvelCharacterView> = tableView.dequeueReusableCell(for: indexPath)
            cell.view.update(with: character)
            return cell
        case .loadMore:
            let cell: TableViewCell<LoadingMoreView> = tableView.dequeueReusableCell(for: indexPath)
            return cell
        case .error:
            let cell: TableViewCell<LoadingErrorView> = tableView.dequeueReusableCell(for: indexPath)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? TableViewCell<LoadingMoreView> {
            cell.view.start()
            loadMoreAction?()
        }
    }
}

private extension MarvelCharactersList {
    func asSectionedValues() -> SectionedValues<Int, CharactersListItem> {
        let chars = characters.map(CharactersListItem.character)

        if errorOccured {
            return SectionedValues([(0, chars), (1, [.error])])
        } else if moreAvailable {
            return SectionedValues([(0, chars), (1, [.loadMore])])
        } else {
            return SectionedValues([(0, chars)])
        }
    }
}

