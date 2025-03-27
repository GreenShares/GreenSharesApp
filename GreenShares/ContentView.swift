//
//  ContentView.swift
//  GreenShares
//
//  Created by Mark Le on 2/11/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var isLoggedIn = false

    var body: some View {
        if isLoggedIn {
            TabView {
                TrackView()
                    .tabItem {
                        Image(systemName: "chart.pie.fill")
                        Text("Track")
                    }
                InvestView()
                    .tabItem {
                        Image(systemName: "leaf.arrow.circlepath")
                        Text("Invest")
                    }
                TradeView()
                    .tabItem {
                        Image(systemName: "chart.line.uptrend.xyaxis")
                        Text("Trade")
                    }
                RewardView()
                    .tabItem {
                        Image(systemName: "star.fill")
                        Text("Reward")
                    }
            }
        } else {
            LoginView(isLoggedIn: $isLoggedIn)
        }
    }
}

#Preview {
    ContentView()
}
