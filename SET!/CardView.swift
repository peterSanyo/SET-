//
//  CardView.swift
//  SET!
//
//  Created by Péter Sanyó on 16.10.23.
//

import SwiftUI

struct CardView: View {
    @ObservedObject var viewModel: SetGameViewModel
    var card: Card
    let symbolSize: CGSize = .init(width: 100, height: 100)

    var body: some View {
        VStack {
            ForEach(0 ..< card.number.rawValue, id: \.self) { _ in
                ShapeView(viewModel: viewModel, shape: card.shape, shading: card.shading)
                    .foregroundColor(viewModel.color(for: card.color))
                    .frame(width: symbolSize.width, height: symbolSize.height)
                    .padding(5)
            }
        }
        .cardify(isFaceUp: true) // Assuming you have this cardify modifier elsewhere in your code.
        .padding()
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = SetGameViewModel()
        let sampleCard = Card(
            number: .three,
            shape: .oval,
            shading: .striped,
            color: .red
        )

        return CardView(viewModel: viewModel, card: sampleCard)
    }
}
