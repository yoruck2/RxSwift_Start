//
//  ShoppingListViewModel.swift
//  RxSwift_Start
//
//  Created by dopamint on 8/6/24.
//

import Foundation
import RxSwift
import RxCocoa

class ShoppingListViewModel {
    
    var data = [
        ShoppingItem(name: "asdf", isDone: true, isFavorite: false),
        ShoppingItem(name: "af", isDone: false, isFavorite: true),
        ShoppingItem(name: "과제하기", isDone: false, isFavorite: false)
    ]
    
    lazy var shoppingList = BehaviorRelay<[ShoppingItem]>(value: data)
//    lazy var filteredList = BehaviorRelay<[ShoppingItem]>(value: initialData)
    
    let disposeBag = DisposeBag()
    
    struct Input {
        
        let itemSelected: ControlEvent<ShoppingItem>
        let itemDeleted: ControlEvent<ShoppingItem>
        
        let toggledDoneIndex: PublishRelay<Int>
        let toggledFavoriteIndex: PublishRelay<Int>
        
        let searchText: ControlProperty<String?>
        let addItemText: ControlProperty<String?>
        let addButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let shoppingList: BehaviorRelay<[ShoppingItem]>
        let itemSelected: ControlEvent<ShoppingItem>
        let addButtonTap: ControlEvent<Void>
    }
    
    func transform(input: Input) -> Output {
       
        
        searchItem(input.searchText)
        addItem(input.addItemText, on: input.addButtonTap)
        deleteItem(input.itemDeleted)
        
        toggleDone(at: input.toggledDoneIndex)
        toggleFavorite(at: input.toggledFavoriteIndex)
        
        return Output(shoppingList: shoppingList,
                      itemSelected: input.itemSelected,
                      addButtonTap: input.addButtonTap)
    }
    private func searchItem(_ text: ControlProperty<String?>) {
        text.orEmpty
            .map { $0.lowercased() }
            .debounce(.milliseconds(100), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind(with: self) { owner, text in
//                var data = owner.data
//                let list = owner.shoppingList.value
                let filteredList = text.isEmpty ? owner.data : owner.data.filter { $0.name.lowercased().contains(text) }
                owner.shoppingList.accept(filteredList)
            }
            .disposed(by: disposeBag)
    }

    
    // withLatestFrom 는 텍스트 필드와 버튼 관계를 생각 하자 (버튼이 눌렸을 때만 방출)
    private func addItem(_ text: ControlProperty<String?>, on tap: ControlEvent<Void>) {
        tap.withLatestFrom(text.orEmpty)
            .filter { $0.components(separatedBy: " ").joined() != "" }
            .bind(with: self) { owner, text in
                
                owner.data.insert(ShoppingItem(name: text), at: 0)
                owner.shoppingList.accept(owner.data)
//                owner.filteredList.accept(owner.list.value)
            }
            .disposed(by: disposeBag)
    }
    
    private func deleteItem(_ item: ControlEvent<ShoppingItem>) {
        item
            .bind(with: self) { owner, item in
                var items = owner.shoppingList.value
//                let filteredItems = owner.shoppingList.value
//
                if let originalIndex = items.firstIndex(where: { $0.id == item.id }) {
                    items.remove(at: originalIndex)
                    owner.shoppingList.accept(items)
//                    owner.filteredList.accept(owner.list.value)
                }
            }
            .disposed(by: disposeBag)
    }
}

extension ShoppingListViewModel {
//    
//    private func updateFilteredList() {
//        let filtered = text.isEmpty ? list.value : list.value.filter { $0.name.lowercased().contains(text) }
//        owner.filteredList.accept(filtered)
//    }
    
    private func toggleDone(at index: PublishRelay<Int>) {
        index.bind(with: self) { owner, index in
            var list = owner.shoppingList.value
            let item = list[index]
            
            
            if let originalIndex = owner.data.firstIndex(where: { $0.id == item.id }) {
                owner.data[originalIndex].isDone.toggle()
                list[originalIndex].isDone.toggle()
                owner.shoppingList.accept(list)
                //                owner.filteredList.accept(owner.list.value)
            }
        }
        .disposed(by: disposeBag)
    }
    
    private func toggleFavorite(at index: PublishRelay<Int>) {
        index.bind(with: self) { owner, index in
            var list = owner.shoppingList.value
            let item = list[index]
            
            
            if let originalIndex = owner.data.firstIndex(where: { $0.id == item.id }) {
                owner.data[originalIndex].isFavorite.toggle()
                list[originalIndex].isFavorite.toggle()
                owner.shoppingList.accept(list)
                //                owner.filteredList.accept(owner.list.value)
            }
        }
        .disposed(by: disposeBag)
        
    }
}
