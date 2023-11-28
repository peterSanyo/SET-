//
//  ShapeView.swift
//  SET!
//
//  Created by Péter Sanyó on 18.10.23.
//
/// This view is responsible for displaying a single shape that represents a card in the SET game.
/// It uses the properties of a `Card` (shape, shading, color) to create a corresponding visual representation.
///
/// Properties:
/// - `viewModel`: An observable object of `SetGameViewModel` which provides drawing functions and color application.
/// - `shape`: The shape of the card (e.g., diamond, square, circle) to be drawn.
/// - `shading`: The shading type of the shape (e.g., solid, semi-transparent, open).
/// - `color`: The color of the shape.
/// - `symbolAspectRatio`: The aspect ratio for the symbol to maintain its proportions.
///
/// The view uses a `GeometryReader` to adapt the shape to the available space and maintain aspect ratio.

import SwiftUI

struct ShapeView: View {
    @ObservedObject var setGame: SetGameViewModel
    var shape: Card.Shape
    var shading: Card.Shading
    var color: Card.Color
    let symbolAspectRatio: CGFloat

    var body: some View {
        GeometryReader { geometry in
            let lineWidth: CGFloat = 2
            let insetRect = CGRect(origin: .zero, size: geometry.size).insetBy(dx: lineWidth / 2, dy: lineWidth / 2)
            let path = setGame.drawPath(for: shape, in: shading == .open ? insetRect : CGRect(origin: .zero, size: geometry.size))
            let fillColor = setGame.applyColoring(for: color)

            if shading == .open {
                path.stroke(fillColor, lineWidth: lineWidth)
            } else {
                setGame.drawPath(for: shape, in: CGRect(origin: .zero, size: geometry.size))
                    .stroke(fillColor, lineWidth: lineWidth)
                    .fill(fillColor).opacity(setGame.applyShadingOpacity(for: shading))
            }
        }
        .minimumScaleFactor(1)
        .multilineTextAlignment(.center)
        .aspectRatio(symbolAspectRatio, contentMode: .fit)
    }
}
