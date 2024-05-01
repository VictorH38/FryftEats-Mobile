//
//  Search.swift
//  FryftEats
//
//  Created by Victor Hoang on 4/28/24.
//

import Foundation
import SwiftUI

struct SearchView: View {
    @StateObject var viewModel = SearchViewModel()
    @State private var searchTerm = ""
    @State private var selectedPrice = "All Prices"
    @State private var selectedSortBy = "Best Match"

    var priceOptions = ["All Prices", "$", "$$", "$$$", "$$$$"]
    var sortByOptions = ["Best Match", "Rating", "Review Count", "Distance"]

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                HStack {
                    TextField("Search Restaurants", text: $searchTerm)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button(action: {
                        viewModel.searchRestaurants(term: searchTerm, price: selectedPrice, sortBy: selectedSortBy)
                    }) {
                        Text("Search")
                    }
                    .padding(.vertical, 7)
                    .padding(.horizontal)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(5)
                }
                .padding(.top)
                .padding(.horizontal)
                
                HStack {
                    Picker("Price", selection: $selectedPrice) {
                        ForEach(priceOptions, id: \.self) {
                            Text($0).foregroundColor(.white)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .background(Color.white)
                    .cornerRadius(5)
                    
                    Picker("Sort By", selection: $selectedSortBy) {
                        ForEach(sortByOptions, id: \.self) {
                            Text($0).foregroundColor(.white)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .background(Color.white)
                    .cornerRadius(5)
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 0)
                
                if viewModel.hasSearched{
                    if viewModel.restaurants.isEmpty && searchTerm != "" {
                        Text("No results for \"\(searchTerm)\"")
                            .font(.title3)
                            .foregroundColor(.white)
                            .padding([.top, .leading, .trailing])
                    } else {
                        Text("Search results for \"\(searchTerm)\"")
                            .font(.title3)
                            .foregroundColor(.white)
                            .padding([.top, .leading, .trailing])
                    }
                }
                
                RestaurantList(viewModel: RestaurantListViewModel(restaurants: viewModel.restaurants, isFavoritesList: false))
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(hex: "#990000"))
            .onAppear {
                viewModel.refreshSearchResults(term: searchTerm, price: selectedPrice, sortBy: selectedSortBy)
            }
        }
    }
}

#Preview {
    SearchView()
}
