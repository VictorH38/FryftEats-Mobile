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
    @ObservedObject var sessionManager = SessionManager.shared

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(viewModel.restaurant.name)
                    .font(.headline)
                    .padding([.top, .leading])

                Spacer()
                
                if sessionManager.isLoggedIn {
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
            }

            HStack(spacing: 16) {
                if let imageUrl = viewModel.restaurant.imageUrl, let url = URL(string: imageUrl) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Color.gray
                    }
                    .frame(width: 100, height: 100)
                    .clipped()
                    .cornerRadius(8)
                } else {
                    Image("no-image")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .clipped()
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
        restaurant: Restaurant.sampleRestaurants[0],
        isFavoritesList: true,
        listViewModel: nil
    ))
}
