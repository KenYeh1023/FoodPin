//
//  ContentView.swift
//  FoodPinProject
//
//  Created by Ken on 2025/3/16.
//

import SwiftUI

struct RestaurantListView: View {
    
//    var restaurants: [Restaurant] = []
//    var restaurantNames = ["Cafe Deadend", "Homei", "Teakha", "Cafe Loisl", "Petite Oy ster", "For Kee Restaurant", "Po's Atelier", "Bourke Street Bakery", "Haigh's Choc olate", "Palomino Espresso", "Upstate", "Traif", "Graham Avenue Meats", "Waffle & Wolf", "Five Leaves", "Cafe Lore", "Confessional", "Barrafina", "Donostia", "Royal Oak", "CASK Pub and Kitchen"]
//    
//    var restaurantImages = ["cafedeadend", "homei", "teakha", "cafeloisl", "petiteoyster", "forkee", "posatelier", "bourkestreetbakery", "haigh", "palomino", "upstate", "traif", "graham", "waffleandwolf", "fiveleaves", "cafelore", "confessional", "barrafina", "donostia", "royaloak", "cask"]
//    
//    var restaurantLocations = ["Hong Kong", "Hong Kong", "Hong Kong", "Hong Kong", "Ho ng Kong", "Hong Kong", "Hong Kong", "Sydney", "Sydney", "Sydney", "New York", "New York", "New York", "New York", "New York", "New York", "New York", "London", "London", "London", "London"]
//    
//    var restaurantTypes = ["Coffee & Tea Shop", "Cafe", "Tea House", "Austrian / Causu al Drink", "French", "Bakery", "Bakery", "Chocolate", "Cafe", "American / Seafood" , "American", "American", "Breakfast & Brunch", "Coffee & Tea", "Coffee & Tea", "L atin American", "Spanish", "Spanish", "Spanish", "British", "Thai"]
//    
//    @State var restaurantIsFavorites = Array(repeating: false, count: 21)
    
    @State var restaurants = [Restaurant(name: "Cafe Deadend", type: "Coffee & Tea Shop", location: "Hong Kong", image: "cafedeadend", isFavorite: false), Restaurant(name: "Homei", type: "Cafe", location: "Hong Kong", image: "homei", isFavorite: false), Restaurant(name: "Teakha", type: "Tea House", location: "Hong Kong", image: "teakha", isFavorite: false), Restaurant(name: "Cafe loisl", type: "Austrian / Causual Drink", location: "Hong Kong", image: "cafeloisl", isFavorite: false), Restaurant(name: "Petite Oyster", type: "French", location: "Hong Kong", image : "petiteoyster", isFavorite: false), Restaurant(name: "For Kee Restaurant", type: "Bakery", location: "Hong Kong", image: "forkee", isFavorite: false), Restaurant(name: "Po's Atelier", type: "Bakery", location: "Hong Kong", image: "posatelier", isFavorite: false), Restaurant(name: "Bourke Street Backery", type: "Chocolate", location: "Sydney" , image: "bourkestreetbakery", isFavorite: false), Restaurant(name: "Haigh's Chocolate", type: "Cafe", location: "Sydney", image: "haigh", isFavorite: false), Restaurant(name: "Palomino Espresso", type: "American / Seafood", location: "S ydney", image: "palomino", isFavorite: false), Restaurant(name: "Upstate", type: "American", location: "New York", image: "upstate", isFavorite: false), Restaurant(name: "Traif", type: "American", location: "New York", image: "traif", isFavorite: false), Restaurant(name: "Graham Avenue Meats", type: "Breakfast & Brunch", location: "New York", image: "graham", isFavorite: false), Restaurant(name: "Waffle & Wolf", type: "Coffee & Tea", location: "New York", image: "waffleandwolf", isFavorite: false), Restaurant(name: "Five Leaves", type: "Coffee & Tea", location: "New York", image: "fiveleaves", isFavorite: false), Restaurant(name: "Cafe Lore", type: "Latin American", location: "New York", image: "cafelore", isFavorite: false), Restaurant(name: "Confessional", type: "Spanish", location: "New York", image: "confessional", isFavorite: false), Restaurant(name: "Barrafina", type: "Spanish", location: "London", image: "barrafina", isFavorite: false), Restaurant(name: "Donostia", type: "Spanish", location: "London", image: "dono stia", isFavorite: false), Restaurant(name: "Royal Oak", type: "British", location: "London", image: "royaloak", isFavorite: false), Restaurant(name: "CASK Pub and Kitchen", type: "Thai", location: "London", image: "cask", isFavorite: false)]
    
    var body: some View {
        List(restaurants.indices, id: \.self) {index in
            TableImageTextRow(restaurant: $restaurants[index])
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
    }
}

#Preview {
    RestaurantListView()
}

struct TableImageTextRow: View {
    // MARK: - Binding
    @Binding var restaurant: Restaurant
    // MARK: - State variables
    @State private var showOptions = false
    @State private var showError = false
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(restaurant.image)
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            LazyVStack(alignment: .leading) {
                Text(restaurant.name)
                    .font(.system(.title2, design: .rounded))
                Text(restaurant.location)
                    .font(.system(.subheadline, design: .rounded))
                Text(restaurant.type)
                    .font(.system(.body, design: .rounded))
                    .foregroundStyle(.gray)
                    .onAppear {
                        print("Row Appeared!.")
                    }
            }
            if restaurant.isFavorite {
                Spacer()
                Image(systemName: "heart.fill")
                    .foregroundStyle(.yellow)
            }
        }
        .onTapGesture {
            showOptions.toggle()
        }
        .confirmationDialog("What do you want to do?", isPresented: $showOptions, titleVisibility: .visible) {
            Button("Reserve a Table"){
                self.showError.toggle()
            }
            Button(self.restaurant.isFavorite ? "Remove from favorites" : "Mark as favorite"){
                self.restaurant.isFavorite.toggle()
            }
        }
        .alert("Not yet available", isPresented: $showError) {
            Button("OK") {
            }
        } message: {
            Text("Sorrym this feature is not available yet. Please retry later.")
        }
    }
}

