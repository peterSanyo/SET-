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

                HStack {
                    Spacer()
                    scoreVisual
                    Spacer()
                    restartButton
                    Spacer()
                    dealerButton
                    Spacer()
                }
            }
            .padding()
            .onAppear {
                backgroundAnimationStarts = true
                print("onAppear: \(setGame.deckOfCards.count)")
            }
        }
    }

    private var pulsatingBackground: some View {
        Color(backgroundAnimationStarts ? Color.gray.opacity(0.4) : Color.gray.opacity(0.2))
        .animation(Animation.easeInOut(duration: 30).repeatForever(autoreverses: true), value: backgroundAnimationStarts)
        .ignoresSafeArea()
    }

    func circleButtonStyle<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        content()
            .font(.headline.weight(.bold))
            .foregroundColor(Color.black)
            .frame(width: 45, height: 45)
            .padding()
            .background(Circle()
                .fill(Material.thick))
            .shadow(color: Color.gray.opacity(0.6), radius: 3)
    }

    var dealerButton: some View {
        Button {
            setGame.dealAdditionalCards()
        } label: {
            circleButtonStyle {
                Text("DEAL")
            }
        }
        .disabled(setGame.deckOfCards.isEmpty)
    }

    var restartButton: some View {
        Button {
            setGame.restartGame()
        } label: {
            circleButtonStyle {
                Image(systemName: "arrow.triangle.2.circlepath")
            }
        }
    }

    var scoreVisual: some View {
        circleButtonStyle {
            Text("\(setGame.score)")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(setGame: SetGameViewModel())
    }
}
