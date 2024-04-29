//
//  MainTabView.swift
//  FryftEats
//
//  Created by Victor Hoang on 4/28/24.
//

import Foundation
import SwiftUI

struct MainTabView: View {
    init() {
        configureTabBarAppearance()
    }
    
    var body: some View {
        TabView {
            Search()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
            
            Favorites()
                .tabItem {
                    Label("Favorites", systemImage: "heart.fill")
                }
            
            Profile()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
        }
    }
    
    func configureTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = UIColor.black
        
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor.white
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor.goldColor
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.goldColor]
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

#Preview {
    MainTabView()
}
