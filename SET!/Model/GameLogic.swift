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
    
    mutating func toggleCardSelection(card: Card) {
        if let index = deckOfCards.firstIndex(where: { $0.id == card.id }) {
            deckOfCards[index].isSelected.toggle()
        }
    }

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

    // Method to reset the selection
    mutating func resetSelection() {
        for card in deckOfCards where card.isSelected {
            if let index = deckOfCards.firstIndex(where: { $0.id == card.id }) {
                deckOfCards[index].isSelected = false
                deckOfCards[index].matchState = .unselected
            }
        }
    }

    mutating func handleValidSet() {
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
        withAnimation {
            deckOfCards.shuffle()
        }
    }
}
