//
//  RestaurantDetailHeaderView.swift
//  FoodPin
//
//  Created by Ken on 2025/3/30.
//

import UIKit

class RestaurantDetailHeaderView: UIView {
    
    @IBOutlet var headerImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel! {
        didSet {
            nameLabel.numberOfLines = 0
            
            if let customFont = UIFont(name: "Nunito-Bold", size: 40.0) {
                nameLabel.font = UIFontMetrics(forTextStyle: .title1).scaledFont(for: customFont)
            }
        }
    }
    @IBOutlet var typeLabel: UILabel! {
        didSet {
            if let customFont = UIFont(name: "Nunito-Regular", size: 16.0) {
                typeLabel.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: customFont)
            }
        }
    }
//    @IBOutlet var headerButton: UIButton!
    @IBOutlet var headerButton: UIBarButtonItem!
    @IBOutlet var ratingImageView: UIImageView!

}
