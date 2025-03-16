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
        
        List(restaurantNames.indices, id: \.self) {index in
            HStack(alignment: .top, spacing: 20) {
                Image(restaurantImages[index])
                    .resizable()
                    .frame(width: 120, height: 118)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                VStack(alignment: .leading) {
                    Text(restaurantNames[index])
                        .font(.system(.title2, design: .rounded))
                    Text("type")
                        .font(.system(.body, design: .rounded))
                    Text("location")
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundStyle(.gray)
                }
            }
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
