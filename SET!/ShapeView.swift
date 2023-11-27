//
//  ShapeView.swift
//  SET!
//
//  Created by Péter Sanyó on 18.10.23.
//
import SwiftUI

struct ShapeView: View {
    @ObservedObject var viewModel: SetGameViewModel
    var shape: Card.Shape
    var shading: Card.Shading
    var color: Card.Color
    let symbolAspectRatio: CGFloat

    var body: some View {
        GeometryReader { geometry in
            let lineWidth: CGFloat = 2
            let insetRect = CGRect(origin: .zero, size: geometry.size).insetBy(dx: lineWidth / 2, dy: lineWidth / 2)
            let path = viewModel.drawPath(for: shape, in: shading == .open ? insetRect : CGRect(origin: .zero, size: geometry.size))
            let fillColor = viewModel.applyColoring(for: color)

            if shading == .open {
                path.stroke(fillColor, lineWidth: lineWidth)
            } else {
                viewModel.drawPath(for: shape, in: CGRect(origin: .zero, size: geometry.size))
                    .stroke(fillColor, lineWidth: lineWidth)
                    .fill(fillColor).opacity(viewModel.applyShadingOpacity(for: shading))
            }
        }
        .minimumScaleFactor(1)
        .multilineTextAlignment(.center)
        .aspectRatio(symbolAspectRatio, contentMode: .fit)
    }
}
