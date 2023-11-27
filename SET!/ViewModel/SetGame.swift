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
        withAnimation {
            gameLogic.shuffle()
        }
    }
    
    private func createSetGame() {
        gameLogic = GameLogic()
    }

    // MARK: Set Game Logic

    /// Processes the selection of a card and manages the game logic based on the current state of the game.
    ///
    /// - Toggles the selection state of the specified card.
    /// - Checks if there are three selected cards.
    /// - If there are three selected cards, it checks if they form a valid set.
    /// - Updates the match state of each selected card depending on whether they form a valid set.
    /// - NOTE:a second delay in this part of the process here to give visual feedback
    /// - Handles the validated set if the selected cards form a valid set.
    /// - Resets the selection of cards after processing. Needed for resetting an unmatched selection of cards
    ///
    /// - Parameter card: The `Card` object to be processed.
    func setGameLogic(card: Card) {
        gameLogic.toggleSelectedCard(card)
        let selectedCards = deckOfCards.filter { $0.matchState == .selected }

        if selectedCards.count == 3 {
            let isMatch = gameLogic.checkForValidSetOfCards(selectedCards)
            for selectedCard in selectedCards {
                gameLogic.updateMatchState(of: selectedCard, to: isMatch ? .matched : .mismatched)
            }
            print("deckOfCards1: \(deckOfCards.count)")

            if isMatch {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    withAnimation {
                        self.gameLogic.handleValidatedSet(selectedCards)
                        print("deckOfCards2: \(self.deckOfCards.count)")
                    }
                }
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.gameLogic.unselectAllCards()
                print("deckOfCards3: \(self.deckOfCards.count)")
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
