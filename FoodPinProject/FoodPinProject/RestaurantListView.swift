//
//  ContentView.swift
//  FoodPinProject
//
//  Created by Ken on 2025/3/16.
//

import SwiftUI

struct RestaurantListView: View {
    var body: some View {
        @State var restaurants: [Restaurant] = []
        @State var restaurantNames = ["Cafe Deadend", "Homei", "Teakha", "Cafe Loisl", "Petite Oy ster", "For Kee Restaurant", "Po's Atelier", "Bourke Street Bakery", "Haigh's Choc olate", "Palomino Espresso", "Upstate", "Traif", "Graham Avenue Meats", "Waffle & Wolf", "Five Leaves", "Cafe Lore", "Confessional", "Barrafina", "Donostia", "Royal Oak", "CASK Pub and Kitchen"]
        
        @State var restaurantImages = ["cafedeadend", "homei", "teakha", "cafeloisl", "petiteoyster", "forkee", "posatelier", "bourkestreetbakery", "haigh", "palomino", "upstate", "traif", "graham", "waffleandwolf", "fiveleaves", "cafelore", "confessional", "barrafina", "donostia", "royaloak", "cask"]
        
        @State var restaurantLocations = ["Hong Kong", "Hong Kong", "Hong Kong", "Hong Kong", "Ho ng Kong", "Hong Kong", "Hong Kong", "Sydney", "Sydney", "Sydney", "New York", "New York", "New York", "New York", "New York", "New York", "New York", "London", "London", "London", "London"]
        
        @State var restaurantTypes = ["Coffee & Tea Shop", "Cafe", "Tea House", "Austrian / Causu al Drink", "French", "Bakery", "Bakery", "Chocolate", "Cafe", "American / Seafood" , "American", "American", "Breakfast & Brunch", "Coffee & Tea", "Coffee & Tea", "L atin American", "Spanish", "Spanish", "Spanish", "British", "Thai"]
        
        List(restaurantNames.indices, id: \.self) {index in
            TableImageTextRow(imageName: restaurantImages[index],
                              name: restaurantNames[index],
                              location: restaurantLocations[index],
                              type: restaurantTypes[index])
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
    
    var imageName: String
    var name: String
    var location: String
    var type: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Image(imageName)
                .resizable()
                .frame(height: 150)
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 12))
            VStack(alignment: .leading) {
                Text(name)
                    .font(.system(.title2, design: .rounded))
                Text(location)
                    .font(.system(.subheadline, design: .rounded))
                Text(type)
                    .font(.system(.body, design: .rounded))
                    .foregroundStyle(.gray)
            }
        }
        .listRowSeparator(.hidden)
    }
}

