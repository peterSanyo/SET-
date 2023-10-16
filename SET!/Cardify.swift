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
            
            baseRectangle.fill(.indigo.opacity(0.7))
                .opacity(isFaceUp ? 0 : 1)
                
        }
        
    }
    
    private struct Constants {
        static let cornerRadius: CGFloat = 12
        static let lineWidth: CGFloat = 2
    }
}

extension View {
    func cardify(isFaceUp: Bool) -> some View {
        modifier(Cardify(isFaceUp: isFaceUp))
    }
}
