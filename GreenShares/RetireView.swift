import SwiftUI

struct RetireView: View {
    @EnvironmentObject private var portfolio: UserPortfolio
    @State private var retireAmount: Double = 0.1
    @State private var showRetireConfirmation = false
    @State private var showCertificate = false
    @State private var showConfetti = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 25) {
                    // Retire intro
                    VStack(spacing: 12) {
                        Text("Retire Carbon Credits")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("Permanently remove carbon credits from circulation to offset your footprint and make a real climate impact.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                    }
                    .padding(.top)
                    
                    // Available credits
                    HStack {
                        Text("Available Credits")
                            .font(.headline)
                        Spacer()
                        Text("\(portfolio.totalCarbonOffset, specifier: "%.2f") tons")
                            .font(.headline)
                            .foregroundColor(.green)
                    }
                    .padding(.horizontal)
                    
                    // Retirement card
                    VStack(spacing: 25) {
                        // Icon
                        ZStack {
                            Circle()
                                .fill(Color.orange.opacity(0.2))
                                .frame(width: 80, height: 80)
                            
                            Image(systemName: "leaf.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.orange)
                        }
                        
                        // Amount picker
                        VStack(spacing: 15) {
                            Text("Retirement Amount")
                                .font(.headline)
                            
                            // Amount stepper
                            HStack {
                                Button {
                                    if retireAmount > 0.1 {
                                        retireAmount -= 0.1
                                    }
                                } label: {
                                    Image(systemName: "minus.circle.fill")
                                        .font(.system(size: 30))
                                        .foregroundColor(.gray)
                                }
                                
                                Text("\(retireAmount, specifier: "%.1f")")
                                    .font(.system(size: 40, weight: .bold))
                                    .frame(width: 100)
                                
                                Button {
                                    if retireAmount < portfolio.totalCarbonOffset {
                                        retireAmount += 0.1
                                    }
                                } label: {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.system(size: 30))
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding(.vertical, 10)
                            
                            Text("tons of CO₂")
                                .font(.headline)
                                .foregroundColor(.secondary)
                        }
                        
                        // Impact calculation
                        VStack(spacing: 10) {
                            Text("Your Impact")
                                .font(.headline)
                            
                            Text("This retirement is equivalent to taking \(Int(retireAmount * 0.21)) car(s) off the road for a year.")
                                .font(.subheadline)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)
                        
                        // Retire button
                        Button {
                            confirmRetirement()
                        } label: {
                            Text("Retire Carbon Credits")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(retireAmount <= portfolio.totalCarbonOffset && retireAmount > 0 ? Color.orange : Color.gray)
                                )
                        }
                        .disabled(retireAmount > portfolio.totalCarbonOffset || retireAmount <= 0)
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                    .padding(.horizontal)
                    .overlay(
                        // Confetti overlay
                        ZStack {
                            if showConfetti {
                                LottieView(name: "confetti")
                                    .allowsHitTesting(false)
                            }
                        }
                    )
                }
                .padding(.vertical)
            }
            .navigationTitle("Retire Credits")
            .sheet(isPresented: $showCertificate) {
                CertificateView(amount: retireAmount)
            }
        }
    }
    
    private func confirmRetirement() {
        if portfolio.retireCredits(tons: retireAmount) {
            // Show confetti animation
            withAnimation {
                showConfetti = true
            }
            
            // Hide confetti after 2 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                showConfetti = false
                showCertificate = true
            }
        }
    }
}

// Certificate View
struct CertificateView: View {
    let amount: Double
    @Environment(\.dismiss) private var dismiss
    @State private var showShareSheet = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 25) {
                    // Certificate header
                    VStack {
                        Text("Certificate of Carbon Retirement")
                            .font(.title)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                        
                        Text("This certifies that")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .padding(.top, 5)
                        
                        Text("John Doe")
                            .font(.title2)
                            .fontWeight(.medium)
                            .padding(.vertical, 2)
                        
                        Text("has retired")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .padding(.top, 5)
                        
                        Text("\(amount, specifier: "%.1f") tons")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                            .padding(.vertical, 5)
                        
                        Text("of verified carbon credits")
                            .font(.body)
                            .foregroundColor(.secondary)
                        
                        Text("on \(formattedDate())")
                            .font(.body)
                            .padding(.top, 5)
                    }
                    .padding(.vertical, 30)
                    .padding(.horizontal)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.green, lineWidth: 3)
                            .padding(.horizontal, 15)
                    )
                    
                    // Certificate details
                    VStack(spacing: 15) {
                        HStack {
                            Image(systemName: "checkmark.seal.fill")
                                .foregroundColor(.green)
                            Text("Verified by GreenShares")
                                .font(.headline)
                        }
                        
                        Text("Certificate ID: \(UUID().uuidString.prefix(8))")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                    
                    // Action buttons
                    HStack(spacing: 15) {
                        // Download PDF button
                        Button {
                            // In a real app, this would generate and download a PDF
                        } label: {
                            HStack {
                                Image(systemName: "doc.fill")
                                Text("Save PDF")
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(12)
                        }
                        
                        // Share button
                        Button {
                            showShareSheet = true
                        } label: {
                            HStack {
                                Image(systemName: "square.and.arrow.up")
                                Text("Share")
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding()
            }
            .navigationTitle("Carbon Retirement")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { dismiss() }) {
                        Text("Done")
                            .fontWeight(.medium)
                    }
                }
            }
            .sheet(isPresented: $showShareSheet) {
                let shareText = "I just retired \(amount) tons of carbon with GreenShares! This is equivalent to taking \(Int(amount * 0.21)) cars off the road for a year. #ClimateAction"
                let image = Image("Trees") // Replace with actual certificate image
                
                ShareSheet(activityItems: [shareText])
            }
        }
    }
    
    private func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: Date())
    }
}

// Lottie View for confetti animation - placeholder for demo
struct LottieView: View {
    let name: String
    
    var body: some View {
        ZStack {
            // In a real app, this would be a Lottie animation
            // For now, we'll use a simple fallback
            Image(systemName: "sparkles")
                .font(.system(size: 40))
                .foregroundColor(.yellow)
                .offset(x: -100, y: -100)
            
            Image(systemName: "star.fill")
                .font(.system(size: 30))
                .foregroundColor(.orange)
                .offset(x: 80, y: -80)
            
            Image(systemName: "sparkles")
                .font(.system(size: 40))
                .foregroundColor(.blue)
                .offset(x: 100, y: 80)
            
            Image(systemName: "star.fill")
                .font(.system(size: 30))
                .foregroundColor(.green)
                .offset(x: -80, y: 100)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// Share sheet using UIActivityViewController
struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: nil
        )
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // Nothing to update
    }
}

#Preview {
    RetireView()
        .environmentObject(UserPortfolio())
}
