import SwiftUI

struct BuyView: View {
    @EnvironmentObject private var portfolio: UserPortfolio
    @State private var selectedProject: CarbonProject?
    @State private var purchaseAmount: Double = 1.0
    @State private var showPurchaseConfirmation = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 25) {
                    // Available balance
                    HStack {
                        Text("Available Balance")
                            .font(.headline)
                        Spacer()
                        Text("$\(portfolio.cash, specifier: "%.2f")")
                            .font(.headline)
                            .foregroundColor(.green)
                    }
                    .padding(.horizontal)
                    
                    // Project cards
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Available Projects")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        ForEach(portfolio.availableProjects) { project in
                            ProjectCard(project: project, isSelected: selectedProject?.id == project.id) {
                                selectedProject = project
                            }
                        }
                    }
                    
                    // Purchase section (visible when project is selected)
                    if let project = selectedProject {
                        VStack(spacing: 20) {
                            Divider()
                                .padding(.vertical, 5)
                            
                            Text("Purchase Carbon Offset")
                                .font(.headline)
                            
                            // Amount slider
                            VStack(spacing: 10) {
                                HStack {
                                    Text("Amount")
                                    Spacer()
                                    Text("\(purchaseAmount, specifier: "%.2f") tons")
                                        .fontWeight(.bold)
                                }
                                
                                Slider(value: $purchaseAmount, in: 0.1...10.0, step: 0.1)
                                    .accentColor(.green)
                                
                                HStack {
                                    Text("0.1 t")
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                    Spacer()
                                    Text("10 t")
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                }
                            }
                            
                            // Cost calculation
                            VStack(spacing: 15) {
                                HStack {
                                    Text("Unit Price")
                                    Spacer()
                                    Text("$\(project.pricePerTon, specifier: "%.2f") / ton")
                                }
                                
                                HStack {
                                    Text("Total Cost")
                                        .fontWeight(.semibold)
                                    Spacer()
                                    Text("$\(project.pricePerTon * purchaseAmount, specifier: "%.2f")")
                                        .fontWeight(.bold)
                                }
                            }
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(12)
                            
                            // Purchase button
                            Button {
                                confirmPurchase(project: project)
                            } label: {
                                Text("Purchase Offset")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(project.pricePerTon * purchaseAmount <= portfolio.cash ? Color.green : Color.gray)
                                    )
                            }
                            .disabled(project.pricePerTon * purchaseAmount > portfolio.cash)
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(16)
                        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Buy Carbon Offsets")
            .toast(isShowing: $showPurchaseConfirmation, text: "Purchased \(purchaseAmount) tons of carbon offset!")
        }
    }
    
    private func confirmPurchase(project: CarbonProject) {
        if portfolio.buyCredits(from: project, tons: purchaseAmount) {
            showPurchaseConfirmation = true
            
            // Hide toast after 2 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                showPurchaseConfirmation = false
                purchaseAmount = 1.0
            }
        }
    }
}

struct ProjectCard: View {
    let project: CarbonProject
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 15) {
                // Project image
                Image(project.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .cornerRadius(10)
                
                // Project details
                VStack(alignment: .leading, spacing: 3) {
                    Text(project.name)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .lineLimit(2)
                    
                    Text(project.type.rawValue)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    HStack {
                        Image(systemName: "mappin.circle.fill")
                            .foregroundColor(.red.opacity(0.8))
                            .imageScale(.small)
                        Text(project.location)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Text("$\(project.pricePerTon, specifier: "%.2f") / ton")
                        .font(.callout)
                        .fontWeight(.medium)
                        .foregroundColor(.green)
                }
                
                Spacer()
                
                // Selection indicator
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.title2)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.green.opacity(0.1) : Color(.secondarySystemBackground))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? Color.green : Color.clear, lineWidth: 2)
                    )
            )
            .padding(.horizontal)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// Toast notification view
extension View {
    func toast(isShowing: Binding<Bool>, text: String) -> some View {
        ZStack {
            self
            
            if isShowing.wrappedValue {
                VStack {
                    Spacer()
                    
                    HStack(spacing: 10) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        
                        Text(text)
                            .font(.subheadline)
                            .foregroundColor(.white)
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal, 16)
                    .background(
                        Capsule()
                            .fill(Color.black.opacity(0.8))
                    )
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .padding(.bottom, 90)
                }
                .animation(.easeInOut, value: isShowing.wrappedValue)
                .zIndex(1)
            }
        }
    }
}

#Preview {
    BuyView()
        .environmentObject(UserPortfolio())
}
