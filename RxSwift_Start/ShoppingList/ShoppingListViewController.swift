import UIKit
import RxSwift
import RxCocoa

class ShoppingListViewController: RxBaseViewController {
    
    let searchBar = UISearchBar()
    let inputText = BehaviorRelay(value: "")
    let rootView = ShoppingListView()
    override func loadView() {
        view = rootView
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        rootView.tableView.reloadData()
    }
    var data = [
        ShoppingItem(name: "asdf", isDone: true, isFavorite: false),
        ShoppingItem(name: "af", isDone: false, isFavorite: true),
        ShoppingItem(name: "과제하기", isDone: false, isFavorite: false)
    ]
    
    lazy var list = BehaviorRelay<[ShoppingItem]>(value: data)
    lazy var filteredList = BehaviorRelay<[ShoppingItem]>(value: data)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.placeholder = "쇼핑목록 검색하기"
        self.navigationItem.titleView = searchBar
        
        registerCell()
        configureCell()
        cellTapped()
        addList()
        deleteList()
        search()
        
        rootView.shoppingTextField.rx.text
            .orEmpty
            .bind(to: inputText)
            .disposed(by: disposeBag)
    }
    
    private func toggleDone(at index: Int) {
        var items = list.value
        let filteredItems = filteredList.value
        let itemToToggle = filteredItems[index]
        
        if let originalIndex = items.firstIndex(where: { $0.id == itemToToggle.id }) {
            items[originalIndex].isDone.toggle()
            list.accept(items)
            updateFilteredList()
        }
    }
    
    private func toggleFavorite(at index: Int) {
        var items = list.value
        let filteredItems = filteredList.value
        let itemToToggle = filteredItems[index]
        
        if let originalIndex = items.firstIndex(where: { $0.id == itemToToggle.id }) {
            items[originalIndex].isFavorite.toggle()
            list.accept(items)
            updateFilteredList()
        }
    }
    
    private func updateFilteredList() {
        let searchText = searchBar.text?.lowercased() ?? ""
        let filtered = searchText.isEmpty ? list.value : list.value.filter { $0.name.lowercased().contains(searchText) }
        filteredList.accept(filtered)
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
    
    func configureCell() {
        filteredList
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
        rootView.tableView.rx.itemSelected
            .bind(with: self) { owner, indexPath in
                let nextVC = DetailViewController()
                let filteredItems = owner.filteredList.value
                let selectedItem = filteredItems[indexPath.row]
                nextVC.item = selectedItem
                nextVC.textField.text = selectedItem.name
                nextVC.itemUpdateHandler = { updatedItem in
                    owner.updateItem(updatedItem)
                }
                owner.navigationController?
                    .pushViewController(nextVC, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func updateItem(_ updatedItem: ShoppingItem) {
        var items = list.value
        if let index = items.firstIndex(where: { $0.id == updatedItem.id }) {
            print(items[index].name)
            print(updatedItem.name)
            items[index].name = updatedItem.name
                list.accept(items)
                updateFilteredList()
            }
        print("sdf")
        }
    
    func addList() {
        rootView.addButton.rx.tap
            .bind(with: self) { owner, value in
                let itemName = owner.inputText.value
                var items = owner.list.value
                if itemName.components(separatedBy: " ").joined() == "" {
                    return
                }
                items.insert(ShoppingItem(name: itemName), at: 0)
                owner.list.accept(items)
                owner.updateFilteredList()
                owner.rootView.shoppingTextField.text?.removeAll()
            }
            .disposed(by: disposeBag)
    }
    
    func deleteList() {
        rootView.tableView.rx.itemDeleted
            .bind(with: self) { owner, indexPath in
                var items = owner.list.value
                let filteredItems = owner.filteredList.value
                let itemToDelete = filteredItems[indexPath.row]
                
                if let originalIndex = items.firstIndex(where: { $0.id == itemToDelete.id }) {
                    items.remove(at: originalIndex)
                    owner.list.accept(items)
                    owner.updateFilteredList()
                }
            }
            .disposed(by: disposeBag)
    }
    
    func search() {
        searchBar.rx.text.orEmpty
            .map { $0.lowercased() }
            .debounce(.milliseconds(100), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind(with: self) { owner, value in
                owner.updateFilteredList()
            }
            .disposed(by: disposeBag)
    }
}
