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
    private(set) var displayedCards: [Card] = []
    private(set) var score = 0

    private(set) var initialDisplayCount = 12
    private let amountOfCardsAdded = 3

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

        deckOfCards = createdDeck.shuffled()

        if deckOfCards.count >= initialDisplayCount {
            displayedCards = Array(deckOfCards.prefix(initialDisplayCount))
            deckOfCards.removeFirst(initialDisplayCount)
        }
    }

    mutating func dealAdditionalCards() {
        // Ensure there are enough cards left in the deck
        guard deckOfCards.count >= 3 else { return }

        let newCards = deckOfCards.prefix(3)
        displayedCards.append(contentsOf: newCards)
        deckOfCards.removeFirst(3)

        // Debugging
        print("Dealt cards: \(newCards.map { $0.id })")
    }


    mutating func shuffle() {
        deckOfCards.shuffle()
    }

    // MARK: - Selection

    /// Toggles the selection state of a card in the game.
    ///
    /// If the card is already selected, it will be marked as unselected, and vice versa.
    /// - Parameter card: The `Card` object whose selection state needs to be toggled.
    mutating func toggleSelectedCard(_ card: Card) {
        if let index = displayedCards.firstIndex(where: { $0.id == card.id }) {
            displayedCards[index].matchState = displayedCards[index].matchState == .selected ? .unselected : .selected
        }
    }

    /// Sets the `matchState` of all cards in `displayedCards` to `.unselected`.
    mutating func unselectAllCards() {
        for index in displayedCards.indices {
            displayedCards[index].matchState = .unselected
        }
    }

    // MARK: - MatchState management

    /// Updates the match state of a specific card.
    ///
    /// - Parameters:
    ///   - card: The `Card` object whose match state is to be updated.
    ///   - newState: The new `MatchState` to be assigned to the card.
    mutating func updateMatchState(of card: Card, to newState: Card.MatchState) {
        if let index = displayedCards.firstIndex(where: { $0.id == card.id }) {
            displayedCards[index].matchState = newState
        }
    }

    // MARK: - Validation

    /// Validates whether a set of cards forms a valid set according to the game rules.
    ///
    /// A set is valid if the properties of the cards are either all the same or all different.
    /// - Parameter cards: An array of `Card` objects to be validated.
    /// - Returns: `true` if the set of cards is valid; otherwise, `false`.
    mutating func checkForValidSetOfCards(_ cards: [Card]) -> Bool {
        guard cards.count == 3 else { return false }

        return isPropertyConsistentlyUniformOrDistinct(keyPath: \.number, for: cards) &&
            isPropertyConsistentlyUniformOrDistinct(keyPath: \.shape, for: cards) &&
            isPropertyConsistentlyUniformOrDistinct(keyPath: \.shading, for: cards) &&
            isPropertyConsistentlyUniformOrDistinct(keyPath: \.color, for: cards)
    }

    /// Determines whether properties of the given cards are either all uniform or all distinct.
    ///
    /// - Parameters:
    ///   - keyPath: The key path to the property of `Card` to be checked.
    ///   - cards: An array of `Card` objects to be evaluated.
    /// - Returns: `true` if the values are all the same or all distinct; otherwise, `false`.
    func isPropertyConsistentlyUniformOrDistinct<T: Hashable>(keyPath: KeyPath<Card, T>, for cards: [Card]) -> Bool {
        let values = cards.map { $0[keyPath: keyPath] }
        let uniqueValues = Set(values)
        return uniqueValues.count == 1 || uniqueValues.count == cards.count
    }

    // MARK: - Handling

    /// Removes the matched cards from `displayedCards` and updates the score.
    ///
    /// - Parameters:
    ///    -  selectedCards : An array of `Card` objects that form a valid set.
    mutating func handleValidatedSet(_ selectedCards: [Card]) {
        displayedCards.removeAll { card in
            selectedCards.contains { selectedCard in
                selectedCard.id == card.id
            }
        }
        score += 1
    }

    // TODO: Implement a method to deal additional cards if needed
    private mutating func dealAdditionalCardsIfNeeded() {
        // Deal additional cards logic
    }
}
