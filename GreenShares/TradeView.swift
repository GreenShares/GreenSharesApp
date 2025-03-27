//
//  TradeView.swift
//  GreenShares
//
//  Created by Mark Le on 2/18/25.
//

import SwiftUI
import Charts

struct TradeView: View {
    let stockData: [(String, Double)] = [
        ("Feb 1", 10.0),
        ("Feb 5", 50.5),
        ("Feb 10", 30.0),
        ("Feb 15", 70.8),
        ("Feb 20", 60.3),
        ("Feb 25", 104.5)
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Current Price: $104.5")
                    .font(.headline)
                    .padding()
                Chart {
                    ForEach(stockData, id: \.0) { item in
                        LineMark(
                            x: .value("Date", item.0),
                            y: .value("Price", item.1)
                        )
                    }
                }
                .frame(height: 200)
                .padding()
                HStack {
                    Button("Buy Shares") {
                        // Buy action
                    }
                    .buttonStyle(.bordered)
                    .foregroundStyle(.green)
                    Button("Sell Shares") {
                        // Sell action
                    }
                    .buttonStyle(.bordered)
                    .foregroundColor(.red)
                }
                .padding()
            }
            .navigationTitle("Carbon Market")
        }
    }
}

#Preview {
    TradeView()
}
