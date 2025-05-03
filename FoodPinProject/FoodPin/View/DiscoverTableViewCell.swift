//
//  DiscoverTableViewCell.swift
//  FoodPin
//
//  Created by Ken on 2025/5/3.
//

import UIKit
import SnapKit

class DiscoverTableViewCell: UITableViewCell {
    
    var image: UIImageView = {
        var object = UIImageView()
        object.translatesAutoresizingMaskIntoConstraints = false
        object.contentMode = .scaleAspectFill
        object.layer.cornerRadius = 10
        object.clipsToBounds = true
        object.image = UIImage(systemName: "photo")
        object.tintColor = .black
        
        return object
    }()
    
    var name: UILabel = {
       var object = UILabel()
        object.textColor = UIColor.label
        object.font = UIFont.boldSystemFont(ofSize: 18)
        object.numberOfLines = 0
        
        return object
    }()
    
    var type: UILabel = {
       var object = UILabel()
        object.textColor = UIColor.darkGray
        object.font = UIFont.systemFont(ofSize: 14)
        object.numberOfLines = 0
        
        return object
    }()
    
    var introduction: UILabel = {
       var object = UILabel()
        object.textColor = UIColor.darkGray
        object.font = UIFont.systemFont(ofSize: 14)
        object.numberOfLines = 7
        
        return object
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented " + coder.debugDescription)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure() {
        contentView.addSubview(image)
        contentView.addSubview(name)
        contentView.addSubview(type)
        contentView.addSubview(introduction)
        
        image.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(200)
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalToSuperview().offset(10)
        }
        
        name.snp.makeConstraints { make in
            make.top.equalTo(image.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(30)
        }
        
        type.snp.makeConstraints { make in
            make.top.equalTo(name.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview().inset(30)
        }
        
        introduction.snp.makeConstraints { make in
            make.top.equalTo(type.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview().inset(30)
            make.bottom.greaterThanOrEqualToSuperview().inset(30)
        }
    }
    
    func setupCell(image: Data?, name: String, type: String, description: String) {
        if let image = image {
            self.image.image = UIImage(data: image)
        }
        self.name.text = name
        self.type.text = type
        self.introduction.text = description
    }

}
