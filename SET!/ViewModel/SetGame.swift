//
//  SetGame.swift
//  SET!
//
//  Created by Péter Sanyó on 16.10.23.
//

import SwiftUI

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
