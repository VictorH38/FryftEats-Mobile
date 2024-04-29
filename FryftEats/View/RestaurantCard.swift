//
//  RestaurantCard.swift
//  FryftEats
//
//  Created by Victor Hoang on 4/29/24.
//

import Foundation
import SwiftUI

struct RestaurantCard: View {
    @ObservedObject var viewModel: RestaurantViewModel

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(viewModel.restaurant.name)
                    .font(.headline)
                    .padding([.top, .leading])

                Spacer()

                Button(action: {
                    viewModel.toggleFavorite()
                }) {
                    Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                        .imageScale(.large)
                        .font(.system(size: 20))
                        .foregroundColor(viewModel.isFavorite ? .red : .gray)
                }
                .padding([.top, .trailing])
            }

            HStack(spacing: 16) {
                if let imageUrl = viewModel.restaurant.imageUrl, let url = URL(string: imageUrl) {
                    AsyncImage(url: url) { image in
                        image.resizable()
                    } placeholder: {
                        Color.gray
                    }
                    .frame(width: 100, height: 100)
                    .cornerRadius(8)
                } else {
                    Image("no-image")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .cornerRadius(8)
                }

                VStack(alignment: .leading, spacing: 5) {
                    Text(viewModel.firstPartOfAddress(viewModel.restaurant.address))
                        .font(.subheadline)
                    if let phone = viewModel.restaurant.phoneNumber {
                        Text(phone)
                            .font(.subheadline)
                    }
                    if let rating = viewModel.restaurant.rating {
                        StarRating(rating: rating)
                    }

                    if viewModel.isFavoritesList {
                        Text("Added \(viewModel.timeAgo(from: Date()))")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.trailing)
            }
            .padding([.bottom, .leading, .trailing])
        }
        .background(Color(.white))
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

#Preview {
    RestaurantCard(viewModel: RestaurantViewModel(
        restaurant: Restaurant(
            id: 1,
            name: "Example Restaurant",
            address: "123 Main St",
            phoneNumber: "123-456-7890",
            rating: 4.5,
            imageUrl: "https://example.com/image.jpg"
        ),
        isFavoritesList: true
    ))
}