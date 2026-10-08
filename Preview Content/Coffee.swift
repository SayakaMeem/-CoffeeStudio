//
//  Coffee.swift
//  CoffeeStudio
//
//  Created by Sayaka Alam on 12/1/25.
//
import Foundation

// MARK: - Coffee Model
struct Coffee: Codable, Identifiable {
    let id: String
    let coffeeId: Int
    let name, description: String
    let price: Double
    let region: String
    let weight: Int
    let flavorProfile, grindOption: [String]
    let roastLevel: Int
    let imageURL: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case coffeeId = "id"
        case name, description, price, region, weight
        case flavorProfile = "flavor_profile"
        case grindOption = "grind_option"
        case roastLevel = "roast_level"
        case imageURL = "image_url"
    }
}
