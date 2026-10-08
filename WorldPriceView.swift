//
//  WorldPriceView.swift
//  CoffeeStudio
//
//  Created by Sayaka Alam on 12/1/25.
//

import Foundation
import SwiftUI
// MARK: - WorldPriceView
struct WorldPriceView: View {
    @State private var coffeeList: [Coffee] = []
    @State private var isLoading = true
    @State private var errorMessage: String?

    var body: some View {
        NavigationView {
            VStack {
                if isLoading {
                    ProgressView("Loading Coffee...")
                        .padding()
                } else if let errorMessage = errorMessage {
                    VStack {
                        Text("Error: \(errorMessage)")
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                } else {
                    List(coffeeList) { coffee in
                        NavigationLink(destination: CoffeeDetailsView(coffee: coffee)) {
                            VStack(alignment: .leading) {
                                Text(coffee.name)
                                    .font(.headline)
                                Text("Region: \(coffee.region)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .navigationTitle("Coffee List")
                }
            }
        }
        .onAppear(perform: fetchCoffeeData)
    }
    
    // MARK: - Fetch Coffee Data
    func fetchCoffeeData() {
        guard let url = URL(string: "https://fake-coffee-api.vercel.app/api") else {
            self.errorMessage = "Invalid URL"
            self.isLoading = false
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                    return
                }
                
                guard let data = data else {
                    self.errorMessage = "No data received"
                    self.isLoading = false
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let fetchedCoffeeList = try decoder.decode([Coffee].self, from: data)
                    self.coffeeList = fetchedCoffeeList
                } catch {
                    self.errorMessage = "Failed to decode data: \(error.localizedDescription)"
                }
                
                self.isLoading = false
            }
        }.resume()
    }
}

// MARK: - CoffeeDetailsView
struct CoffeeDetailsView: View {
    var coffee: Coffee
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                AsyncImage(url: URL(string: coffee.imageURL)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 300)
                            .cornerRadius(10)
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 300)
                            .foregroundColor(.gray)
                    @unknown default:
                        EmptyView()
                    }
                }
                
                Text(coffee.name)
                    .font(.largeTitle)
                    .bold()
                
                Text("Price: $\(coffee.price, specifier: "%.2f")")
                    .font(.title2)
                
                Text("Region: \(coffee.region)")
                    .font(.title3)
                
                Text("Roast Level: \(coffee.roastLevel)")
                    .font(.headline)
                
                Text("Weight: \(coffee.weight)g")
                    .font(.body)
                
                Text("Flavor Profile:")
                    .font(.headline)
                Text(coffee.flavorProfile.joined(separator: ", "))
                    .font(.body)
                    .italic()
                
                Text("Description:")
                    .font(.headline)
                Text(coffee.description)
                    .font(.body)
                
            
            }
            .padding()
        }
        .navigationTitle(coffee.name)
    }
}

struct WorldPriceView_Previews: PreviewProvider{
    static var previews: some View{
        WorldPriceView()
    }
}
