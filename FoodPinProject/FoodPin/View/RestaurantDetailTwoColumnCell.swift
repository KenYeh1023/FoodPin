//
//  RestaurantDetailTwoColumnCell.swift
//  FoodPin
//
//  Created by Ken on 2025/3/30.
//

import UIKit

class RestaurantDetailTwoColumnCell: UITableViewCell {
    
    @IBOutlet var column1TitleLabel: UILabel! {
        didSet {
            column1TitleLabel.text = column1TitleLabel.text?.uppercased()
            column1TitleLabel.numberOfLines = 0
//            if let customFont = UIFont(name: "Nunito-Bold", size: 12) {
//                column1TitleLabel.font = UIFontMetrics(forTextStyle: .subheadline).scaledFont(for: customFont)
//            }
        }
    }
    
    @IBOutlet var column1TextLabel: UILabel! {
        didSet {
            column1TextLabel.numberOfLines = 0
        }
    }
    
    @IBOutlet var column2TitleLabel: UILabel! {
        didSet {
            column2TitleLabel.text = column2TitleLabel.text?.uppercased()
            column2TitleLabel.numberOfLines = 0
//            if let customFont = UIFont(name: "Nunito-Bold", size: 12) {
//                column2TitleLabel.font = UIFontMetrics(forTextStyle: .subheadline).scaledFont(for: customFont)
//            }
        }
    }
    
    @IBOutlet var column2TextLabel: UILabel! {
        didSet {
            column2TextLabel.numberOfLines = 0
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
