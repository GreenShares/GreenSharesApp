//
//  TrackView.swift
//  GreenShares
//
//  Created by Mark Le on 2/18/25.
//

import SwiftUI
import Charts

struct TrackView: View {
    let data: [(String, Double)] = [
        ("Miles", 31.4),
        ("Water", 24.3),
        ("Electricity", 20.0),
        ("Gas", 10.0),
        ("Other", 14.3)
    ]
    
    @State private var showingSheet = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    GroupBox(label: Text("Set Your Goal")) {
                        TextField("Enter year to go net-zero", text: .constant(""))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }

                    GroupBox(label: Text("Historical Tracking")) {
                        Chart {
                            ForEach(data, id: \.0) { item in
                                SectorMark(angle: .value("Percentage", item.1))
                                    .foregroundStyle(by: .value("Category", item.0))
                            }
                        }
                        .frame(height: 200)
                        Text("Estimated CO₂ Emissions: X tons/year")
                    }
                }
                .padding()
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: { showingSheet.toggle() }) {
                            Image(systemName: "plus")
                        }
                    }
                }
            }
            .sheet(isPresented: $showingSheet) {
                NavigationView {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            GroupBox(label: Text("Identity Verification")) {
                                Text("Upload ID or connect to financial provider.")
                                Button("Verify Identity") {}
                            }
                            // Carbon Footprint Input
                            GroupBox(label: Text("Carbon Footprint Input")) {
                                Text("Take a quiz or upload your utility bill.")
                                Button("Start Quiz") {}
                                Button("Upload Utility Bill") {}
                            }
                            // Manual Input
                            GroupBox(label: Text("Manual Input")) {
                                TextField("Miles driven", text: .constant(""))
                                TextField("Utility kWh", text: .constant(""))
                                TextField("Flights taken", text: .constant(""))
                            }
                            // API Integrations
                            GroupBox(label: Text("API Integrations")) {
                                Button("Connect Utility Account") {}
                                Button("Connect Tesla Account") {}
                                Button("Connect Bank") {}
                            }
                        }
                        .padding()
                    }
                    .navigationTitle("Add Carbon Data")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Cancel") {
                                showingSheet.toggle()
                            }
                        }
                    }
                }
            }
            .navigationTitle("Carbon Tracker")
        }
    }
}

#Preview {
    TrackView()
}
