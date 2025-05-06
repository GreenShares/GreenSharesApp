//
//  OnboardingView.swift
//  GreenShares
//
//  Created by keanu  on 27/4/2025.
//

import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @State private var showSignUp = false
    @State private var showLogin = false
    @Binding var isLoggedIn: Bool
    @Environment(\.dismiss) private var dismiss
    
    private let totalPages = 3

    var body: some View {
        ZStack {
            // Color
            LinearGradient(
                colors: [Color.green.opacity(1.8), Color.green.opacity(0.2)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            // Main Content
            TabView(selection: $currentPage) {
                onboardingPage(
                    title: "Grow a Climate Positive Portfolio",
                    description1: "Invest in high-performing verified climate assets",
                    description2: "GreenShares offers access to curated carbon portfolios backed by science build for investors.",
                    imageName: "PlantGrowing",
                    tag: 0
                )
                onboardingPage(
                    title: "De-risk While Earning Rewards",
                    description1: "Build long-term value with built-in protection",
                    description2: "All trades include automatic climate alignment helping you access exclusive incentives minimizing greenwashing risk.",
                    imageName: "MoneyPlant",
                    tag: 1
                )
                onboardingPage(
                    title: "Get Rewarded for Going Green",
                    description1: "Your impact earns you more than returns",
                    description2: "Invest more → retire more → unlock more",
                    imageName: "Trees",
                    tag: 2)
                lastPage()
            }
            .tabViewStyle(.page)
            .animation(.easeInOut(duration: 0.5), value: currentPage)
        }
        .fullScreenCover(isPresented: $showSignUp) {
            SignUpView()
        }
        .fullScreenCover(isPresented: $showLogin) {
            LoginView(isLoggedIn: $isLoggedIn)
        }
    }
    
    // Creates a regular onboarding page
    func onboardingPage(title: String, description1: String, description2: String, imageName: String, tag: Int) -> some View {
        VStack(spacing: 20) {
            Text(title)
                .font(.largeTitle)
                .multilineTextAlignment(.center)
                .bold()
                .opacity(currentPage == tag ? 1 : 0)
                .offset(x: currentPage == tag ? 0 : 50)
                .animation(.easeInOut, value: currentPage)
            
            Text(description1)
                .font(.body.bold())
                .multilineTextAlignment(.center)
                .padding()
                .opacity(currentPage == tag ? 1 : 0)
                .offset(x: currentPage == tag ? 0 : 50)
                .animation(.easeInOut, value: currentPage)
            
            Text(description2)
                .font(.body)
                .multilineTextAlignment(.center)
                .opacity(currentPage == tag ? 1 : 0)
                .offset(x: currentPage == tag ? 0 : 50)
                .animation(.easeInOut, value: currentPage)
            
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 300)
                .opacity(currentPage == tag ? 1 : 0)
                .offset(x: currentPage == tag ? 0 : 50)
                .cornerRadius(20.0)
                .animation(.easeInOut, value: currentPage)
        }
        .padding()
        .tag(tag)
    }
    
    // Signup/Login Page
    func lastPage() -> some View {
        VStack(spacing: 20) {
            Text("Get Started with GreenShares")
                .font(.largeTitle)
                .multilineTextAlignment(.center)
                .bold()
            
            Text("Track, offset, and trade carbon credits easily.")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding()
            
            Image("Trees")
                .resizable()
                .scaledToFit()
                .frame(height: 250)
                .cornerRadius(20)
            
            Button("Login") {
                showLogin = true
            }
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .cornerRadius(12)
            .padding(.horizontal, 40)
            
            Button("Sign Up") {
                showSignUp = true
            }
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.green)
            .cornerRadius(12)
            .padding(.horizontal, 40)
            .padding(.bottom)
        }
        .padding()
        .tag(3)
    }
}

#Preview {
    OnboardingView(isLoggedIn: .constant(false))
}

