//
//  ShareButton.swift
//  FryftEats
//
//  Created by Victor Hoang on 4/30/24.
//

import Foundation
import SwiftUI

struct ShareButton: View {
    var restaurant: Restaurant
    
    var body: some View {
        Button(action: shareRestaurant) {
            Image(systemName: "square.and.arrow.up")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 24, height: 24)
                .padding()
        }
        .background(Color.white)
        .foregroundColor(.blue)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
    func shareRestaurant() {
        guard let url = URL(string: restaurant.url ?? "") else { return }
        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        
        let keyWindow = UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
        
        keyWindow?.rootViewController?.present(activityVC, animated: true, completion: nil)
    }
}
