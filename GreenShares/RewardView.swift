//
//  RewardView.swift
//  GreenShares
//
//  Created by Mark Le on 2/18/25.
//

import SwiftUI

struct RewardItem: View {
    let name: String
    let icon: String
    
    var body: some View {
        VStack {
            Image(systemName: icon)
                .font(.largeTitle)
            Text(name)
                .font(.caption)
        }
        .frame(width: 100, height: 100)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
    }
}

struct RewardView: View {
    var body: some View {
        
        NavigationView {
            VStack {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
                        RewardItem(name: "Business Perks", icon: "airplane")
                        RewardItem(name: "Dining", icon: "fork.knife")
                        RewardItem(name: "Tech Discounts", icon: "ipad")
                        RewardItem(name: "Entertainment", icon: "star.fill")
                    }
                }
                .padding()
            }
            .navigationTitle("GreenShares Rewards")
        }
    }
}

#Preview {
    RewardView()
}
