import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct PurchaseHistoryView: View {
    @State private var purchaseHistory: [Purchase] = []

    private let db = Firestore.firestore()

    var body: some View {
        VStack {
            if purchaseHistory.isEmpty {
                Text("No purchase history available.")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding()
            } else {
                List(purchaseHistory) { purchase in
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Order Date: \(purchase.timestamp.formattedDate())")
                            .font(.headline)

                        ForEach(purchase.items, id: \.id) { item in
                            HStack {
                                Text("\(item.name) x \(item.quantity)")
                                Spacer()
                                Text("$\(String(format: "%.2f", item.price * Double(item.quantity)))")
                            }
                        }

                        Text("Total: $\(String(format: "%.2f", purchase.totalPrice))")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 8)
                }
                .listStyle(InsetGroupedListStyle())
            }
        }
        .onAppear(perform: fetchPurchaseHistory)
        .navigationTitle("Purchase History")
    }


    // Define currentUser as a global variable
    var currentUser: String? {
        return Auth.auth().currentUser?.email
    }

    private func fetchPurchaseHistory() {
        db.collection("purchaseHistory").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching purchase history: \(error)")
                return
            }

            self.purchaseHistory = snapshot?.documents.compactMap { document -> Purchase? in
                let data = document.data()
                guard let itemsData = data["items"] as? [[String: Any]],
                      let totalPrice = data["totalPrice"] as? Double,
                      let userMail = data["email"] as? String,
                      let timestamp = data["timestamp"] as? Timestamp else {
                    return nil
                }

                // Ensure userMail matches the global currentUser
                guard let currentUser = currentUser, userMail == currentUser else {
                    return nil
                }

                let items = itemsData.compactMap { itemData -> PurchasedItem? in
                    guard let name = itemData["name"] as? String,
                          let price = itemData["price"] as? Double,
                          let quantity = itemData["quantity"] as? Int else {
                        return nil
                    }
                    return PurchasedItem(id: UUID().uuidString, name: name, price: price, quantity: quantity)
                }

                return Purchase(id: document.documentID, items: items, totalPrice: totalPrice, timestamp: timestamp.dateValue())
            } ?? []
        }
    }
    }

// MARK: - Models
struct PurchasedItem: Identifiable {
    var id: String
    var name: String
    var price: Double
    var quantity: Int
}

struct Purchase: Identifiable {
    var id: String
    var items: [PurchasedItem]
    var totalPrice: Double
    var timestamp: Date
}

// MARK: - Date Extension
extension Date {
    func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: self)
    }
}
