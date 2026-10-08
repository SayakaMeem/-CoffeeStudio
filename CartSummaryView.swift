import SwiftUI

struct CartSummaryView: View {
    @Binding var cart: [CartItem]
    @Environment(\.presentationMode) var presentationMode
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var onConfirmOrder: ([CartItem]) -> Void

    var body: some View {
        VStack {
            List {
                ForEach(cart) { cartItem in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(cartItem.item.name)
                            Text("Price: $\(String(format: "%.2f", cartItem.item.price))")
                            Text("Total: $\(String(format: "%.2f", cartItem.item.price * Double(cartItem.quantity)))")
                        }
                        Spacer()
                        Stepper("Qty: \(cartItem.quantity)", value: Binding(
                            get: { cartItem.quantity },
                            set: { newQty in updateQuantity(for: cartItem, to: newQty) }
                        ), in: 1...100)
                    }
                }
            }

            Text("Total: $\(String(format: "%.2f", calculateTotal()))")
                .font(.headline)
                .padding()

            Button("Confirm Order") {
                confirmOrder()
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)

            Spacer()
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Message"), message: Text(alertMessage), dismissButton: .default(Text("OK")) {
                if alertMessage == "Order confirmed!" {
                    presentationMode.wrappedValue.dismiss()
                }
            })
        }
    }

    private func calculateTotal() -> Double {
        cart.reduce(0) { $0 + ($1.item.price * Double($1.quantity)) }
    }

    private func updateQuantity(for cartItem: CartItem, to quantity: Int) {
        if let index = cart.firstIndex(where: { $0.id == cartItem.id }) {
            cart[index].quantity = quantity
        }
    }

    private func confirmOrder() {
        if cart.isEmpty {
            alertMessage = "Your cart is empty."
        } else {
            onConfirmOrder(cart)
            cart.removeAll()
            alertMessage = "Order confirmed!"
        }
        showAlert = true
    }
}
