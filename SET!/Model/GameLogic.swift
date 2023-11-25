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
        Array(deckOfCards.prefix(20))
    }

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

        self.deckOfCards = createdDeck.shuffled()
    }

    mutating func shuffle() {
        deckOfCards.shuffle()
    }

    // MARK: - Selection Handling

    mutating func toggleCardSelection(card: Card) {
        if let index = deckOfCards.firstIndex(where: { $0.id == card.id }) {
            // Manually toggle between .selected and .unselected
            deckOfCards[index].matchState = deckOfCards[index].matchState == .selected ? .unselected : .selected
        }
        checkAndHandleValidSet()
    }

    // Method to reset the selection
    mutating func resetSelection() {
        for index in deckOfCards.indices {
            // Set matchState to .unselected regardless of the current state
            deckOfCards[index].matchState = .unselected
        }
    }

    // MARK: - MatchState management

    mutating func updateCardMatchState(card: Card, to state: Card.MatchState) {
        if let index = deckOfCards.firstIndex(where: { $0.id == card.id }) {
            deckOfCards[index].matchState = state
        }
    }

    // Method to update the match state of a card
    mutating func updateMatchState(of card: Card, to newState: Card.MatchState) {
        if let index = deckOfCards.firstIndex(where: { $0.id == card.id }) {
            deckOfCards[index].matchState = newState
        }
    }

    // MARK: - Validation

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

    // MARK: - Set Handling

    private mutating func checkAndHandleValidSet() {
        let selectedCards = deckOfCards.filter { $0.matchState == .selected }
        if selectedCards.count == 3 {
            if isValidSetOfCards(cards: selectedCards) {
                handleValidSet(selectedCards: selectedCards)
            } else {
                // Handle mismatch logic if needed
            }
        }
    }

    mutating func handleValidSet(selectedCards: [Card]) {
        // Remove selectedCards from deckOfCards
        deckOfCards.removeAll { selectedCards.contains($0) }
        score += 10
    }

    // Optional: Implement a method to deal additional cards if needed
    private mutating func dealAdditionalCardsIfNeeded() {
        // Deal additional cards logic
    }
}
