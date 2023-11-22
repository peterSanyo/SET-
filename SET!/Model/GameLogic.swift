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
    private(set) var selectedCards: [Card] = []
    

    init() {
        var createdDeck: [Card] = []

        selectedCards.removeAll()

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
        if selectedCards.contains(card) {
            // Remove card from selected if it's already selected
            selectedCards.removeAll { $0.id == card.id }
        } else {
            selectedCards.append(card)
            if selectedCards.count == 3 {
                if isValidSetOfCards(cards: selectedCards) {
                    // Handle logic for a valid set
                    // You might want to update score or other game states here
                }
                // Clear or update the selected cards array based on your game rules
            }
        }
    }

    mutating func shuffle() {
        deck.shuffle()
    }
}
