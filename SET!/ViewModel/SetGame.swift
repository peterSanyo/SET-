//  SetGame.swift
//  SET!
//
//  Created by Péter Sanyó on 16.10.23.
//

import SwiftUI

class SetGameViewModel: ObservableObject {
    @Published var gameLogic = GameLogic()
    @Published private(set) var currentlySelected: [Card] = []
    
    var score: Int {
        gameLogic.score
    }
    
    var deckOfCards: [Card] {
        gameLogic.deckOfCards
    }
    
    var displayedCards: [Card] {
        gameLogic.displayedCards
    }
    
    // MARK: - Helper Functions
    
    func createSetGame() {
        gameLogic = GameLogic()
    }
    
    func shuffle() {
        gameLogic.shuffle()
    }
    
    func select(card: Card) {
        gameLogic.toggleCardSelection(card: card)
        let isSelected = gameLogic.deckOfCards.first(where: { $0.id == card.id })?.isSelected ?? false
        
        if isSelected {
            currentlySelected.append(card)
            gameLogic.updateCardMatchState(card: card, to: .selected)
        } else {
            currentlySelected.removeAll { $0.id == card.id }
            gameLogic.updateCardMatchState(card: card, to: .unselected)
        }
        
        if currentlySelected.count == 3 {
            let isMatch = gameLogic.isValidSetOfCards(cards: currentlySelected)
            for selectedCard in currentlySelected {
                gameLogic.updateMatchState(of: selectedCard, to: isMatch ? .matched : .mismatched)
            }
            
            if isMatch {
                gameLogic.handleValidSet()
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.gameLogic.resetSelection()
                self.currentlySelected.removeAll()
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
        case .purple: return Color.purple
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
