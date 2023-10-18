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

    var body: some View {
        GeometryReader { geometry in
            if shading == .open {
                viewModel.path(for: shape, in: CGRect(origin: .zero, size: geometry.size))
                    .stroke(Color.primary, lineWidth: 3)
            } else {
                viewModel.path(for: shape, in: CGRect(origin: .zero, size: geometry.size))
                    .fill(Color.primary)
//                    .opacity(viewModel.shadingOpacity(for: shading))
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
}



struct ShapeView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = SetGameViewModel()
        return Group {
            ForEach(Card.Number.allCases, id: \.self) { number in
                ForEach(Card.Shape.allCases, id: \.self) { shape in
                    ForEach(Card.Shading.allCases, id: \.self) { shading in
                        ShapeView(viewModel: viewModel, shape: shape, shading: shading)
                            .previewDisplayName("\(number) \(shape) \(shading)")
                    }
                }
            }
        }
    }
}
