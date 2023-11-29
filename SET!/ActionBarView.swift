//
//  ActionBarView.swift
//  SET!
//
//  Created by Péter Sanyó on 28.11.23.
//


import SwiftUI

/// A SwiftUI View representing the action bar in the SET game.
///
/// This view contains the primary action buttons used in the game, including buttons for dealing cards, restarting the game,
/// and showing hints. It manages the layout and behavior of these buttons using the custom `CircleButton` view.
///
/// Properties:
/// - `setGame`: An observable object of `SetGameViewModel` which provides the necessary game logic functions.
///
/// The action bar is designed as a horizontal stack  of three key buttons - restart, deal  and hint. Each button
/// is customized for its specific purpose and is integrated with the game logic to perform corresponding actions.
struct ActionBarView: View {
    @ObservedObject var setGame: SetGameViewModel

    var body: some View {
        HStack {
            Spacer()
            restartButton
            Spacer()
            dealerButton
            Spacer()
            hintButton
            Spacer()
        }
    }

    // MARK: - UI Components

    var dealerButton: some View {
        CircleButton {
            setGame.dealMechanics()
        } label: { 
            Text("DEAL")
        }
        .disabled(setGame.deckOfCards.isEmpty)
    }

    var restartButton: some View {
        CircleButton {
            setGame.restartGame()
        } label: {
            Image(systemName: "arrow.triangle.2.circlepath")
        }
    }

    var hintButton: some View {
        CircleButton {
            showAndResetHint()
        } label: {
            Image(systemName: "questionmark")
        }
    }

    /// This struct defines a reusable button style used in the ActionBarView, which are adaptable based on the button's enabled state.
    private struct CircleButton<Label: View>: View {
        let action: () -> Void
        let label: () -> Label
        @Environment(\.isEnabled) var isEnabled

        var body: some View {
            Button {
                action()
            } label: {
                label()
                    .font(.headline.weight(.bold))
                    .foregroundColor(isEnabled ? Color.black : Color.gray)
                    .frame(width: 45, height: 45)
                    .padding()
                    .background(Circle().fill(isEnabled ? Material.thick : Material.thin))
                    .shadow(color: isEnabled ? Color.gray.opacity(0.6) : Color.clear, radius: 3)
            }
            .contentShape(Circle())
        }
    }

    // MARK: - UI Logic

    private func showAndResetHint() {
        withAnimation {
            setGame.showHint(numberOfCards: 3)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            setGame.unselectAllCards()
        }
    }
}

// MARK: - Preview

#Preview {
    ActionBarView(setGame: SetGameViewModel())
}
