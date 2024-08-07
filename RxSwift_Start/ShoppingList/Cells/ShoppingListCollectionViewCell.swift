//
//  ShoppingListCollectionViewCell.swift
//  RxSwift_Start
//
//  Created by dopamint on 8/7/24.
//

import UIKit

class ShoppingListCollectionViewCell: UICollectionViewCell {
    static let id = "ShoppingListCollectionViewCell"
    
    let label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = UIColor(named: "black")?.cgColor
        clipsToBounds = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
