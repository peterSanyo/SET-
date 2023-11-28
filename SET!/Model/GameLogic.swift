//
//  SetGameLogic.swift
//  SET!
//
//  Created by Péter Sanyó on 16.10.23.
//
/// `GameLogic` manages the core mechanics of the SET game.
///
/// Properties:
/// - `deckOfCards`: An array of `Card` objects representing the deck used in the game.
/// - `displayedCards`: A subset of `deckOfCards` currently displayed to the player.
/// - `score`: The current score in the game.
/// - `initialDisplayCount`: The initial number of cards to display at the start of the game.
/// - `amountOfCardsAdded`: The number of cards to add when dealing additional cards.
///
/// Initialization:
/// - `init()`: Initializes a new game with a shuffled deck of cards and sets up the initial displayed cards.
///
/// Core Gameplay Methods:
/// - `restartGame()`: Resets the game to its initial state with a new shuffled deck and resets the score.
/// - `dealAdditionalCards()`: Adds a specified number of cards to the displayed cards from the deck.
///
/// Card Interaction Methods:
/// - `toggleSelectedCard(card:)`: Toggles the selection state of a given card.
/// - `updateMatchState(of:to:)`: Updates the match state of a specific card.
///
/// Game State Management:
/// - `unselectAllCards()`: Resets the match state of all displayed cards to `.unselected`.
/// - `handleValidatedSet(selectedCards:)`: Handles actions for a valid set, including updating the score and removing matched cards from the display.
///
/// Validation:
/// - `isValidSetOfCards(cards:)`: Checks if a given set of cards forms a valid set according to the game rules.
/// - `isPropertyConsistentlyUniformOrDistinct(keyPath:for:)`: Helper function to determine if the properties of cards are either all uniform or all distinct.
///
/// Hint Mechanism:
/// - `showHintFor(numberOfCards:)`: Highlights a specified number of cards that potentially form a valid set.
/// - `findPotentialSet()`: Searches for a potential valid set among the displayed cards.

import SwiftUI

struct GameLogic {
    private(set) var deckOfCards: [Card]
    private(set) var displayedCards: [Card] = []
    private(set) var score = 9
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

    // MARK: - Restart Game

    mutating func restartGame() {
        var newDeck: [Card] = []
        score = 9
        for number in Card.Number.allCases {
            for shape in Card.Shape.allCases {
                for shading in Card.Shading.allCases {
                    for color in Card.Color.allCases {
                        let card = Card(number: number, shape: shape, shading: shading, color: color)
                        newDeck.append(card)
                    }
                }
            }
        }
        deckOfCards = newDeck.shuffled()
        if deckOfCards.count >= initialDisplayCount {
            displayedCards = Array(deckOfCards.prefix(initialDisplayCount))
            deckOfCards.removeFirst(initialDisplayCount)
        }
    }

    // MARK: - Dealing Cards

    /// Deals additional cards from the deck to the displayed cards.
    ///
    /// This method adds a predefined number of new cards (3 by default) from the top of the deck to the displayed cards.
    /// It checks for at least 3 cards in the deck before dealing and  decreases the score by 3 points each time this method is called.
    ///
    /// - Returns: Nothing. Modifies the state of `displayedCards` and `deckOfCards`.
    mutating func dealAdditionalCards() {
        guard deckOfCards.count >= 3 else { return }

        let newCards = deckOfCards.prefix(3)
        displayedCards.append(contentsOf: newCards)
        deckOfCards.removeFirst(3)
    }

    func setIsAvailable() -> Bool {
        for i in 0..<displayedCards.count {
            for j in (i + 1)..<displayedCards.count {
                for k in (j + 1)..<displayedCards.count {
                    let threeCards = [displayedCards[i], displayedCards[j], displayedCards[k]]
                    if checkForValidSetOfCards(threeCards) {
                        return true
                    }
                }
            }
        }
        return false
    }

    mutating func penalise() {
        score -= 3
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
    func checkForValidSetOfCards(_ cards: [Card]) -> Bool {
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

    // MARK: - Set Handling

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
        score += 3
    }

    // MARK: - Hint Mechanism

    /// Highlights a number of cards that form a potential valid set.
    ///
    /// This method is used to provide hints to the player. It updates the match state of the specified number of cards
    /// from a potential valid set to `.hinted`. If no valid set is found, no action is taken.
    /// - Parameter numberOfCards: The number of cards to highlight as a hint.
    mutating func showHintFor(numberOfCards: Int) {
        guard let potentialSet = findPotentialSet(), potentialSet.count >= numberOfCards else { return }
        for index in 0..<numberOfCards {
            if let cardIndex = displayedCards.firstIndex(where: { $0.id == potentialSet[index].id }) {
                displayedCards[cardIndex].matchState = .hinted
            }
        }
    }

    /// This method iterates through the displayed cards to find a valid set according to the game rules.
    ///
    /// If a valid set is found, it returns the cards forming the set; otherwise, it returns `nil`.
    /// - Returns: An array of `Card` objects that form a valid set, or `nil` if no set is found.
    mutating func findPotentialSet() -> [Card]? {
        for i in 0..<displayedCards.count {
            for j in (i + 1)..<displayedCards.count {
                for k in (j + 1)..<displayedCards.count {
                    let threeCards = [displayedCards[i], displayedCards[j], displayedCards[k]]
                    if checkForValidSetOfCards(threeCards) {
                        return threeCards
                    }
                }
            }
        }
        return nil
    }
}
