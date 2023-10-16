//
//  SetGameLogic.swift
//  SET!
//
//  Created by Péter Sanyó on 16.10.23.
//

import SwiftUI

struct Card: Identifiable {
    var id = UUID()
    var number: Number
    var shape: Shape
    var shading: Shading
    var color: CardColor
    
    enum Number: Int, CaseIterable, Hashable {
        case one = 1
        case two = 2
        case three = 3
    }
    
    enum Shape: CaseIterable, Hashable {
        case diamond, squiggle, oval
    }
    
    enum Shading: CaseIterable, Hashable {
        case solid, striped, open
    }
    
    enum CardColor: CaseIterable, Hashable {
        case red, green, purple
    }
}

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


func isSet(cards: [Card]) -> Bool {
    guard cards.count == 3 else { return false }
    
    return isSameOrDifferent(\.number, cards) &&
           isSameOrDifferent(\.shape, cards) &&
           isSameOrDifferent(\.shading, cards) &&
           isSameOrDifferent(\.color, cards)
}

func isSameOrDifferent<T: Hashable>(_ keyPath: KeyPath<Card, T>, _ cards: [Card]) -> Bool {
    let values = cards.map { $0[keyPath: keyPath] }
    let uniqueValues = Set(values)
    return uniqueValues.count == 1 || uniqueValues.count == cards.count
}
