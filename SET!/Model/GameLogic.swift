//
//  SetGameLogic.swift
//  SET!
//
//  Created by Péter Sanyó on 16.10.23.
//

import SwiftUI

struct GameLogic {
    private(set) var deckOfCards: [Card]

    var displayedCards: [Card] {
        Array(deckOfCards.prefix(12))
    }

    private(set) var currentlySelected: [Card] = []
    private(set) var stackOfSets: [Card] = []

    var score: Int {
        stackOfSets.count
    }

    init() {
        var createdDeck: [Card] = []
        currentlySelected.removeAll()

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

        self.deckOfCards = createdDeck.shuffled()
    }

    mutating func isValidSetOfCards(cards: [Card]) -> Bool {
        guard cards.count == 3 else { return false }

        return isPropertyUniformOrDistinct(\.number, cards) &&
            isPropertyUniformOrDistinct(\.shape, cards) &&
            isPropertyUniformOrDistinct(\.shading, cards) &&
            isPropertyUniformOrDistinct(\.color, cards)
    }

    private func isPropertyUniformOrDistinct<T: Hashable>(_ keyPath: KeyPath<Card, T>, _ cards: [Card]) -> Bool {
        let values = cards.map { $0[keyPath: keyPath] }
        let uniqueValues = Set(values)
        return uniqueValues.count == 1 || uniqueValues.count == cards.count
    }

    mutating func select(card: Card) {
        if currentlySelected.contains(card) {
            currentlySelected.removeAll { $0.id == card.id }
        } else {
            currentlySelected.append(card)
            if currentlySelected.count == 3 {
                if isValidSetOfCards(cards: currentlySelected) {
                    handleValidSet()
                }
                currentlySelected.removeAll()
            }
        }
        print("currentlySelected: \(currentlySelected)")
        print("stackOfSets: \(stackOfSets)")
    }

    private mutating func handleValidSet() {
        stackOfSets.append(contentsOf: currentlySelected)
        deckOfCards.removeAll { card in
            currentlySelected.contains(where: { $0.id == card.id })
        }
    }

    // Optional: Implement a method to deal additional cards if needed
    private mutating func dealAdditionalCardsIfNeeded() {
        // Deal additional cards logic
    }

    mutating func shuffle() {
        deckOfCards.shuffle()
    }
}
