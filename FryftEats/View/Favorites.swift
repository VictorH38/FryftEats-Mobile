//
//  Favorites.swift
//  FryftEats
//
//  Created by Victor Hoang on 4/28/24.
//

import Foundation
import SwiftUI

struct Favorites: View {
    @ObservedObject var viewModel = FavoritesViewModel()

    var body: some View {
        VStack {
            if SessionManager.shared.isLoggedIn {
                if let user = SessionManager.shared.user {
                    Text("Hi, \(user.firstName)")
                        .padding([.top])
                        .font(.largeTitle)
                        .foregroundColor(.white)
                    if viewModel.restaurants.isEmpty {
                        Text("You have no favorite restaurants")
                            .padding([.horizontal])
                            .font(.title2)
                            .foregroundColor(.white)
                    } else {
                        Text("Here are your favorite restaurants")
                            .padding([.horizontal])
                            .font(.title2)
                            .foregroundColor(.white)
                        
                        RestaurantList(viewModel: RestaurantListViewModel(restaurants: viewModel.restaurants, isFavoritesList: true))
                    }
                }
            } else {
                Text("Login or Sign Up to add restaurants to your favorites list")
                    .padding()
                    .font(.largeTitle)
                    .foregroundColor(.white)
            }
            
            Spacer()
        }
        .onAppear {
            viewModel.fetchFavorites()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(hex: "#990000"))
    }
}

#Preview {
    Favorites(viewModel: FavoritesViewModel())
}
