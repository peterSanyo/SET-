//
//  ContentView.swift
//  SET!
//
//  Created by Péter Sanyó on 16.10.23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var setGame: SetGameViewModel

    var body: some View {
        VStack {
            Text("SET!")
                .font(.largeTitle)
            AspectVGrid(setGame.displayedCards, aspectRatio: 2 / 3) { card in
                CardView(viewModel: setGame, card: card)
            }

            HStack {
                Spacer()
                Text("Score: \(setGame.score)")
                    .font(.title)
                Spacer()
                Button("Restart") {
                    setGame.restartGame()
                }
                Spacer()
                Button("Deal") {
                    setGame.dealAdditionalCards()
                }
                Spacer()
            }
        }
        .padding()
        .onAppear {
            print("onAppear: \(setGame.deckOfCards.count)")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(setGame: SetGameViewModel())
    }
}
