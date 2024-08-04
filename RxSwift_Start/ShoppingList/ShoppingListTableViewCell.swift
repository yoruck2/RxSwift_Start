//
//  ShoppingListCollectionViewCell.swift
//  RxSwift_Start
//
//  Created by dopamint on 8/4/24.
//

import UIKit

class ShoppingListTableViewCell: UITableViewCell {
    
    let doneButton = UIButton()
    var todoLabel = UILabel()
    let favoriteButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    func configureHierarchy() {
        
    }
    func configureLayout() {
        
    }
    func configureView() {}
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
