//
//  ContentView.swift
//  FoodPinProject
//
//  Created by Ken on 2025/3/16.
//

import SwiftUI

struct RestaurantListView: View {
    
    var restaurants: [Restaurant] = []
    var restaurantNames = ["Cafe Deadend", "Homei", "Teakha", "Cafe Loisl", "Petite Oy ster", "For Kee Restaurant", "Po's Atelier", "Bourke Street Bakery", "Haigh's Choc olate", "Palomino Espresso", "Upstate", "Traif", "Graham Avenue Meats", "Waffle & Wolf", "Five Leaves", "Cafe Lore", "Confessional", "Barrafina", "Donostia", "Royal Oak", "CASK Pub and Kitchen"]
    
    var restaurantImages = ["cafedeadend", "homei", "teakha", "cafeloisl", "petiteoyster", "forkee", "posatelier", "bourkestreetbakery", "haigh", "palomino", "upstate", "traif", "graham", "waffleandwolf", "fiveleaves", "cafelore", "confessional", "barrafina", "donostia", "royaloak", "cask"]
    
    var restaurantLocations = ["Hong Kong", "Hong Kong", "Hong Kong", "Hong Kong", "Ho ng Kong", "Hong Kong", "Hong Kong", "Sydney", "Sydney", "Sydney", "New York", "New York", "New York", "New York", "New York", "New York", "New York", "London", "London", "London", "London"]
    
    var restaurantTypes = ["Coffee & Tea Shop", "Cafe", "Tea House", "Austrian / Causu al Drink", "French", "Bakery", "Bakery", "Chocolate", "Cafe", "American / Seafood" , "American", "American", "Breakfast & Brunch", "Coffee & Tea", "Coffee & Tea", "L atin American", "Spanish", "Spanish", "Spanish", "British", "Thai"]
    
    @State var restaurantIsFavorites = Array(repeating: false, count: 21)
    
    var body: some View {
        List(restaurantNames.indices, id: \.self) {index in
            TableImageTextRow(
                isFavorite: $restaurantIsFavorites[index],
                imageName: restaurantImages[index],
                name: restaurantNames[index],
                location: restaurantLocations[index],
                type: restaurantTypes[index])
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
    }
}

#Preview {
    RestaurantListView()
}

class Restaurant {
    var name: String
    var type: String
    var image: Image
    
    init(name: String, type: String, image: Image) {
        self.name = name
        self.type = type
        self.image = image
    }
}

struct TableImageTextRow: View {
    @Binding var isFavorite: Bool
    @State private var showOptions = false
    @State private var showError = false
    
    var imageName: String
    var name: String
    var location: String
    var type: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            LazyVStack(alignment: .leading) {
                Text(name)
                    .font(.system(.title2, design: .rounded))
                Text(location)
                    .font(.system(.subheadline, design: .rounded))
                Text(type)
                    .font(.system(.body, design: .rounded))
                    .foregroundStyle(.gray)
                    .onAppear {
                        print("Row Appeared!.")
                    }
            }
            if isFavorite {
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
            Button(self.isFavorite ? "Remove from favorites" : "Mark as favorite"){
                self.isFavorite.toggle()
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

