//
//  Card.swift
//  SET!
//
//  Created by Péter Sanyó on 22.11.23.
//

import Foundation

struct Card: Identifiable, Equatable {
    var id = UUID()
    var number: Number
    var shape: Shape
    var shading: Shading
    var color: Color
    var matchState: MatchState = .unselected

    enum Number: Int, CaseIterable, Hashable {
        case one = 1, two = 2, three = 3
    }

    enum Shape: CaseIterable, Hashable {
        case diamond, square, circle
    }

    enum Shading: CaseIterable, Hashable {
        case solid, semi, open
    }

    enum Color: CaseIterable, Hashable {
        case red, green, blue
    }

    enum MatchState {
        case unselected, selected, matched, mismatched, hinted
    }
}
