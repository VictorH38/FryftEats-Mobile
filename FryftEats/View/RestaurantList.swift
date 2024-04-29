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
        List(viewModel.restaurants, id: \.id) { restaurant in
            RestaurantCard(viewModel: RestaurantViewModel(restaurant: restaurant, isFavoritesList: viewModel.isFavoritesList))
                .listRowInsets(EdgeInsets())
        }
        .onAppear {
            viewModel.loadRestaurants()
        }
    }
}

#Preview {
    RestaurantList(viewModel: RestaurantListViewModel(restaurants: Restaurant.sampleRestaurants, isFavoritesList: false, isSearchList: true))
}
