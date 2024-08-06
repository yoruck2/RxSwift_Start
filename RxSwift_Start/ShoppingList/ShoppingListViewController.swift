import UIKit
import RxSwift
import RxCocoa

final class ShoppingListViewController: RxBaseViewController {
    
    let viewModel = ShoppingListViewModel()
    let rootView = ShoppingListView()

    override func loadView() {
        view = rootView
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        rootView.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rootView.searchBar.placeholder = "쇼핑목록 검색하기"
        self.navigationItem.titleView = rootView.searchBar
    }
    
    override func bind() {
        
        let toggledDoneIndex = PublishRelay<Int>()
        let toggledFavoriteIndex = PublishRelay<Int>()
        
        let input = ShoppingListViewModel.Input(itemSelected: rootView.tableView.rx.modelSelected(ShoppingItem.self),
                                                itemDeleted: rootView.tableView.rx.modelDeleted(ShoppingItem.self),
                                                toggledDoneIndex: toggledDoneIndex,
                                                toggledFavoriteIndex: toggledFavoriteIndex,
                                                searchText: rootView.searchBar.rx.text, addItemText: rootView.shoppingTextField.rx.text,
                                                addButtonTap: rootView.addButton.rx.tap)
        
        let output = viewModel.transform(input: input)
        
        output.shoppingList
            .bind(to: rootView.tableView.rx.items(cellIdentifier: "ShoppingListTableViewCell", cellType: ShoppingListTableViewCell.self)) { row, element, cell in
                cell.configure(with: element)
                
                cell.doneButton.rx.tap
                    .map { row }
                    .bind(to: toggledDoneIndex)
                    .disposed(by: cell.disposeBag)
                
                cell.favoriteButton.rx.tap
                    .map { row }
                    .bind(to: toggledFavoriteIndex)
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
//        private func updateItem(_ updatedItem: ShoppingItem) {
//            var items = viewModel.data
//                if let index = items.firstIndex(where: { $0.id == updatedItem.id }) {
//
//d
//                    }
//                print("sdf")
//                }
//        
        output.itemSelected
            .bind(with: self) { owner, item in
                let nextVC = DetailViewController()
                nextVC.item = item
                nextVC.textField.text = item.name
//                nextVC.itemUpdateHandler = { updatedItem in
//                    owner.updateItem(updatedItem)
//                }
                owner.navigationController?
                    .pushViewController(nextVC, animated: true)
            }
            .disposed(by: disposeBag)
        
        output.addButtonTap
            .map { "" }
            .bind(to: rootView.shoppingTextField.rx.text)
            .disposed(by: disposeBag)
    }
    
    //    private func reloadCell(at index: Int) {
    //        let indexPath = IndexPath(row: index, section: 0)
    //        rootView.tableView.reloadRows(at: [indexPath], with: .automatic)
    //    }
}
