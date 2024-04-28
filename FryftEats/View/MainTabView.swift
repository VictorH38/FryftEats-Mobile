//
//  MainTabView.swift
//  FryftEats
//
//  Created by Victor Hoang on 4/28/24.
//

import Foundation
import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            Search()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
            
            Favorites()
                .tabItem {
                    Label("Favorites", systemImage: "star.fill")
                }
            
            Profile()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
        }
    }
}

#Preview {
    MainTabView()
}
