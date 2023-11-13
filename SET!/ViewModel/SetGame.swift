//
//  SetGame.swift
//  SET!
//
//  Created by Péter Sanyó on 16.10.23.
//

import SwiftUI

extension Card.CardColor {
    func toColor() -> Color {
        switch self {
        case .red: return Color.red
        case .green: return Color.green
        case .purple: return Color.purple
        }
    }
}

extension Card.Shading {
    func shadingOpacity(for shading: Card.Shading) -> Double {
        switch shading {
        case .solid: return 1
        case .striped: return 0.5
        case .open: return 0.0
        }
    }
}

class SetGameViewModel: ObservableObject {
    @Published private(set) var cards: [Card] = []
    @Published private(set) var selectedCards: [Card] = []
    
    init() {
        cards = createDeck()
        cards.shuffle()
    }
    
    func createDeck() -> [Card] {
        var deck: [Card] = []
        
        for number in Card.Number.allCases {
            for shape in Card.Shape.allCases {
                for shading in Card.Shading.allCases {
                    for color in Card.CardColor.allCases {
                        let card = Card(number: number, shape: shape, shading: shading, color: color)
                        deck.append(card)
                    }
                }
            }
        }
        
        return deck
    }
    
    func select(card: Card) {
        // Implement selection logic, and check if three cards make a set.
    }

    // MARK: UI
    
    private func diamondPath(in rect: CGRect) -> Path {
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
            return diamondPath(in: rect)
        case .squiggle:
            return rectanglePath(in: rect)
        case .oval:
            return ovalPath(in: rect)
        }
    }
    
    func color(for cardColor: Card.CardColor) -> Color {
        switch cardColor {
        case .red: return Color.red
        case .green: return Color.green
        case .purple: return Color.purple
        }
    }
    
//    func path(in rect: CGRect) -> Path {
//        switch self {
//        case .diamond:
//            return diamondPath(in: rect)
//        case .squiggle:
//            return rectanglePath(in: rect)
//        case .oval:
//            return ovalPath(in: rect)
//        }
//    }
}
