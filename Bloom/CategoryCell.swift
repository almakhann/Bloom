//
//  CategoryCell.swift
//  Bloom
//
//  Created by Vadim on 12.06.17.
//  Copyright © 2017 asamasa. All rights reserved.
//

import UIKit

class BaseCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class CategoryCell: BaseCell{
    
    var firstCategoryLabel: UILabel = {
        let label = UILabel()
        label.text = "Уход за телом"
        label.textColor = UIColor.white
        label.font = UIFont(name: "Comfortaa", size: 18)
        label.numberOfLines = 2
        return label
    }()
    
    var firstCategoryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bodyCare")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(firstCategoryImageView)
        addSubview(firstCategoryLabel)
        
        addConstraintsWithFormat(format: "H:|-10-[v0(32)]-10-[v1]|", views: firstCategoryImageView, firstCategoryLabel)
        addConstraintsWithFormat(format: "V:[v0(32)]", views: firstCategoryImageView)
        
        
        addConstraintsWithFormat(format: "V:|[v0]|", views: firstCategoryLabel)
        
        addConstraint(NSLayoutConstraint(item: firstCategoryImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
}


extension UIView {
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}
