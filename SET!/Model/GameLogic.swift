//
//  SetGameLogic.swift
//  SET!
//
//  Created by Péter Sanyó on 16.10.23.
//

import SwiftUI

struct GameLogic {
    private(set) var deck: [Card]
    private(set) var score = 0

    init() {
        var createdDeck: [Card] = []

        for number in Card.Number.allCases {
            for shape in Card.Shape.allCases {
                for shading in Card.Shading.allCases {
                    for color in Card.Color.allCases {
                        let card = Card(number: number, shape: shape, shading: shading, color: color)
                        createdDeck.append(card)
                    }
                }
            }
        }
        self.deck = createdDeck
    }

    mutating func isSet(cards: [Card]) -> Bool {
        guard cards.count == 3 else { return false }

        return isSameOrDifferent(\.number, cards) &&
            isSameOrDifferent(\.shape, cards) &&
            isSameOrDifferent(\.shading, cards) &&
            isSameOrDifferent(\.color, cards)
    }

    private func isSameOrDifferent<T: Hashable>(_ keyPath: KeyPath<Card, T>, _ cards: [Card]) -> Bool {
        let values = cards.map { $0[keyPath: keyPath] }
        let uniqueValues = Set(values)
        return uniqueValues.count == 1 || uniqueValues.count == cards.count
    }
    
    mutating func shuffle() {
        deck.shuffle()
    }
}

struct Card: Identifiable, Equatable {
    var id = UUID()
    var number: Number
    var shape: Shape
    var shading: Shading
    var color: Color

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

    enum Color: CaseIterable, Hashable {
        case red, green, purple
    }
}
