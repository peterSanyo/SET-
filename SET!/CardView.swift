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

    var body: some View {
        ZStack {
            let baseRectangle = RoundedRectangle(cornerRadius: Constants.cornerRadius, style: .continuous)

            baseRectangle.strokeBorder(lineWidth: card.isSelected ? Constants.selectedLineWidth : Constants.unselectedLineWidth)
                .background(card.isSelected ? baseRectangle.fill(.gray.opacity(0.3)) : baseRectangle.fill(.white))
            VStack {
                ForEach(0 ..< card.number.rawValue, id: \.self) { _ in
                    ShapeView(viewModel: viewModel, shape: card.shape, shading: card.shading, color: card.color, symbolAspectRatio: Constants.symbolAspectRatio)
                        .aspectRatio(Constants.symbolAspectRatio, contentMode: .fit)
                }
            }
            .padding(10)
        }
        .aspectRatio(Constants.cardAspectRatio, contentMode: .fit)
        .onTapGesture {
            viewModel.select(card)
        }
    }

    private enum Constants {
        static let cornerRadius: CGFloat = 12
        static let unselectedLineWidth: CGFloat = 2
        static let selectedLineWidth: CGFloat = 5
        static let cardAspectRatio: CGFloat = 2 / 3 // Example aspect ratio
        static let symbolAspectRatio: CGFloat = 1 // Symbol aspect ratio
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = SetGameViewModel()
        let sampleCard = Card(
            number: .three,
            shape: .oval,
            shading: .solid,
            color: .purple,
            isSelected: false
        )

        CardView(viewModel: viewModel, card: sampleCard)
    }
}
