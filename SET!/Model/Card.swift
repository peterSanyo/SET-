//
//  Card.swift
//  SET!
//
//  Created by Péter Sanyó on 22.11.23.
//

import Foundation

// MARK: - Card

struct Card: Identifiable, Equatable {
    var id = UUID()
    var number: Number
    var shape: Shape
    var shading: Shading
    var color: Color
    var isSelected = false

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

    enum Color: CaseIterable, Hashable {
        case red, green, purple
    }
}
