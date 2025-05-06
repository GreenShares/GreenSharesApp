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
    @EnvironmentObject private var portfolio: UserPortfolio
    @State private var showShareSheet = false
    
    // Sample coupons for demo
    private let coupons = [
        RewardCoupon(
            title: "5% Off Groceries", 
            description: "Get 5% off at participating stores", 
            discountPercentage: 5, 
            imageName: "Trees", 
            expiryDate: Date().addingTimeInterval(60*60*24*30)
        ),
        RewardCoupon(
            title: "10% Off Sustainable Brands", 
            description: "Shop eco-friendly products at a discount", 
            discountPercentage: 10, 
            imageName: "PlantGrowing", 
            expiryDate: Date().addingTimeInterval(60*60*24*30)
        ),
        RewardCoupon(
            title: "Free EV Charging", 
            description: "One free charging session at partners", 
            discountPercentage: 100, 
            imageName: "MoneyPlant", 
            expiryDate: Date().addingTimeInterval(60*60*24*15)
        )
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 25) {
                    // Current tier info
                    let currentTier = RewardsTier.getCurrentTier(for: portfolio.retiredCredits)
                    let nextTier = RewardsTier.getNextTier(for: currentTier)
                    
                    // Tier badge & tier level
                    VStack(spacing: 20) {
                        ZStack {
                            Circle()
                                .fill(Color.green.opacity(0.1))
                                .frame(width: 120, height: 120)
                            
                            VStack(spacing: 8) {
                                Image(systemName: "leaf.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(.green)
                                
                                Text(currentTier.rawValue)
                                    .font(.title2)
                                    .fontWeight(.semibold)
                            }
                        }
                        
                        // Level & Progress bar
                        if let nextTier = nextTier {
                            VStack(spacing: 8) {
                                // Progress text
                                HStack {
                                    Text("Next Level: \(nextTier.rawValue)")
                                        .font(.headline)
                                    
                                    Spacer()
                                    
                                    Text("\(portfolio.retiredCredits, specifier: "%.1f")/\(nextTier.requiredTons) tons")
                                        .font(.subheadline)
                                }
                                
                                // Progress bar
                                ZStack(alignment: .leading) {
                                    Rectangle()
                                        .fill(Color.gray.opacity(0.2))
                                        .frame(height: 10)
                                        .cornerRadius(5)
                                    
                                    let progress = min(1.0, portfolio.retiredCredits / nextTier.requiredTons)
                                    Rectangle()
                                        .fill(Color.green)
                                        .frame(width: progress * (UIScreen.main.bounds.width - 40), height: 10)
                                        .cornerRadius(5)
                                }
                            }
                        } else {
                            Text("You've reached the highest tier!")
                                .font(.headline)
                                .foregroundColor(.green)
                        }
                        
                        // Current perks
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Your Current Perks")
                                .font(.headline)
                            
                            HStack(spacing: 15) {
                                ZStack {
                                    Circle()
                                        .fill(Color.green.opacity(0.1))
                                        .frame(width: 40, height: 40)
                                    
                                    Image(systemName: "percent")
                                        .foregroundColor(.green)
                                }
                                
                                Text("\(currentTier.discountPercentage)% off select grocery items")
                                    .font(.subheadline)
                                
                                Spacer()
                            }
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(12)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                    .padding(.horizontal)
                    
                    // Coupons carousel
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Your Rewards")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                ForEach(coupons) { coupon in
                                    CouponCard(coupon: coupon)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    // Share button
                    Button {
                        showShareSheet = true
                    } label: {
                        HStack {
                            Image(systemName: "square.and.arrow.up")
                            Text("Share Your Impact")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    
                    // Retired credits info
                    VStack(spacing: 10) {
                        Text("You've retired \(portfolio.retiredCredits, specifier: "%.2f") tons of carbon")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                        
                        Text("Keep retiring to unlock more rewards!")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.bottom)
                }
                .padding(.vertical)
            }
            .navigationTitle("Rewards")
            .sheet(isPresented: $showShareSheet) {
                let shareText = "I've achieved \(RewardsTier.getCurrentTier(for: portfolio.retiredCredits).rawValue) tier on GreenShares by retiring \(portfolio.retiredCredits) tons of carbon! Join me in fighting climate change. #GreenShares #ClimateAction"
                
                ShareSheet(activityItems: [shareText])
            }
        }
    }
}

// Coupon card component
struct CouponCard: View {
    let coupon: RewardCoupon
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Image
            Image(coupon.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 260, height: 120)
                .clipped()
                .cornerRadius(12, corners: [.topLeft, .topRight])
            
            // Discount badge
            HStack {
                Text("\(coupon.discountPercentage)% OFF")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.green)
                    .cornerRadius(4)
                
                Spacer()
                
                // Expires date
                Text("Expires: \(expiryDate(coupon.expiryDate))")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal)
            
            // Title & Description
            Text(coupon.title)
                .font(.headline)
                .lineLimit(1)
                .padding(.horizontal)
            
            Text(coupon.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(2)
                .padding(.horizontal)
                .padding(.bottom)
        }
        .frame(width: 260, height: 230)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
    
    private func expiryDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yy"
        return formatter.string(from: date)
    }
}

// Extension for rounded corners
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat
    var corners: UIRectCorner
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
    RewardView()
        .environmentObject(UserPortfolio())
}
