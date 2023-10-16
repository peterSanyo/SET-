//
//  CardView.swift
//  SET!
//
//  Created by Péter Sanyó on 16.10.23.
//

import SwiftUI

struct CardView: View {
    var card: Card
    
    
    var body: some View {
        VStack {
            ForEach(0..<card.number.rawValue, id: \.self) { _ in
                Image(systemName: card.shape.sfSymbolName)
                    .resizable()
                    .scaledToFit()
                    .padding()

            }
        }
        .cardify(isFaceUp: true)
        .padding()

        
    }
    
//    @ViewBuilder
//    private func createShape() -> some View {
//        switch card.shape {
//        case .diamond: Diamond()
//        case .squiggle: Squiggle() // You'd need to design a squiggle shape.
//        case .oval: Capsule()
//        }
//    }
}



struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleCard = Card(
            number: .one,
            shape: .squiggle,
            shading: .solid,
            color: .red
        )
        
        return CardView(card: sampleCard)
    }
}
