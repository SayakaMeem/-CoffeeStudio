//
//  CoffeeStudioApp.swift
//  CoffeeStudio
//
//  Created by Sayaka Alam on 11/1/25.
//

import SwiftUI
import Firebase

@main
struct CoffeeStudioApp: App {
    init(){
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
//            ContentView()
//            WorldPriceView()
            LoginView()
        }
    }
}
