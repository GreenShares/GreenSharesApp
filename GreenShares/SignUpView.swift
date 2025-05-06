import SwiftUI

struct SignUpView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isVerifying = false
    @State private var isVerified = false
    @State private var showMainApp = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 25) {
                    Text("Create Account")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top, 50)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Email")
                            .font(.headline)
                        TextField("name@example.com", text: $email)
                            .textInputAutocapitalization(.never)
                            .disableAutocorrection(true)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(.systemGray6))
                            )
                    }
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Password")
                            .font(.headline)
                        SecureField("Minimum 8 characters", text: $password)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(.systemGray6))
                            )
                    }
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Confirm Password")
                            .font(.headline)
                        SecureField("Re-enter password", text: $confirmPassword)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(.systemGray6))
                            )
                    }
                    .padding(.horizontal)
                    
                    Button(action: verifyAccount) {
                        Text("Create Account")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(email.isEmpty || password.isEmpty || password != confirmPassword ? Color.gray : Color.green)
                            )
                    }
                    .disabled(email.isEmpty || password.isEmpty || password != confirmPassword)
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    Button("Already have an account? Sign in") {
                        dismiss()
                    }
                    .font(.subheadline)
                    .padding(.bottom)
                }
                
                // Verification overlay
                if isVerifying {
                    Color.black.opacity(0.5)
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack(spacing: 20) {
                        if !isVerified {
                            ProgressView()
                                .scaleEffect(2.0)
                                .padding()
                            Text("Verifying account...")
                                .font(.headline)
                                .foregroundColor(.white)
                        } else {
                            Image(systemName: "checkmark.circle.fill")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .foregroundColor(.green)
                            Text("Verified!")
                                .font(.title)
                                .bold()
                                .foregroundColor(.white)
                        }
                    }
                    .frame(width: 250, height: 250)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color.black.opacity(0.7))
                    )
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action: {
                dismiss()
            }) {
                Image(systemName: "arrow.left")
                    .foregroundColor(.primary)
            })
            .fullScreenCover(isPresented: $showMainApp) {
                ContentView(isLoggedIn: true)
            }
        }
    }
    
    func verifyAccount() {
        isVerifying = true
        
        // Simulate 2-second verification process
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isVerified = true
            
            // After showing the checkmark for 1 second, navigate to the main app
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                showMainApp = true
            }
        }
    }
}

// Modified ContentView initializer to accept isLoggedIn
struct ContentView_WithLoginParam: View {
    @State var isLoggedIn: Bool
    
    var body: some View {
        // Same as ContentView but with injected isLoggedIn
        if isLoggedIn {
            TabView {
                TrackView()
                    .tabItem {
                        Image(systemName: "chart.pie.fill")
                        Text("Track")
                    }
                InvestView()
                    .tabItem {
                        Image(systemName: "leaf.arrow.circlepath")
                        Text("Invest")
                    }
                TradeView()
                    .tabItem {
                        Image(systemName: "chart.line.uptrend.xyaxis")
                        Text("Trade")
                    }
                RewardView()
                    .tabItem {
                        Image(systemName: "star.fill")
                        Text("Reward")
                    }
            }
        } else {
            LoginView(isLoggedIn: $isLoggedIn)
        }
    }
}

#Preview {
    SignUpView()
}