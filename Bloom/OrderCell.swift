//
//  OrderCell.swift
//  Bloom
//
//  Created by Vadim on 13.06.17.
//  Copyright © 2017 asamasa. All rights reserved.
//

import UIKit

class OrderCell: BaseCell {
    
    let firstCategoryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "")
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = UIColor(red: 149/255, green: 146/255, blue: 146/255, alpha: 1)
        imageView.isHidden = true
        imageView.tintColor = UIColor.white
        imageView.layer.cornerRadius = 3.45
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let secondCategoryLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = UIColor.white
        label.font = UIFont(name: "Comfortaa", size: 13)
        label.textAlignment = .center
        label.backgroundColor = UIColor(red: 149/255, green: 146/255, blue: 146/255, alpha: 1)
        label.numberOfLines = 2
        label.layer.cornerRadius = 3.45
        label.layer.masksToBounds = true
        label.isHidden = true
        return label
    }()
    
    let thirdCategoryLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = UIFont(name: "Comfortaa", size: 13)
        label.backgroundColor = UIColor(red: 149/255, green: 146/255, blue: 146/255, alpha: 1)
        label.numberOfLines = 2
        label.layer.cornerRadius = 3.45
        label.layer.masksToBounds = true
        label.isHidden = true
        return label
    }()
    
    let fourthCategoryLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.backgroundColor = UIColor(red: 149/255, green: 146/255, blue: 146/255, alpha: 1)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.isHidden = true
        label.font = UIFont(name: "Comfortaa", size: 13)
        label.numberOfLines = 2
        label.layer.cornerRadius = 3.45
        label.layer.masksToBounds = true
        return label
    }()
    
    override func setupViews() {
        super.setupViews()
        
        
        addSubview(firstCategoryImageView)
        addSubview(secondCategoryLabel)
        addSubview(thirdCategoryLabel)
        addSubview(fourthCategoryLabel)
        
        addConstraintsWithFormat(format: "H:|-5-[v0(45)]-5-[v1]-5-[v2]-5-[v3(60)]-5-|", views: firstCategoryImageView, secondCategoryLabel, thirdCategoryLabel, fourthCategoryLabel)
        
        addConstraint(NSLayoutConstraint(item: secondCategoryLabel, attribute: .width, relatedBy: .equal, toItem: thirdCategoryLabel, attribute: .width, multiplier: 1, constant: 0))
        
        
        addConstraintsWithFormat(format: "V:|[v0]|", views: firstCategoryImageView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: secondCategoryLabel)
        addConstraintsWithFormat(format: "V:|[v0]|", views: thirdCategoryLabel)
        addConstraintsWithFormat(format: "V:|[v0]|", views: fourthCategoryLabel)
    }
    
    
}
