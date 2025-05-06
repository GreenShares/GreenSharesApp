import SwiftUI

struct DashboardView: View {
    @StateObject private var portfolio = UserPortfolio()
    @State private var selectedTab = 0
    @State private var showImpactDetail = false
    @State private var selectedImpactEvent: ImpactEvent?
    @State private var showSettings = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Portfolio summary section
                    VStack(spacing: 25) {
                        // Balance and carbon offset
                        HStack(spacing: 20) {
                            // Cash balance
                            VStack(alignment: .leading) {
                                Text("Cash Balance")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Text("$\(portfolio.cash, specifier: "%.2f")")
                                    .font(.title)
                                    .fontWeight(.bold)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(12)
                            
                            // Carbon offset
                            VStack(alignment: .leading) {
                                Text("Carbon Offset")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Text("\(portfolio.totalCarbonOffset, specifier: "%.2f") t")
                                    .font(.title)
                                    .fontWeight(.bold)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(12)
                        }
                        
                        // Line chart (GIF placeholder)
                        ZStack {
                            Image("chart-placeholder")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 150)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                )
                            
                            // Fallback if no chart image exists
                            Text("Carbon Offset Growth")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        
                        // Action buttons
                        HStack(spacing: 15) {
                            ActionButton(title: "Buy", icon: "cart", color: .green) {
                                selectedTab = 1
                            }
                            
                            ActionButton(title: "Sell", icon: "dollarsign.circle", color: .blue) {
                                selectedTab = 2
                            }
                            
                            ActionButton(title: "Retire", icon: "leaf", color: .orange) {
                                selectedTab = 3
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                    
                    // Rewards chip
                    HStack(spacing: 15) {
                        // Badge
                        ZStack {
                            Circle()
                                .fill(Color.green.opacity(0.2))
                                .frame(width: 50, height: 50)
                            
                            Image(systemName: "leaf.fill")
                                .foregroundColor(.green)
                                .font(.system(size: 24))
                        }
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Seedling · 5% Grocery")
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            Text("Keep offsetting to unlock more rewards!")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    .onTapGesture {
                        selectedTab = 4
                    }
                    
                    // Impact Feed section
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Impact Feed")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        ForEach(portfolio.impactFeed) { event in
                            Button {
                                selectedImpactEvent = event
                                showImpactDetail = true
                            } label: {
                                HStack(spacing: 15) {
                                    Image(systemName: "building.2.fill")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                        .foregroundColor(.blue)
                                        .padding(10)
                                        .background(Circle().fill(Color.blue.opacity(0.1)))
                                    
                                    VStack(alignment: .leading, spacing: 3) {
                                        Text("🚀 \(event.companyName) just retired \(Int(event.amount)) t")
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                        
                                        Text("Tap to view impact")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.secondary)
                                        .font(.caption)
                                }
                                .padding()
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(12)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationTitle("Dashboard")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        showSettings = true
                    }) {
                        Image(systemName: "gearshape")
                    }
                }
            }
            .sheet(isPresented: $showImpactDetail) {
                if let event = selectedImpactEvent {
                    CorporateImpactView(event: event)
                }
            }
            .sheet(isPresented: $showSettings) {
                SettingsView()
            }
            .onChange(of: selectedTab) {
                // This would normally be handled by TabView's selection binding
                // But we're simulating navigation for the demo
            }
        }
        .environmentObject(portfolio)
    }
}

struct ActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                Text(title)
                    .font(.footnote)
                    .fontWeight(.medium)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .background(color.opacity(0.15))
            .foregroundColor(color)
            .cornerRadius(10)
        }
    }
}

struct CorporateImpactView: View {
    let event: ImpactEvent
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 25) {
                // Banner with company logo
                ZStack {
                    Rectangle()
                        .fill(Color.blue.gradient)
                        .frame(height: 180)
                    
                    VStack {
                        Image(systemName: "building.2.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.white)
                        
                        Text(event.companyName)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                }
                
                VStack(spacing: 20) {
                    // Impact metrics
                    HStack(spacing: 25) {
                        VStack {
                            Text("\(Int(event.amount))")
                                .font(.title)
                                .fontWeight(.bold)
                            Text("tons retired")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Rectangle()
                            .frame(width: 1, height: 50)
                            .foregroundColor(.gray.opacity(0.3))
                        
                        VStack {
                            Text("\(event.carsEquivalent)")
                                .font(.title)
                                .fontWeight(.bold)
                            Text("cars off road/yr")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.top)
                    
                    // Impact description
                    Text("This reduction is equivalent to taking \(event.carsEquivalent) cars off the road for an entire year.")
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    // Learn more button
                    Link(destination: URL(string: "https://example.com/\(event.companyName.lowercased())/impact")!) {
                        Text("Learn More")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    
                    // Share on X button
                    Button {
                        let shareText = "Amazing! \(event.companyName) just retired \(Int(event.amount)) tons of carbon - equivalent to \(event.carsEquivalent) cars off the road for a year! #ClimateAction"
                        let url = URL(string: "https://example.com/share")!
                        
                        let activityVC = UIActivityViewController(
                            activityItems: [shareText, url],
                            applicationActivities: nil
                        )
                        
                        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                           let rootVC = windowScene.windows.first?.rootViewController {
                            rootVC.present(activityVC, animated: true)
                        }
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: "square.and.arrow.up")
                            Text("Share Impact")
                        }
                        .font(.headline)
                        .foregroundColor(.blue)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
            }
            .navigationTitle("Corporate Impact")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
        }
    }
}

struct SettingsView: View {
    @State private var darkModeEnabled = false
    @State private var notificationsEnabled = true
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("PREFERENCES")) {
                    Toggle(isOn: $darkModeEnabled) {
                        Label("Dark Mode", systemImage: "moon.fill")
                    }
                    
                    Toggle(isOn: $notificationsEnabled) {
                        Label("Notifications", systemImage: "bell.fill")
                    }
                    
                    HStack {
                        Label("Link Bank", systemImage: "building.columns.fill")
                        Spacer()
                        Text("Coming Soon")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .opacity(0.5)
                }
                
                Section(header: Text("ACCOUNT")) {
                    Button(action: {}) {
                        Label("Privacy Settings", systemImage: "lock.fill")
                    }
                    
                    Button(action: {}) {
                        Label("Help & Support", systemImage: "questionmark.circle.fill")
                    }
                    
                    Button(action: {}) {
                        Label("About", systemImage: "info.circle.fill")
                    }
                }
                
                Section {
                    Button(action: {}) {
                        Text("Sign Out")
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    DashboardView()
}