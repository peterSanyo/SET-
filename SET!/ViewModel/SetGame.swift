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
    
    func createSetGame() {
        gameLogic = GameLogic()
    }
    
    func shuffle() {
        gameLogic.shuffle()
    }
    
    func toggleSelectedCard(_ card: Card) {
        gameLogic.toggleSelectedCard(card)
    }
    
    func unselectAllCards() {
        gameLogic.unselectAllCards()
    }
    
    func updateMatchState(of card: Card, to newState: Card.MatchState) {
        gameLogic.updateMatchState(of: card, to: newState)
    }

    func checkForValidSetOfCards(_ cards: [Card]) -> Bool {
        gameLogic.checkForValidSetOfCards(cards)
    }
    
    func isPropertyConsistentlyUniformOrDistinct<T: Hashable>(keyPath: KeyPath<Card, T>, for cards: [Card]) -> Bool {
        return gameLogic.isPropertyConsistentlyUniformOrDistinct(keyPath: keyPath, for: cards)
    }
    
    func handleValidatedSet(_ selectedCards: [Card]) {
        gameLogic.handleValidatedSet(selectedCards)
    }
    
//    func updateMatchState
    
    // MARK: Selection Management

    func select(card: Card) {
        // Toggle the card's selection in the game logic
        gameLogic.toggleSelectedCard(card)

        // Check if there are three selected cards and handle them
        let selectedCards = gameLogic.deckOfCards.filter { $0.matchState == .selected }
        if selectedCards.count == 3 {
            let isMatch = gameLogic.checkForValidSetOfCards(selectedCards)
            
            // Update the match state of each selected card
            for selectedCard in selectedCards {
                gameLogic.updateMatchState(of: selectedCard, to: isMatch ? .matched : .mismatched)
            }
            
            // Handle the set if it's a valid match
            if isMatch {
                print("currently selected: \(selectedCards)")
                gameLogic.handleValidatedSet(selectedCards)
            }

            // Reset the selection after a delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.gameLogic.unselectAllCards()
            }
        }
        print("deckOfCards: \(deckOfCards.count)")
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
