import XCTest
@testable import MarvelBrowser

class MarvelCharactersAdapterTests: XCTestCase {

    var adapter: MarvelCharactersAdapter!
    var tableView: UITableView!
    var cell: UITableViewCell!

    var characters: MarvelCharactersList {
        let response = try! CharactersResponse(json: loadJSON(named: "charactersResponse"))
        return MarvelCharactersList(characters: response.characters)
    }

    override func setUp() {
        super.setUp()
        tableView = UITableView()
        adapter = MarvelCharactersAdapter()
        adapter.setup(tableView: tableView)
        adapter.charactersList = characters
        cell = adapter.tableView(tableView, cellForRowAt: IndexPath(row: 2, section: 0))
    }

    func testItSetsUpTableViewForSelfSizingCells() {
        XCTAssertEqual(tableView.rowHeight, UITableViewAutomaticDimension)
    }

    func testItReturnsTheExpectedCellType() {
        XCTAssert(cell is TableViewCell<MarvelCharacterView>)
    }

    func testItUpdatesTheCellWithExpectedValue() {
        let view = (cell as? TableViewCell<MarvelCharacterView>)?.view
        XCTAssertEqual(view?.nameLabel.text, "A.I.M.")
    }

    func testItTriggersTheLoadActionWhenDisplayingALoadingMoreCell() {
        var called = false

        adapter.loadMoreAction = {
            called = true
        }

        adapter.tableView(tableView, willDisplay: TableViewCell<LoadingMoreView>(), forRowAt: IndexPath(row: 0, section: 2))

        XCTAssertTrue(called)
    }
}
