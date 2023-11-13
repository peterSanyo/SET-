//
//  SetGameLogic.swift
//  SET!
//
//  Created by Péter Sanyó on 16.10.23.
//

import SwiftUI

struct Card: Identifiable {
    var id = UUID()
    var number: Number
    var shape: Shape
    var shading: Shading
    var color: CardColor

    enum Number: Int, CaseIterable, Hashable {
        case one = 1
        case two = 2
        case three = 3
    }

    enum Shape: CaseIterable, Hashable {
        case diamond, squiggle, oval
    }

    enum Shading: CaseIterable, Hashable {
        case solid, striped, open
    }

    enum CardColor: CaseIterable, Hashable {
        case red, green, purple
    }
}

func isSet(cards: [Card]) -> Bool {
    guard cards.count == 3 else { return false }

    return isSameOrDifferent(\.number, cards) &&
        isSameOrDifferent(\.shape, cards) &&
        isSameOrDifferent(\.shading, cards) &&
        isSameOrDifferent(\.color, cards)
}

func isSameOrDifferent<T: Hashable>(_ keyPath: KeyPath<Card, T>, _ cards: [Card]) -> Bool {
    let values = cards.map { $0[keyPath: keyPath] }
    let uniqueValues = Set(values)
    return uniqueValues.count == 1 || uniqueValues.count == cards.count
}
