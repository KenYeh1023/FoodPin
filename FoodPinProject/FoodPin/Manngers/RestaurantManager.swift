//
//  RestaurantManager.swift
//  FoodPin
//
//  Created by Ken on 2025/4/9.
//

import SwiftData
import UIKit

class RestaurantManager {
    static let shared = RestaurantManager()
    
    let container: ModelContainer
    let mainContext: ModelContext
    
    private init() {
        do {
            container = try ModelContainer(for: Restaurant.self)
            mainContext = ModelContext(container)
        } catch {
            fatalError("RestaurantManager Error:" + error.localizedDescription)
        }
    }
    
    func fetchRestaurantCount() -> Int {
        let context = RestaurantManager.shared.mainContext
        
        let descriptor = FetchDescriptor<Restaurant>()
        
        do {
            let count = try context.fetchCount(descriptor)
            return count
        } catch {
            return 0
        }
    }
    
    func fetchRestaurantAll() -> [Restaurant]? {
        let context = RestaurantManager.shared.mainContext
        
        let descriptor = FetchDescriptor<Restaurant>()
        
        do {
            let results = try context.fetch(descriptor)
            return results
        } catch {
            return nil
        }
    }
    
    func fetchRestaurantById(id: String) -> Restaurant?{
        let context = RestaurantManager.shared.mainContext
        
        let predicate = #Predicate<Restaurant>{$0.id == id}
        let descriptor = FetchDescriptor<Restaurant>(predicate: predicate)
        
        do {
            let results = try context.fetch(descriptor)
            return results.first
        } catch {
            return nil
        }
    }
}
