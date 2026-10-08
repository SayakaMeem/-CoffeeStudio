import SwiftUI
import FirebaseAuth

struct HomeView: View {
    @Binding var isAuthenticated: Bool

    var body: some View {
        NavigationView {
            ZStack {
                // Background Image with Overlay
                Image("coffee_shop_background") // Replace with your asset name
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .overlay(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.black.opacity(0.7), Color.clear]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )

                // Main Content
                ScrollView {
                    VStack(spacing: 25) {
                        Text("Welcome to Coffee Haven")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .padding(.top, 40)

                        NavigationButton(
                            title: "World Wide Coffee Price",
                            backgroundColor: Color.gray.opacity(0.8),
                            destination: WorldPriceView()
                        )

                        NavigationButton(
                            title: "Coffee Studio Price",
                            backgroundColor: Color.gray.opacity(0.8),
                            destination: CoffeeStudioPriceView()
                        )

                        NavigationButton(
                            title: "Purchase History",
                            backgroundColor: Color.gray.opacity(0.8),
                            destination: PurchaseHistoryView()
                        )

                        NavigationButton(
                            title: "Add Coffee Item",
                            backgroundColor: Color.gray.opacity(0.8),
                            destination: AddCoffeeItemView()
                        )

                        Button(action: {
                            try? Auth.auth().signOut()
                            isAuthenticated = false
                        }) {
                            Text("Log Out")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.black.opacity(0.7))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 3)
                        }
                        .padding(.horizontal)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
            }
            .navigationTitle("Home")
        }
    }
}

// Custom Navigation Button
struct NavigationButton<Destination: View>: View {
    let title: String
    let backgroundColor: Color
    let destination: Destination

    var body: some View {
        NavigationLink(destination: destination) {
            Text(title)
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(backgroundColor)
                .foregroundColor(.white)
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 3)
        }
        .padding(.horizontal)
    }
}

struct HomeView_Previews: PreviewProvider {
    @State static var isAuthenticated = true

    static var previews: some View {
        HomeView(isAuthenticated: $isAuthenticated)
    }
}
