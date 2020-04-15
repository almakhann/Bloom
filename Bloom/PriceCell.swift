//
//  PriceCell.swift
//  Bloom
//
//  Created by Vadim on 05.07.17.
//  Copyright © 2017 asamasa. All rights reserved.
//

import UIKit

class PriceCell: BaseCell {
    
    let categoryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "")
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        imageView.tintColor = UIColor.white
        return imageView
    }()
    
    let categoryNameLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = UIColor.white
        label.font = UIFont(name: "Comfortaa", size: 13)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.layer.cornerRadius = 3.45
        label.layer.masksToBounds = true
        label.isHidden = true
        return label
    }()
    
    let currentPriceLabel: UILabel = {
        let label = UILabel()
        label.text = "Текущая цена"
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = UIFont(name: "Comfortaa", size: 13)
        label.layer.cornerRadius = 3.45
        label.layer.masksToBounds = true
        label.isHidden = true
        return label
    }()
    
    let currentCategoryPriceLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = UIFont(name: "Comfortaa", size: 13)
        label.layer.cornerRadius = 3.45
        label.layer.masksToBounds = true
        label.isHidden = true
        label.tintColor = UIColor.white
        label.backgroundColor = UIColor(red: 149/255, green: 146/255, blue: 146/255, alpha: 1)
        return label
    }()
    
    let arrowImageView: UIImageView = {
        let imageView = UIImageView()
        //need image
        imageView.image = UIImage(named: "arrow")
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        imageView.tintColor = UIColor.white
        return imageView
    }()
    
    let newPriceLabel: UILabel = {
        let label = UILabel()
        label.text = "Текущая цена"
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = UIFont(name: "Comfortaa", size: 13)
        label.layer.cornerRadius = 3.45
        label.layer.masksToBounds = true
        label.isHidden = true
        return label
    }()
    
    let newCategoryPriceTextField: UITextField = {
        let tf = UITextField()
        tf.text = ""
        tf.textColor = UIColor.white
        tf.textAlignment = .center
        tf.font = UIFont(name: "Comfortaa", size: 13)
        tf.layer.cornerRadius = 3.45
        tf.layer.masksToBounds = true
        tf.isHidden = true
        tf.tintColor = UIColor.white
        tf.backgroundColor = UIColor(red: 149/255, green: 146/255, blue: 146/255, alpha: 1)
        return tf
    }()

    override func setupViews() {
        super.setupViews()
        
        addSubview(categoryImageView)
        addSubview(categoryNameLabel)
        addSubview(currentPriceLabel)
        addSubview(currentCategoryPriceLabel)
        addSubview(arrowImageView)
        addSubview(newPriceLabel)
        addSubview(newCategoryPriceTextField)
        
        addConstraintsWithFormat(format: "H:|[v0(20)]-[v1]|", views: categoryImageView, categoryNameLabel)
        addConstraintsWithFormat(format: "V:|[v0(20)]-[v1]-[v2(20)]|", views: categoryImageView, currentPriceLabel, currentCategoryPriceLabel)
        addConstraintsWithFormat(format: "H:|[v0(20)]", views: currentPriceLabel)
        addConstraintsWithFormat(format: "H:[v0(20)]|", views: newPriceLabel)
        addConstraintsWithFormat(format: "V:[v0(20)]|", views: arrowImageView)
        addConstraintsWithFormat(format: "H:|[v0(20)]-[v1]-[v2(20)]|", views: currentCategoryPriceLabel, arrowImageView, newCategoryPriceTextField)
        addConstraintsWithFormat(format: "V:|[v0(20)]-[v1]-[v2(20)]|", views: categoryImageView, newPriceLabel, newCategoryPriceTextField)
        
    }
    
    
}
