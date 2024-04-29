//
//  StarRating.swift
//  FryftEats
//
//  Created by Victor Hoang on 4/29/24.
//

import Foundation
import SwiftUI

struct StarRating: View {
    var rating: Double
    private let fullStar = "star.fill"
    private let halfStar = "star.leadinghalf.fill"
    private let emptyStar = "star"
    
    var body: some View {
        HStack(spacing: 1) {
            ForEach(0..<5, id: \.self) { index in
                Image(systemName: self.symbol(for: index + 1))
                    .foregroundColor(.yellow)
                    .font(.system(size: 12))
            }
        }
    }
    
    private func symbol(for position: Int) -> String {
        if Double(position) <= rating {
            return fullStar
        } else if Double(position) - 0.5 <= rating {
            return halfStar
        } else {
            return emptyStar
        }
    }
}
