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

    var body: some View {
        GeometryReader { geometry in
            let lineWidth: CGFloat = 3
            let insetRect = CGRect(origin: .zero, size: geometry.size).insetBy(dx: lineWidth / 2, dy: lineWidth / 2)
            let path = viewModel.path(for: shape, in: shading == .open ? insetRect : CGRect(origin: .zero, size: geometry.size))
            let fillColor = viewModel.applyColoring(for: color)

            if shading == .open {
                path.stroke(fillColor, lineWidth: lineWidth)
            } else {
                viewModel.path(for: shape, in: CGRect(origin: .zero, size: geometry.size))
                    .stroke(fillColor, lineWidth: lineWidth)
                    .fill(fillColor).opacity(viewModel.applyShadingOpacity(for: shading))
            }
        }
        .minimumScaleFactor(1 / 20)
        .multilineTextAlignment(.center)
        .aspectRatio(1, contentMode: .fit)
//        .rotationEffect(.degrees(card.isMatched ? 360 : 0))
//        .animation(.spin(duration: 1), value: card.isMatched)
    }
}



struct ShapeView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = SetGameViewModel()
        ScrollView {
            ForEach(Card.Shape.allCases, id: \.self) { shape in
                ForEach(Card.Shading.allCases, id: \.self) { shading in
                    ForEach(Card.Color.allCases, id: \.self) { color in
                        ShapeView(viewModel: viewModel, shape: shape, shading: shading, color: color)
                            .frame(width: 100, height: 150) // Example small size
                            .previewDisplayName("Small - \(shape) \(shading) \(color)")
                        ShapeView(viewModel: viewModel, shape: shape, shading: shading, color: color)
                            .frame(width: 200, height: 300) // Example large size
                            .previewDisplayName("Large - \(shape) \(shading) \(color)")
                    }
                }
            }
        }
    }
}
