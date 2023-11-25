//
//  AspectVGrid.swift
//  SET!
//
//  Created by Péter Sanyó on 22.11.23.
//

import SwiftUI

struct AspectVGrid<Item: Identifiable, ItemView: View>: View {
    var items: [Item]
    var aspectRatio: CGFloat = 1
    var content: (Item) -> ItemView
    
    init(_ items: [Item], aspectRatio: CGFloat, @ViewBuilder content: @escaping (Item) -> ItemView) {
        self.items = items
        self.aspectRatio = aspectRatio
        self.content = content
    }
    
    var body: some View {
        GeometryReader { geometry in
            let gridItemSize = gridItemWidthThatFits(
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
            
    func gridItemWidthThatFits(
        count: Int,
        size: CGSize,
        atAspectRatio aspectRatio: CGFloat
    ) -> CGFloat {
        let minColumnCount: CGFloat = 5 // Minimum number of columns
        let maxRowCount: CGFloat = 8 // Maximum number of rows
        let columnCount: CGFloat = minColumnCount // Start with the minimum number of columns

        // Iterate to find the best fit
        for currentColumnCount in stride(from: minColumnCount, through: CGFloat(count), by: 1) {
            let width = size.width / currentColumnCount
            let height = width / aspectRatio
            let rowCount = (CGFloat(count) / currentColumnCount).rounded(.up)

            // Check if the number of rows exceeds the maximum allowed
            if rowCount <= maxRowCount {
                // If it fits within the height, return this width
                if rowCount * height <= size.height {
                    return floor(width)
                }
            }
        }

        // If no fitting configuration is found, return the best guess
        return floor(size.width / columnCount)
    }

}
