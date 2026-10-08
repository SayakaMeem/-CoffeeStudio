☕ CoffeeStudio
A modern, minimal iOS coffee shop app built with SwiftUI and Firebase. Browse coffee, manage cart, track purchase history, and check live world coffee prices.

Swift
SwiftUI
Firebase
License

Live Repo: https://github.com/SayakaMeem/-CoffeeStudio

✨ Features
Authentication - Login view with Firebase Auth (loginview.swift)
Home Feed - Curated coffee collection (HomeView.swift)
Add Custom Coffee - Create your own coffee item (AddCoffeeItemView.swift)
Cart & Checkout - Cart summary with quantity control (CartSummaryView.swift)
Live Pricing
Local shop pricing (CoffeeStudioPriceView.swift)
World market coffee price tracker (WorldPriceView.swift)
Purchase History - All past orders (PurchaseHistoryView.swift)
Clean Architecture - SwiftUI MVVM with reusable components
🛠️ Tech Stack
Language: Swift 5, SwiftUI
Backend: Firebase (Authentication, Firestore)
UI: SwiftUI, Assets.xcassets with custom icons
Architecture: MVVM
📁 Project Structure
CoffeeStudio/
├── CoffeeStudioApp.swift          # App entry point
├── ContentView.swift              # Root view
├── loginview.swift                # Auth screen
├── HomeView.swift                 # Main coffee feed
├── AddCoffeeItemView.swift        # Add new coffee
├── CartSummaryView.swift          # Cart logic
├── CoffeeStudioPriceView.swift    # Local prices
├── WorldPriceView.swift           # Global prices
├── PurchaseHistoryView.swift      # Order history
├── Assets.xcassets/               # App icons & backgrounds
│   ├── AppIcon
│   ├── background
│   ├── coffee_shop_background
│   └── cappuccino_icon
└── Preview Content/
    ├── Coffee.swift
    └── CoffeeItem.swift
🚀 Getting Started
Clone the repo
git clone https://github.com/SayakaMeem/-CoffeeStudio.git
cd -CoffeeStudio
Open in Xcode
open CoffeeStudio.xcodeproj
# or if using SPM: open Package.swift
Firebase Setup
This project uses GoogleService-Info.plist
Create your own Firebase project at console.firebase.google.com
Replace GoogleService-Info.plist with your own file
Enable Authentication & Firestore
Run
Select an iPhone simulator and press Cmd + R
🔐 Environment
Note: GoogleService-Info.plist is currently in the repo for demo. For production, add it to .gitignore:

echo "GoogleService-Info.plist" >> .gitignore
echo ".DS_Store" >> .gitignore
📸 Screenshots
Add your screenshots here:

/Screenshots/home.png
/Screenshots/cart.png
/Screenshots/prices.png
🤝 Contributing
Fork the repo
Create your branch: git checkout -b feature/AmazingFeature
Commit: git commit -m 'Add AmazingFeature'
Push: git push origin feature/AmazingFeature
Open a Pull Request
👩‍💻 Author
SayakaMeem - GitHub

📄 License
MIT License - feel free to use this for your own projects.

Made with ☕ and SwiftUI
