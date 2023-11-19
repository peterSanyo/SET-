//
//  SetGame.swift
//  SET!
//
//  Created by Péter Sanyó on 16.10.23.
//

import SwiftUI

class SetGameViewModel: ObservableObject {
    @Published private var game: GameLogic
    @Published private(set) var selectedCards: [Card] = []
    
    init() {
        self.game = GameLogic()
        game.shuffle()
    }
    
    func select(card: Card) {
        if selectedCards.contains(card) {
            // Remove card from selected if it's already selected
            selectedCards.removeAll { $0.id == card.id }
        } else {
            selectedCards.append(card)
            if selectedCards.count == 3 {
                if game.isSet(cards: selectedCards) {
                    // Handle logic for a valid set
                    // You might want to update score or other game states here
                }
                // Clear or update the selected cards array based on your game rules
            }
        }
    }

    // MARK: - Drawing Shapes

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
    
    func path(for shape: Card.Shape, in rect: CGRect) -> Path {
        switch shape {
        case .diamond:
            return createDiamondPath(in: rect)
        case .squiggle:
            return rectanglePath(in: rect)
        case .oval:
            return ovalPath(in: rect)
        }
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
