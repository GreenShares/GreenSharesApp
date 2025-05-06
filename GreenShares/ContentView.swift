//
//  ContentView.swift
//  GreenShares
//
//  Created by Mark Le on 2/11/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State var isLoggedIn = false
    @State private var selectedTab = 0

    var body: some View {
        if isLoggedIn {
            TabView(selection: $selectedTab) {
                DashboardView()
                    .tabItem {
                        Label("Dashboard", systemImage: "chart.pie.fill")
                    }
                    .tag(0)
                
                BuyView()
                    .tabItem {
                        Label("Buy", systemImage: "cart.fill")
                    }
                    .tag(1)
                
                SellView()
                    .tabItem {
                        Label("Sell", systemImage: "dollarsign.circle.fill")
                    }
                    .tag(2)
                
//                RetireView()
//                    .tabItem {
//                        Label("Retire", systemImage: "leaf.fill")
//                    }
//                    .tag(3)
                
                RewardView()
                    .tabItem {
                        Label("Rewards", systemImage: "star.fill")
                    }
                    .tag(4)
            }
            .accentColor(.green)
            .toolbar(.visible, for: .tabBar)
            .toolbarBackground(Color(UIColor.systemBackground), for: .tabBar)
        } else {
            SplashView(isLoggedIn: $isLoggedIn)
        }
    }
}

#Preview {
    ContentView()
}
