//
//  Restaurant.swift
//  FoodPin
//
//  Created by Simon Ng on 5/11/2024.
//

import Foundation
import UIKit
import SwiftData

@Model class Restaurant: Hashable {
    
    enum Rating: String, CaseIterable {
        case awesome
        case good
        case okay
        case bad
        case terrible
        
        var imgage: String {
            switch self {
            case .awesome: return "love"
            case .good: return "cool"
            case .okay: return "happy"
            case .bad: return "sad"
            case .terrible: return "angry"
                
            }
        }
    }
    
    var id: String = ""
    var name: String = ""
    var type: String = ""
    var location: String = ""
    var phone: String = ""
    var summary: String = ""
    @Attribute(.externalStorage) var imageData = Data()
    
    @Transient var image: UIImage {
        get {
            UIImage(data: imageData) ?? UIImage()
        }
        
        set {
            self.imageData = newValue.pngData() ?? Data()
        }
    }
    
    var isFavorite: Bool = false
    
    @Transient var rating: Rating? {
        get {
            guard let ratingText = ratingText else {
                return nil
            }
            return Rating(rawValue: ratingText)
        }
        
        set {
            self.ratingText = newValue?.rawValue
        }
    }
    
    @Attribute(originalName: "rating") var ratingText: Rating.RawValue?
    
    init(name: String = "", type: String = ""
    , location: String = "", phone: String = ""
    , description: String = "", image: UIImage = UIImage()
    , isFavorite: Bool = false, rating: Rating? = nil) {
    self.id = UUID().uuidString
    self.name = name
    self.type = type
    self.location = location
    self.phone = phone
    self.summary = description
    self.image = image
    self.isFavorite = isFavorite
    self.rating = rating
    }
}

