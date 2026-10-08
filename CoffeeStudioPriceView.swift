import SwiftUI
import FirebaseFirestore
import FirebaseAuth
struct CoffeeStudioPriceView: View {
    @State private var coffeeItems: [CoffeeItem] = []
    @State private var cart: [CartItem] = [] // Cart items with quantities
    @State private var showCartSummary = false

    private let db = Firestore.firestore()

    var body: some View {
        VStack {
            List(coffeeItems) { coffee in
                HStack(alignment: .top, spacing: 15) {
                    // Coffee Image
                    Image("cappuccino_icon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .shadow(radius: 5)

                    // Coffee Details
                    VStack(alignment: .leading, spacing: 5) {
                        Text(coffee.name)
                            .font(.headline)
                            .foregroundColor(.primary)

                        Text("$\(String(format: "%.2f", coffee.price))")
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        Text(coffee.feature)
                            .font(.footnote)
                            .foregroundColor(.gray)
                        
                        
                    }

                    Spacer()

                    // Add to Cart Button
                    Button(action: {
                        addToCart(coffee)
                    }) {
                        Text("Add to Cart")
                            .font(.system(size: 14, weight: .semibold))
                            .padding(.horizontal, 15)
                            .padding(.vertical, 8)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding(.vertical, 8)
            }
            .listStyle(PlainListStyle())

            // Cart Summary Button
            if !cart.isEmpty {
                Button(action: {
                    showCartSummary.toggle()
                }) {
                    Text("View Cart (\(cart.count) items)")
                        .font(.system(size: 16, weight: .bold))
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .padding(.horizontal)
            }
        }
        .onAppear(perform: fetchCoffeeItems)
        .sheet(isPresented: $showCartSummary) {
            CartSummaryView(cart: $cart) {
                savePurchase($0)
            }
        }
        .navigationTitle("Coffee Studio Prices")
        .navigationBarTitleDisplayMode(.inline)
    }


    // Fetch Coffee Items from Firestore
    private func fetchCoffeeItems() {
        db.collection("coffeeItems").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching coffee items: \(error)")
                return
            }

            self.coffeeItems = snapshot?.documents.compactMap { document -> CoffeeItem? in
                let data = document.data()
                guard let name = data["name"] as? String,
                      let price = data["price"] as? Double,
                      let feature = data["feature"] as? String else {
                    return nil
                }
                return CoffeeItem(id: document.documentID, name: name, price: price, feature: feature)
            } ?? []
        }
    }

    // Add Coffee to Cart
    private func addToCart(_ coffee: CoffeeItem) {
        if let index = cart.firstIndex(where: { $0.item.id == coffee.id }) {
            cart[index].quantity += 1
        } else {
        
            cart.append(CartItem(item: coffee, quantity: 1))
        }
    }

    // Save the confirmed order
    private func savePurchase(_ cartItems: [CartItem]) {
        // Retrieve the logged-in user's email
        guard let userEmail = Auth.auth().currentUser?.email else {
            print("No logged-in user email found")
            return
        }

        // Create the purchase data
        let purchaseData: [String: Any] = [
            "items": cartItems.map { ["name": $0.item.name, "price": $0.item.price, "quantity": $0.quantity] },
            "totalPrice": cartItems.reduce(0) { $0 + ($1.item.price * Double($1.quantity)) },
            "timestamp": Timestamp(),
            "email": userEmail // Store the user's email
        ]

        // Save the purchase data to Firestore
        db.collection("purchaseHistory").addDocument(data: purchaseData) { error in
            if let error = error {
                print("Error saving purchase: \(error)")
            } else {
                print("Purchase saved successfully with email: \(userEmail)")
            }
        }
    }

}

// Cart Item Model
struct CartItem: Identifiable {
    var id: String { item.id }
    var item: CoffeeItem
    var quantity: Int
}
