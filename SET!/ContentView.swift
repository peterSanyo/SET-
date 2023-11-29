//
//  ContentView.swift
//  SET!
//
//  Created by Péter Sanyó on 16.10.23.
//

import SwiftUI

/// `ContentView` is the main SwiftUI view for the SET! card game. It serves as the entry point to the user interface,
/// displaying the current state of the game managed by `SetGameViewModel`.
///
/// The view consists of:
/// - A pulsating background
/// - A title bar displaying the game's name and Score.
/// - An `AspectVGrid` that arranges the displayed cards in a grid layout with a specified aspect ratio.
/// - Each card is represented by a `CardView` which displays the card's properties and handles user interaction.
/// - An `ActionBarView` which provides controls for game actions like dealing new cards, restarting the game, and showing hints.
struct ContentView: View {
    @ObservedObject var setGame: SetGameViewModel
    @State private var backgroundAnimationStarts = false

    var body: some View {
        ZStack {
            pulsatingBackground
            VStack {
                header
                AspectVGrid(setGame.displayedCards, aspectRatio: 2 / 3) { card in
                    CardView(setGame: setGame, card: card)
                }

                ActionBarView(setGame: setGame)
            }
            .onAppear {
                backgroundAnimationStarts = true
            }
        }
    }
    private var header: some View {
        HStack {
            Text("SET!")
            Spacer()
            Text("Score: \(setGame.score)")
        }
        .font(.title)
        .padding()
    }
    
    private var pulsatingBackground: some View {
        Color(backgroundAnimationStarts ? Color.gray.opacity(0.4) : Color.gray.opacity(0.2))
            .animation(Animation.easeInOut(duration: 30).repeatForever(autoreverses: true), value: backgroundAnimationStarts)
            .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(setGame: SetGameViewModel())
    }
}
