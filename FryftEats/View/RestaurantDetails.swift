//
//  RestaurantDetails.swift
//  FryftEats
//
//  Created by Victor Hoang on 4/29/24.
//

import Foundation
import SwiftUI
import CoreLocation

struct RestaurantDetails: View {
    @ObservedObject var viewModel: RestaurantDetailsViewModel
    @ObservedObject var sessionManager = SessionManager.shared
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text(viewModel.restaurant.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                if let imageUrl = viewModel.restaurant.imageUrl, let url = URL(string: imageUrl) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(maxWidth: .infinity, maxHeight: 300)
                    .clipped()
                    .cornerRadius(12)
                } else {
                    Image("no-image")
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity, minHeight: 100, maxHeight: 300)
                        .clipped()
                        .cornerRadius(8)
                }
                
                Text(viewModel.restaurant.address)
                    .font(.subheadline)
                    .foregroundColor(.white)
                
                if let phoneNumber = viewModel.restaurant.phoneNumber {
                    Text("Phone: \(phoneNumber)")
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
                
                if let price = viewModel.restaurant.price {
                    Text("Price: \(price)")
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
                
                if let rating = viewModel.restaurant.rating {
                    StarRating(rating: rating)
                }
                
                if let url = viewModel.restaurant.url {
                    Link("More Info", destination: URL(string: url)!)
                        .font(.subheadline)
                }
                
                if let restaurantLat = viewModel.restaurant.latitude,
                   let restaurantLong = viewModel.restaurant.longitude,
                   let userLocation = sessionManager.currentLocation {
                    LyftRideButton(
                        pickup: CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude),
                        destination: CLLocationCoordinate2D(latitude: restaurantLat, longitude: restaurantLong)
                    )
                    .frame(width: 300, height: 50)
                    .cornerRadius(10)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal)
                    .background(Color(hex: "#990000"))
                    .padding(.top, 10)
                }
            }
        }
        .padding()
        .background(Color(hex: "#990000"))
    }
}

#Preview {
    RestaurantDetails(viewModel: RestaurantDetailsViewModel(
        restaurant: Restaurant.sampleRestaurants[0]
    ))
}
