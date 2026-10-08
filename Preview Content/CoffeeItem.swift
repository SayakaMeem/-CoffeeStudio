//
//  CoffeeItem.swift
//  CoffeeStudio
//
//  Created by Sayaka Alam on 14/1/25.
//

import Foundation

struct CoffeeItem: Identifiable {
    var id: String          // Unique identifier for the coffee item
    var name: String        // Name of the coffee
    var price: Double       // Price of the coffee
    var feature: String     // Feature/description of the coffee
}
