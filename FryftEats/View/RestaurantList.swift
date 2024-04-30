//
//  RestaurantList.swift
//  FryftEats
//
//  Created by Victor Hoang on 4/29/24.
//

import Foundation
import SwiftUI

struct RestaurantList: View {
    @ObservedObject var viewModel: RestaurantListViewModel

    var body: some View {
        ScrollView {
            VStack {
                ForEach(viewModel.restaurants, id: \.id) { restaurant in
                    NavigationLink(destination: RestaurantDetails(viewModel: RestaurantDetailsViewModel(restaurant: restaurant))) {
                        RestaurantCard(viewModel: RestaurantViewModel(restaurant: restaurant, isFavoritesList: viewModel.isFavoritesList, listViewModel: viewModel))
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .padding([.horizontal])
        .background(Color(hex: "#990000"))
    }
}

#Preview {
    RestaurantList(viewModel: RestaurantListViewModel(restaurants: Restaurant.sampleRestaurants, isFavoritesList: false))
}
