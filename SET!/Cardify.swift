//
//  Cardify.swift
//  SET!
//
//  Created by Péter Sanyó on 16.10.23.
//
import SwiftUI

struct Cardify: ViewModifier {
    let isFaceUp: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            let baseRectangle = RoundedRectangle(cornerRadius: Constants.cornerRadius, style: .continuous)

            baseRectangle.strokeBorder(lineWidth: Constants.lineWidth)
                .background(baseRectangle.fill(.white))
                .overlay(content)
                .opacity(isFaceUp ? 1 : 0)
            
            baseRectangle.fill(Constants.customLinearGradient)
                .opacity(isFaceUp ? 0 : 1)
                
        }
        
    }
    
    private struct Constants {
        static let cornerRadius: CGFloat = 12
        static let lineWidth: CGFloat = 2
        
        static let customGradient: Gradient = Gradient(stops: [
            .init(color: Color("skyBlue"), location: 0.2),
            .init(color: Color("waterBlue"), location: 0.4),
            .init(color: Color("sunRed"), location: 0.8),
            .init(color: Color("dawnRed"), location: 1.0)
        ])
        
        static let customLinearGradient: LinearGradient = LinearGradient(
            gradient: customGradient,
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

extension View {
    func cardify(isFaceUp: Bool) -> some View {
        modifier(Cardify(isFaceUp: isFaceUp))
    }
}
