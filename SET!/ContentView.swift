//
//  ContentView.swift
//  SET!
//
//  Created by Péter Sanyó on 16.10.23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var setGame: SetGameViewModel
    @State private var backgroundAnimationStarts = false

    var body: some View {
        ZStack {
            pulsatingBackground
            VStack {
                Text("SET!")
                    .font(.largeTitle)

                AspectVGrid(setGame.displayedCards, aspectRatio: 2 / 3) { card in
                    CardView(viewModel: setGame, card: card)
                }

                actionButtons
            }
            .padding()
            .onAppear {
                backgroundAnimationStarts = true
            }
        }
    }

    private var pulsatingBackground: some View {
        Color(backgroundAnimationStarts ? Color.gray.opacity(0.4) : Color.gray.opacity(0.2))
            .animation(Animation.easeInOut(duration: 30).repeatForever(autoreverses: true), value: backgroundAnimationStarts)
            .ignoresSafeArea()
    }

    private var actionButtons: some View {
        HStack {
            Spacer()
            hintButton
            Spacer()
            restartButton
            Spacer()
            dealerButton
            Spacer()
        }
    }

    var dealerButton: some View {
        CircleButton {
            setGame.dealMechanics()
        } label: { Text("DEAL") }
            .disabled(setGame.deckOfCards.isEmpty)
    }

    var restartButton: some View {
        CircleButton {
            setGame.restartGame()
        } label: { Image(systemName: "arrow.triangle.2.circlepath") }
    }

    var hintButton: some View {
        CircleButton {
            showAndResetHint()
        } label: {
            Image(systemName: "questionmark")
                .font(.headline.weight(.bold))
                .foregroundColor(Color.black)
        }
    }

    private func showAndResetHint() {
        withAnimation {
            setGame.showHint(numberOfCards: 3)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            setGame.unselectAllCards()
        }
    }

    private struct CircleButton<Label: View>: View {
        let action: () -> Void
        let label: () -> Label
        @Environment(\.isEnabled) var isEnabled

        init(action: @escaping () -> Void, @ViewBuilder label: @escaping () -> Label) {
            self.action = action
            self.label = label
        }

        var body: some View {
            Button(action: action) { label().buttonDesign() }
        }
    }

    struct ButtonDesign: ViewModifier {
        @Environment(\.isEnabled) var isEnabled

        func body(content: Content) -> some View {
            content
                .font(.headline.weight(.bold))
                .foregroundColor(isEnabled ? Color.black : Color.gray)
                .frame(width: 45, height: 45)
                .padding()
                .background(Circle().fill(isEnabled ? Material.thick : Material.thin))
                .shadow(color: isEnabled ? Color.gray.opacity(0.6) : Color.clear, radius: 3)
        }
    }
}

extension View {
    func buttonDesign() -> some View {
        modifier(ContentView.ButtonDesign())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(setGame: SetGameViewModel())
    }
}
