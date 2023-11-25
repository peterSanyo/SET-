//
//  SetGameLogic.swift
//  SET!
//
//  Created by Péter Sanyó on 16.10.23.
//

import SwiftUI

/// `GameLogic` manages the core mechanics of the SET game.
///
/// - Properties:
///   - `deckOfCards`: An array of `Card` objects representing the deck used in the game.
///   - `displayedCards`: A subset of `deckOfCards` used for display, typically the top 20 cards.
///   - `score`: The current score in the game.
///
/// - Methods:
///   - `init()`: Initializes a new game with a shuffled deck of cards.
///   - `shuffle()`: Shuffles the `deckOfCards`.
///   - `toggleCardSelection(card:)`: Toggles the selection state of a given card.
///   - `resetSelection()`: Resets the selection state of all cards to `.unselected`.
///   - `updateMatchState(of:to:)`: Updates the match state of a specific card.
///   - `isValidSetOfCards(cards:)`: Checks if a given set of cards forms a valid set according to the game rules.
///   - `handleValidSet(selectedCards:)`: Handles actions for a valid set, including score update and removing matched cards from the deck.

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

    /// Toggles the selection state of a card in the game.
    ///
    /// If the card is already selected, it will be marked as unselected, and vice versa.
    /// - Parameter card: The `Card` object whose selection state needs to be toggled.
    mutating func toggleCardSelection(card: Card) {
        if let index = deckOfCards.firstIndex(where: { $0.id == card.id }) {
            deckOfCards[index].matchState = deckOfCards[index].matchState == .selected ? .unselected : .selected
        }
    }

    /// Resets the selection state of all cards in the game.
    ///
    /// Sets the `matchState` of all cards in `deckOfCards` to `.unselected`.
    mutating func resetSelection() {
        for index in deckOfCards.indices {
            deckOfCards[index].matchState = .unselected
        }
    }

    // MARK: - MatchState management

    /// Updates the match state of a specific card.
    ///
    /// - Parameters:
    ///   - card: The `Card` object whose match state is to be updated.
    ///   - newState: The new `MatchState` to be assigned to the card.
    mutating func updateMatchState(of card: Card, to newState: Card.MatchState) {
        if let index = deckOfCards.firstIndex(where: { $0.id == card.id }) {
            deckOfCards[index].matchState = newState
        }
    }

    // MARK: - Validation

    /// Validates whether a set of cards forms a valid set according to the game rules.
    ///
    /// A set is valid if the properties of the cards are either all the same or all different.
    /// - Parameter cards: An array of `Card` objects to be validated.
    /// - Returns: `true` if the set of cards is valid; otherwise, `false`.
    mutating func isValidSetOfCards(cards: [Card]) -> Bool {
        guard cards.count == 3 else { return false }

        return isPropertyUniformOrDistinct(\.number, cards) &&
            isPropertyUniformOrDistinct(\.shape, cards) &&
            isPropertyUniformOrDistinct(\.shading, cards) &&
            isPropertyUniformOrDistinct(\.color, cards)
    }

    /// Determines whether properties of the given cards are either all uniform or all distinct.
    ///
    /// - Parameters:
    ///   - keyPath: The key path to the property of `Card` to be checked.
    ///   - cards: An array of `Card` objects to be evaluated.
    /// - Returns: `true` if the values are all the same or all distinct; otherwise, `false`.
    private func isPropertyUniformOrDistinct<T: Hashable>(_ keyPath: KeyPath<Card, T>, _ cards: [Card]) -> Bool {
        let values = cards.map { $0[keyPath: keyPath] }
        let uniqueValues = Set(values)
        return uniqueValues.count == 1 || uniqueValues.count == cards.count
    }

    // MARK: - Set Handling

    /// Checks and handles a valid set of selected cards.
    ///
    /// If three cards are selected, it checks if they form a valid set and handles the set accordingly.
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

    /// Handles the actions to be taken when a valid set is identified.
    ///
    /// This includes removing the matched cards from `deckOfCards` and updating the score.
    /// - Parameter selectedCards: An array of `Card` objects that form a valid set.
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
