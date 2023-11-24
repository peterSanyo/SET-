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
                ForEach(items) { item in
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
        let maxColumnCount: CGFloat = 6 // Maximum number of columns
        var columnCount: CGFloat = 1
        repeat {
            let width = size.width / columnCount
            let height = width / aspectRatio
                
            let rowCount = (CGFloat(count) / columnCount).rounded(.up)
            if rowCount * height <= size.height || columnCount == maxColumnCount {
                return floor(size.width / columnCount)
            }
            columnCount += 1
        } while columnCount <= maxColumnCount
        return floor(size.width / maxColumnCount)
    }
}
