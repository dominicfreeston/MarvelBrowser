import UIKit
import Dwifft

class MarvelCharactersAdapter: NSObject, UITableViewDataSource, UITableViewDelegate {
    var charactersList: MarvelCharactersList = .empty {
        didSet {
            let diffedList = DiffedList(oldValue, charactersList)
            processChanges(diffedList: diffedList)
        }
    }

    var loadMoreAction: (() -> Void)?

    private weak var tableView: UITableView?
    private var sectionedValues = DiffedList.empty.sectionedValues

    func setup(tableView: UITableView) {
        self.tableView = tableView

        tableView.register(TableViewCell<MarvelCharacterView>.self)
        tableView.register(TableViewCell<LoadingMoreView>.self)
        tableView.register(TableViewCell<LoadingErrorView>.self)

        tableView.estimatedRowHeight = .rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none

        tableView.dataSource = self
        tableView.delegate = self
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionedValues.sectionsAndValues.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionedValues.sectionsAndValues[section].1.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = sectionedValues.sectionsAndValues[indexPath.section].1[indexPath.row]

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

    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return sectionedValues.sectionsAndValues[indexPath.section].1[indexPath.row] == .error
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if sectionedValues.sectionsAndValues[indexPath.section].1[indexPath.row] == .error {
            loadMoreAction?()
        }
    }

    // Adapted from Dwifft
    func processChanges(diffedList: DiffedList) {
        let diff = diffedList.diff
        guard !diff.isEmpty, let tableView = self.tableView else { return }

        tableView.beginUpdates()
        sectionedValues = diffedList.sectionedValues
        for result in diff {
            switch result {
            case let .delete(section, row, _): tableView.deleteRows(at: [IndexPath(row: row, section: section)], with: .automatic)
            case let .insert(section, row, _): tableView.insertRows(at: [IndexPath(row: row, section: section)], with: .automatic)
            case let .sectionDelete(section, _): tableView.deleteSections(IndexSet(integer: section), with: .automatic)
            case let .sectionInsert(section, _): tableView.insertSections(IndexSet(integer: section), with: .automatic)
            }
        }
        tableView.endUpdates()
    }
}

