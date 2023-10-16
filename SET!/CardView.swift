//
//  CardView.swift
//  SET!
//
//  Created by Péter Sanyó on 16.10.23.
//

import SwiftUI

struct CardView: View {
    var card: Card
    
    let symbolSize: CGSize = CGSize(width: 100, height: 100)

    
    
    var body: some View {
            VStack {
                ForEach(0..<card.number.rawValue, id: \.self) { _ in
                    Image(systemName: card.shape.sfSymbolName)
                        .resizable()
                        .frame(width: symbolSize.width, height: symbolSize.height)
                        .foregroundColor(card.color.toColor().opacity(card.shading.toOpacity()))
                        .padding(5)
                }
            }
            .cardify(isFaceUp: true)
            .padding()
        }
}



struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleCard = Card(
            number: .three,
            shape: .oval,
            shading: .open,
            color: .red
        )
        
        return CardView(card: sampleCard)
    }
}
