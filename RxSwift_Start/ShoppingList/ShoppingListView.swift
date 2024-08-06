//
//  ShoppingListView.swift
//  RxSwift_Start
//
//  Created by dopamint on 8/4/24.
//

import UIKit
import SnapKit
import Then

final class ShoppingListView: UIView {
    
    let searchBar = UISearchBar()
    
    let shoppingTextField = UITextField().then {
        $0.placeholder = "구매할 상품을 작성해주세요!"
        $0.backgroundColor = #colorLiteral(red: 0.8980386853, green: 0.898039639, blue: 0.9195435643, alpha: 1)
        $0.layer.cornerRadius = 15
        $0.clipsToBounds = true
        
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0,
                                               width: 10, height: $0.frame.height))
        let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0,
                                               width: 65, height: $0.frame.height))
        $0.leftView = leftPaddingView
        $0.leftViewMode = UITextField.ViewMode.always
        $0.rightView = rightPaddingView
        $0.rightViewMode = UITextField.ViewMode.always
    }
    let addButton = UIButton().then {
        $0.layer.cornerRadius = 18
        $0.clipsToBounds = true
        $0.setTitle("추가", for: .normal)
        $0.backgroundColor = #colorLiteral(red: 0.5960784314, green: 0.5960784314, blue: 0.6156862745, alpha: 1)
        $0.tintColor = .black
    }
    let tableView = UITableView().then {
        $0.register(ShoppingListTableViewCell.self, forCellReuseIdentifier: "ShoppingListTableViewCell")
        $0.separatorStyle = .none
        $0.rowHeight = 60
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
    }

    func configureHierarchy() {
        addSubview(shoppingTextField)
        addSubview(addButton)
        addSubview(tableView)
    }
    func configureLayout() {
        shoppingTextField.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(10)
            make.height.equalTo(60)
        }
        addButton.snp.makeConstraints { make in
            make.centerY.equalTo(shoppingTextField)
            make.trailing.equalTo(shoppingTextField).inset(10)
            make.height.width.equalTo(50)
        }
        tableView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(10)
            make.bottom.equalTo(safeAreaLayoutGuide)
            make.top.equalTo(shoppingTextField.snp.bottom).offset(10)
        }
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
