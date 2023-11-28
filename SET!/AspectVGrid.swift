//
//  AspectVGrid.swift
//  SET!
//
//  Created by Péter Sanyó on 22.11.23.
//

import SwiftUI

/// A custom SwiftUI view that arranges its children in a grid layout with a specified aspect ratio.
/// This grid dynamically adjusts the size of each item to fit within the available space.
///
/// - Parameters:
///   - items: An array of `Identifiable` items to be displayed in the grid.
///   - aspectRatio: The aspect ratio to be maintained for each item in the grid.
///   - content: A closure that returns the view for each item in the grid.
struct AspectVGrid<Item: Identifiable, ItemView: View>: View {
    var items: [Item]
    var aspectRatio: CGFloat = 1
    var content: (Item) -> ItemView

    /// Initializes the grid view with the given items, aspect ratio, and content closure.
    init(_ items: [Item], aspectRatio: CGFloat, @ViewBuilder content: @escaping (Item) -> ItemView) {
        self.items = items
        self.aspectRatio = aspectRatio
        self.content = content
    }

    var body: some View {
        GeometryReader { geometry in
            let gridItemSize = calculateOptimalItemWidth(
                count: items.count,
                size: geometry.size,
                atAspectRatio: aspectRatio
            )
            LazyVGrid(columns: [GridItem(.adaptive(minimum: gridItemSize), spacing: 5)], spacing: 5) {
                ForEach(items, id: \.id) { item in
                    content(item)
                        .aspectRatio(aspectRatio, contentMode: .fit)
                }
            }
        }
    }

    /// Calculates the optimal width for each item in the grid based on the available size and the desired aspect ratio.
    ///
    /// - Parameters:
    ///   - count: The number of items to display.
    ///   - size: The available size for the grid.
    ///   - aspectRatio: The aspect ratio to be maintained for each item.
    /// - Returns: The optimal width for each item.
    func calculateOptimalItemWidth(
        count: Int,
        size: CGSize,
        atAspectRatio aspectRatio: CGFloat
    ) -> CGFloat {
        let spacing: CGFloat = 5
        var bestLayout = (rowCount: 0, columnCount: 0, cardSize: CGSize.zero)

        for columnCount in 1 ... count {
            let width = (size.width - CGFloat(columnCount - 1) * spacing) / CGFloat(columnCount)
            let height = width / aspectRatio
            let rowCount = ceil(CGFloat(count) / CGFloat(columnCount))
            let totalHeight = rowCount * height + (rowCount - 1) * spacing

            if totalHeight <= size.height {
                let currentLayout = (rowCount: Int(rowCount), columnCount: columnCount, cardSize: CGSize(width: width, height: height))
                if isLayoutBetter(currentLayout, than: bestLayout) {
                    bestLayout = currentLayout
                }
            }
        }
            return floor(bestLayout.cardSize.width)
    }

    /// Determines if one layout is better than another based on the area of the cards.
    /// A layout is considered better if it allows for larger card sizes.
    ///
    /// - Parameters:
    ///   - layout1: The first layout to compare.
    ///   - layout2: The second layout to compare.
    /// - Returns: `true` if the first layout is better than the second; otherwise, `false`.
    func isLayoutBetter(
        _ layout1: (rowCount: Int, columnCount: Int, cardSize: CGSize),
        than layout2: (rowCount: Int, columnCount: Int, cardSize: CGSize)
    ) -> Bool {
        let area1 = layout1.cardSize.width * layout1.cardSize.height
        let area2 = layout2.cardSize.width * layout2.cardSize.height

        return area1 > area2
    }
}
