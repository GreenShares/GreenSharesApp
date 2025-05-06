import SwiftUI

struct SplashView: View {
    @State private var showOnboarding = false
    @Binding var isLoggedIn: Bool
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            // Logo
            Image("MoneyPlant")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 200)
                .padding(.bottom, 10)
            
            // Tag line
            Text("Invest in the planet, grow your wealth")
                .font(.title2)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Text("Carbon offsets made simple")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Spacer()
            
            // Get Started button
            Button(action: {
                showOnboarding = true
            }) {
                Text("Get Started")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 50)
        }
        .fullScreenCover(isPresented: $showOnboarding) {
            OnboardingView(isLoggedIn: $isLoggedIn)
        }
    }
}

#Preview {
    SplashView(isLoggedIn: .constant(false))
}
