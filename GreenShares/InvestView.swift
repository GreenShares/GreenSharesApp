//
//  InvestView.swift
//  GreenShares
//
//  Created by Mark Le on 2/18/25.
//

import SwiftUI

struct InvestView: View {
    var body: some View {
        NavigationView  {
            VStack {
                List {
                    Label("Direct Air Capture", systemImage: "wind")
                    Label("Renewable Energy", systemImage: "leaf")
                    Label("Carbon Sequestration", systemImage: "building")
                    Label("Amazon Rainforest", systemImage: "tree")
                }
          
            }
            .navigationTitle(Text("Impact Projects"))
        }
    }
}


#Preview {
    InvestView()
}
