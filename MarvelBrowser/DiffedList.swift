import Foundation
import Dwifft

struct DiffedList {
    let sectionedValues: SectionedValues<Int, CharactersListItem>
    let diff: [SectionedDiffStep<Int, CharactersListItem>]
}

extension DiffedList {
    init(_ previous: DiffedList, _ next: MarvelCharactersList) {
        let previous = previous.sectionedValues
        let next = next.asSectionedValues()

        self.sectionedValues = next
        self.diff = DiffedList.diff(lhs: previous, rhs: next)
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

        // Update messaging (loading/error) cell
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
