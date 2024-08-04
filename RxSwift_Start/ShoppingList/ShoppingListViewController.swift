//
//  ShoppingListViewController.swift
//  RxSwift_Start
//
//  Created by dopamint on 8/2/24.
//

import UIKit
import RxSwift
import RxCocoa

class ShoppingListViewController: RxBaseViewController {
    
    let inputText = BehaviorRelay(value: "")
    let rootView = ShoppingListView()
    override func loadView() {
        view = rootView
    }
    
    private let list = BehaviorRelay<[ShoppingItem]>(value: [
        ShoppingItem(name: "asdf", isDone: true, isFavorite: false),
        ShoppingItem(name: "af", isDone: false, isFavorite: true),
        ShoppingItem(name: "과제하기", isDone: false, isFavorite: false)
    ])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        configueCell()
        cellTapped()
        addList()
        deleteList()
        
        rootView.shoppingTextField.rx.text
            .orEmpty
            .bind(to: inputText)
            .disposed(by: disposeBag)
        
    }
    
    private func toggleDone(at index: Int) {
        var items = list.value
        items[index].isDone.toggle()
        list.accept(items)
        reloadCell(at: index)
    }
    
    private func toggleFavorite(at index: Int) {
        var items = list.value
        items[index].isFavorite.toggle()
        list.accept(items)
        reloadCell(at: index)
    }
    
    private func reloadCell(at index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        rootView.tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

extension ShoppingListViewController {
    
    func registerCell() {
        rootView.tableView.register(ShoppingListTableViewCell.self, forCellReuseIdentifier: "ShoppingListTableViewCell")
    }
    
    func configueCell() {
        list
            .bind(to: rootView.tableView.rx.items(cellIdentifier: "ShoppingListTableViewCell", cellType: ShoppingListTableViewCell.self)) { [weak self] (row, element, cell) in
                cell.configure(with: element)
                
                cell.doneButton.rx.tap
                    .subscribe(onNext: { [weak self] in
                        self?.toggleDone(at: row)
                    })
                    .disposed(by: cell.disposeBag)
                
                cell.favoriteButton.rx.tap
                    .subscribe(onNext: { [weak self] in
                        self?.toggleFavorite(at: row)
                    })
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
    }
    
    func cellTapped() {
        rootView.tableView.rx.itemSelected.bind(with: self) { owner, _ in
            owner.navigationController?
                .pushViewController(DetailViewController(), animated: true)
        }
        .disposed(by: disposeBag)
    }
    
    func addList() {
        rootView.addButton.rx.tap
            .bind(with: self) { owner, value in
                let itemName = owner.inputText.value
                var items = self.list.value
                if itemName.components(separatedBy: " ").joined() == "" {
                    return
                }
                items.insert(ShoppingItem(name: itemName), at: 0)
                self.list.accept(items)
                self.reloadCell(at: 0)
                owner.rootView.shoppingTextField.text?.removeAll()
            }
            .disposed(by: disposeBag)
    }
    func deleteList() {
        
        rootView.tableView.rx.itemDeleted
            .bind(with: self) { owner, value in
                
            }
            .disposed(by: disposeBag)
    }
}

//
//        rootView.tableView.rx
//            .itemAccessoryButtonTapped
//            .subscribe(onNext: { indexPath in
//                print("Tapped Detail @ \(indexPath.section),\(indexPath.row)")
//            })
//            .disposed(by: disposeBag)
