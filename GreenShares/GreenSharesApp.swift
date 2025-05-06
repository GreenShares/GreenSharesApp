//
//  GreenSharesApp.swift
//  GreenShares
//
//  Created by Mark Le on 2/11/25.
//

import SwiftUI
import SwiftData

@main
struct GreenSharesApp: App {
    @StateObject private var portfolio = UserPortfolio()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(portfolio)
        }
    }
}
