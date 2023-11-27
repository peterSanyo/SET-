//  SetGame.swift
//  SET!
//
//  Created by Péter Sanyó on 16.10.23.
//

import SwiftUI

class SetGameViewModel: ObservableObject {
    // MARK: - Properties

    @Published var gameLogic = GameLogic()
    @Published private(set) var currentlySelected: [Card] = []
    var score: Int { gameLogic.score }
    var deckOfCards: [Card] { gameLogic.deckOfCards }
    
    // MARK: - Helper Functions
    
    func shuffle() {
        gameLogic.shuffle()
    }
    
    private func createSetGame() {
        gameLogic = GameLogic()
    }
    
    private func toggleSelectedCard(_ card: Card) {
        gameLogic.toggleSelectedCard(card)
    }
    
    private func unselectAllCards() {
        gameLogic.unselectAllCards()
    }
    
    private func updateMatchState(of card: Card, to newState: Card.MatchState) {
        gameLogic.updateMatchState(of: card, to: newState)
    }

    private func checkForValidSetOfCards(_ cards: [Card]) -> Bool {
        gameLogic.checkForValidSetOfCards(cards)
    }
    
    private func isPropertyConsistentlyUniformOrDistinct<T: Hashable>(keyPath: KeyPath<Card, T>, for cards: [Card]) -> Bool {
        return gameLogic.isPropertyConsistentlyUniformOrDistinct(keyPath: keyPath, for: cards)
    }
    
    private func handleValidatedSet(_ selectedCards: [Card]) {
        withAnimation {
            gameLogic.handleValidatedSet(selectedCards)
        }
    }
    
    // MARK: Set Game Logic

    /// Processes the selection of a card and manages the game logic based on the current state of the game.
    ///
    /// This function performs several tasks:
    /// - Toggles the selection state of the specified card.
    /// - Checks if there are three selected cards.
    /// - If there are three selected cards, it checks if they form a valid set.
    /// - Updates the match state of each selected card depending on whether they form a valid set.
    /// - Handles the validated set if the selected cards form a valid set.
    /// - Resets the selection of cards after processing.
    ///
    /// - Parameter card: The `Card` object to be processed.
    func setGameLogic(card: Card) {
        toggleSelectedCard(card)
        let selectedCards = deckOfCards.filter { $0.matchState == .selected }
        
        if selectedCards.count == 3 {
            let isMatch = checkForValidSetOfCards(selectedCards)
            for selectedCard in selectedCards {
                updateMatchState(of: selectedCard, to: isMatch ? .matched : .mismatched)
            }
            if isMatch {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.handleValidatedSet(selectedCards)
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.unselectAllCards()
            }
        }
    }
    
    // MARK: - Drawing Shapes
    
    func drawPath(for shape: Card.Shape, in rect: CGRect) -> Path {
        switch shape {
        case .diamond:
            return createDiamondPath(in: rect)
        case .squiggle:
            return rectanglePath(in: rect)
        case .oval:
            return ovalPath(in: rect)
        }
    }
    
    private func createDiamondPath(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
        path.closeSubpath()
        return path
    }
    
    private func rectanglePath(in rect: CGRect) -> Path {
        return Path(rect)
    }
    
    private func ovalPath(in rect: CGRect) -> Path {
        return Path(ellipseIn: rect)
    }
    
    // MARK: - Coloring Shapes
    
    func applyColoring(for cardColor: Card.Color) -> Color {
        switch cardColor {
        case .red: return Color.red
        case .green: return Color.green
        case .blue: return Color.blue
        }
    }
    
    // MARK: - Shading Shapes
    
    func applyShadingOpacity(for shading: Card.Shading) -> Double {
        switch shading {
        case .solid: return 1
        case .striped: return 0.5
        case .open: return 0.0
        }
    }
}
