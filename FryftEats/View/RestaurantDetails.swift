//
//  RestaurantDetails.swift
//  FryftEats
//
//  Created by Victor Hoang on 4/29/24.
//

import Foundation
import SwiftUI

struct RestaurantDetails: View {
    @ObservedObject var viewModel: RestaurantDetailsViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text(viewModel.restaurant.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                if let imageUrl = viewModel.restaurant.imageUrl, let url = URL(string: imageUrl) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(height: 300)
                    .cornerRadius(12)
                }
                
                Text(viewModel.restaurant.address)
                    .font(.headline)
                
                if let phoneNumber = viewModel.restaurant.phoneNumber {
                    Text("Phone: \(phoneNumber)")
                        .font(.subheadline)
                }
                
                if let price = viewModel.restaurant.price {
                    Text("Price: \(price)")
                        .font(.subheadline)
                }
                
                if let rating = viewModel.restaurant.rating {
                    Text("Rating: \(rating) / 5")
                        .font(.subheadline)
                }
                
                if let url = viewModel.restaurant.url {
                    Link("More Info", destination: URL(string: url)!)
                }
            }
            .padding()
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
