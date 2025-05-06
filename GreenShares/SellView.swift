import SwiftUI

struct SellView: View {
    @EnvironmentObject private var portfolio: UserPortfolio
    @State private var selectedHolding: CarbonHolding?
    @State private var sellAmount: Double = 0.0
    @State private var showSellConfirmation = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 25) {
                    // Holdings summary
                    HStack {
                        Text("Your Holdings")
                            .font(.headline)
                        Spacer()
                        Text("\(portfolio.totalCarbonOffset, specifier: "%.2f") tons")
                            .font(.headline)
                            .foregroundColor(.green)
                    }
                    .padding(.horizontal)
                    
                    if portfolio.holdings.isEmpty {
                        VStack(spacing: 20) {
                            Image(systemName: "tray")
                                .font(.system(size: 50))
                                .foregroundColor(.gray.opacity(0.7))
                                .padding()
                            
                            Text("No holdings yet")
                                .font(.title3)
                                .fontWeight(.medium)
                            
                            Text("Go to the Buy tab to purchase carbon offsets")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(40)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(16)
                        .padding(.horizontal)
                    } else {
                        // Holdings table
                        VStack(alignment: .leading, spacing: 15) {
                            ForEach(portfolio.holdings) { holding in
                                HoldingCard(holding: holding, isSelected: selectedHolding?.id == holding.id) {
                                    selectedHolding = holding
                                    sellAmount = min(1.0, holding.tons)
                                }
                            }
                        }
                        
                        // Sell section (visible when holding is selected)
                        if let holding = selectedHolding {
                            VStack(spacing: 20) {
                                Divider()
                                    .padding(.vertical, 5)
                                
                                Text("Sell Carbon Offset")
                                    .font(.headline)
                                
                                // Amount slider
                                VStack(spacing: 10) {
                                    HStack {
                                        Text("Amount")
                                        Spacer()
                                        Text("\(sellAmount, specifier: "%.2f") tons")
                                            .fontWeight(.bold)
                                    }
                                    
                                    Slider(value: $sellAmount, in: 0.01...holding.tons, step: 0.01)
                                        .accentColor(.blue)
                                    
                                    HStack {
                                        Text("0.01 t")
                                            .font(.caption2)
                                            .foregroundColor(.secondary)
                                        Spacer()
                                        Text("\(holding.tons, specifier: "%.2f") t")
                                            .font(.caption2)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                
                                // Sale calculation
                                let salePrice = holding.purchasePrice * 1.05 // 5% markup for demo
                                VStack(spacing: 15) {
                                    HStack {
                                        Text("Unit Price")
                                        Spacer()
                                        Text("$\(salePrice, specifier: "%.2f") / ton")
                                    }
                                    
                                    HStack {
                                        Text("Total Value")
                                            .fontWeight(.semibold)
                                        Spacer()
                                        Text("$\(salePrice * sellAmount, specifier: "%.2f")")
                                            .fontWeight(.bold)
                                    }
                                }
                                .padding()
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(12)
                                
                                // Sell button
                                Button {
                                    confirmSale(holding: holding)
                                } label: {
                                    Text("Sell Offset")
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(Color.blue)
                                        )
                                }
                            }
                            .padding()
                            .background(Color(.systemBackground))
                            .cornerRadius(16)
                            .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Sell Carbon Offsets")
            .toast(isShowing: $showSellConfirmation, text: "Sold \(sellAmount) tons of carbon offset!")
        }
    }
    
    private func confirmSale(holding: CarbonHolding) {
        if portfolio.sellCredits(from: holding, tons: sellAmount) {
            showSellConfirmation = true
            
            // Reset if all of this holding was sold
            if sellAmount >= holding.tons {
                selectedHolding = nil
            }
            
            // Hide toast after 2 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                showSellConfirmation = false
                sellAmount = selectedHolding != nil ? min(1.0, selectedHolding!.tons) : 0.0
            }
        }
    }
}

struct HoldingCard: View {
    let holding: CarbonHolding
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 12) {
                // Project name and date
                HStack {
                    Text(holding.projectName)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.blue)
                            .font(.title3)
                    }
                }
                
                Divider()
                
                // Holdings details
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Tons")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("\(holding.tons, specifier: "%.2f")")
                            .font(.body)
                            .fontWeight(.medium)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Purchase Price")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("$\(holding.purchasePrice, specifier: "%.2f")/t")
                            .font(.body)
                            .fontWeight(.medium)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Total Cost")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("$\(holding.totalCost, specifier: "%.2f")")
                            .font(.body)
                            .fontWeight(.medium)
                    }
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.blue.opacity(0.1) : Color(.secondarySystemBackground))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
                    )
            )
            .padding(.horizontal)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    SellView()
        .environmentObject(UserPortfolio())
}
