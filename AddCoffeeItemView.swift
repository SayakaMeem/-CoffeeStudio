import SwiftUI
import FirebaseFirestore

struct AddCoffeeItemView: View {
    @State private var coffeeName: String = ""
    @State private var price: String = ""
    @State private var feature: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""

    // Firestore reference
    private let db = Firestore.firestore()

    var body: some View {
        VStack(spacing: 20) {
            Text("Add Coffee Item")
                .font(.title)
                .padding()

            // Coffee Name Input
            TextField("Enter Coffee Name", text: $coffeeName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            // Price Input
            TextField("Enter Price", text: $price)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.decimalPad) // Numeric Keyboard
                .padding()

            // Feature Input
            TextField("Enter Feature", text: $feature)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            // Save Button
            Button(action: saveCoffeeItem) {
                Text("Save")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()

            Spacer()
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Message"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }

    // Save Coffee Item to Firestore
    private func saveCoffeeItem() {
        // Validate Inputs
        guard !coffeeName.isEmpty, !price.isEmpty, !feature.isEmpty else {
            alertMessage = "Please fill in all fields."
            showAlert = true
            return
        }

        // Parse Price to Double
        guard let coffeePrice = Double(price) else {
            alertMessage = "Please enter a valid price."
            showAlert = true
            return
        }

        // Firestore Data
        let coffeeData: [String: Any] = [
            "name": coffeeName,
            "price": coffeePrice,
            "feature": feature,
            "timestamp": Timestamp()
        ]

        // Save to Firestore
        db.collection("coffeeItems").addDocument(data: coffeeData) { error in
            if let error = error {
                alertMessage = "Failed to save item: \(error.localizedDescription)"
                showAlert = true
            } else {
                alertMessage = "Coffee item added successfully!"
                showAlert = true

                // Clear Fields
                coffeeName = ""
                price = ""
                feature = ""
            }         }
    }
}
