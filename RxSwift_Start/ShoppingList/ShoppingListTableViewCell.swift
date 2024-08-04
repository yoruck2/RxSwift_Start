//
//  ShoppingListTableViewCell.swift
//  RxSwift_Start
//
//  Created by dopamint on 8/4/24.
//

import UIKit
import SnapKit
import RxSwift

class ShoppingListTableViewCell: UITableViewCell {
    
    
    var disposeBag = DisposeBag()
    
    var shoppingLabel = UILabel()
    let doneButton = UIButton().then {
        $0.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
        $0.setImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)
    }
    let favoriteButton = UIButton().then {
        $0.setImage(UIImage(systemName: "star"), for: .normal)
        $0.setImage(UIImage(systemName: "star.fill"), for: .selected)
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureHierarchy()
        configureLayout()
        configureView()
    }
    func configure(with item: ShoppingItem) {
        shoppingLabel.text = item.name
        doneButton.isSelected = item.isDone
        favoriteButton.isSelected = item.isFavorite
    }
    
    func configureHierarchy() {
        contentView.addSubview(doneButton)
        contentView.addSubview(shoppingLabel)
        contentView.addSubview(favoriteButton)
    }
    func configureLayout() {
        doneButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(15)
            make.width.height.equalTo(40)
        }
        shoppingLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(doneButton.snp.trailing).offset(15)
        }
        favoriteButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(15)
            make.width.height.equalTo(40)
        }
    }
    
    
    func configureView() {
        selectionStyle = .none
        contentView.backgroundColor = #colorLiteral(red: 0.8980386853, green: 0.898039639, blue: 0.9195435643, alpha: 1)
        contentView.layer.cornerRadius = 15
        contentView.clipsToBounds = true
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
            // Cell 간격 조정
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6))
      }
}

