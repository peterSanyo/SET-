//
//  CardView.swift
//  SET!
//
//  Created by Péter Sanyó on 16.10.23.
//
/// A SwiftUI View for rendering an individual card in the SET game.
///
/// This view is responsible for displaying the visual representation of a card, including its shape, number, shading,
/// color, and selection state. It uses a `ShapeView` for each symbol on the card and adapts the card's appearance
/// based on its match state.
///
/// Properties:
/// - `viewModel`: An observable object of `SetGameViewModel` which provides game logic and rendering functions.
/// - `card`: The `Card` object to be displayed.
/// - `isAppearing`: A state indicating whether the card is currently appearing in an animation.
///
/// The card's appearance changes based on its match state, such as highlighted borders for selected cards or
/// different background colors for matched or mismatched cards. The view also handles tap gestures to trigger
/// the SetGame logic related to card selection.

import SwiftUI

struct CardView: View {
    @ObservedObject var setGame: SetGameViewModel
    @State private var isAppearing = false
    var card: Card

    var body: some View {
        ZStack {
            cardBackground
            cardContent
        }
        .scaleEffect(isAppearing ? 1 : 0.1)
        .opacity(isAppearing ? 1 : 0)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibilityDescription)
        .onAppear {
            withAnimation {
                isAppearing = true
            }
        }
        .onTapGesture {
            withAnimation {
                setGame.setGameLogic(card: card)
            }
        }
    }

    // MARK: - UI Elements

    private var cardBackground: some View {
        Group {
            let baseRectangle = RoundedRectangle(cornerRadius: Constants.cornerRadius, style: .continuous)

            baseRectangle
                .fill(colorForMatchState(card.matchState))
                .strokeBorder(
                    lineWidth: card.matchState == .selected ? Constants.selectedLineWidth : Constants.unselectedLineWidth)
                .foregroundColor(Color.white)
                .background(Material.regular, in: baseRectangle)
        }
    }

    private var cardContent: some View {
        VStack {
            ForEach(0 ..< card.number.rawValue, id: \.self) { _ in
                ShapeView(setGame: setGame, shape: card.shape, shading: card.shading, color: card.color, symbolAspectRatio: Constants.symbolAspectRatio)
                    .aspectRatio(Constants.symbolAspectRatio, contentMode: .fit)
            }
        }
        .padding(10)
    }
    
    // MARK: - UI Logic 

    private func colorForMatchState(_ matchState: Card.MatchState) -> Color {
        switch matchState {
        case .matched:
            return Color.green.opacity(0.2)
        case .mismatched:
            return Color.red.opacity(0.2)
        case .selected:
            return Color.gray.opacity(0.4)
        case .hinted:
            return Color.yellow.opacity(0.4)
        default:
            return Color.clear
        }
    }

    // MARK: - Constants

    private enum Constants {
        static let cornerRadius: CGFloat = 12
        static let unselectedLineWidth: CGFloat = 2
        static let selectedLineWidth: CGFloat = 5
        static let cardAspectRatio: CGFloat = 2 / 3
        static let symbolAspectRatio: CGFloat = 1
    }

    // MARK: Accessibility

    private var accessibilityDescription: String {
        var description = "Card with \(card.number.rawValue) \(card.shape) in \(card.color) color and \(card.shading) shading"

        switch card.matchState {
        case .matched:
            description += ". Matched."
        case .mismatched:
            description += ". Mismatched."
        case .selected:
            description += ". Selected."
        default:
            break
        }
        return description
    }
}

// MARK: - Preview

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        let setGame = SetGameViewModel()
        let sampleCard = Card(
            number: .three,
            shape: .circle,
            shading: .solid,
            color: .blue
        )

        CardView(setGame: setGame, card: sampleCard)
    }
}
