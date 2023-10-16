//
//  SetGame.swift
//  SET!
//
//  Created by Péter Sanyó on 16.10.23.
//

import SwiftUI

extension Card.Shape {
    var sfSymbolName: String {
        switch self {
        case .diamond:
            return "suit.diamond.fill"
        case .squiggle:
            return "rectangle.fill"
        case .oval:
            return "oval.fill"
        }
    }
}

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
    func toOpacity() -> Double {
        switch self {
        case .solid: return 1
        case .striped: return 0.5
        case .open: return 0.1
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
}
