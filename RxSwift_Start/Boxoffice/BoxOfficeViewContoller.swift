//
//  BoxOfficeViewContoller.swift
//  SeSACRxThreads
//
//  Created by dopamint on 8/7/24.
//

import UIKit
import RxSwift
import SnapKit

class BoxOfficeViewContoller: RxBaseViewController {

    let viewModel = BoxOfficeViewModel()
    
    let tableView = UITableView()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    let searchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        bind()
    }
    
    override func bind() {
        let recentText = PublishSubject<String>()

        let input = BoxOfficeViewModel.Input(recentText: recentText,
                                             searchButtonTap: searchBar.rx.searchButtonClicked,
                                             searchText: searchBar.rx.text.orEmpty)
        let output = viewModel.transform(input: input)
        
        output.movieList
            .bind(to: tableView.rx.items(cellIdentifier: MovieTableViewCell.id,
                                         cellType: MovieTableViewCell.self)) {
                (row, element, cell) in
                cell.appNameLabel.text = element.movieNm
            }.disposed(by: disposeBag)
        
        output.recentList
            .bind(to: collectionView.rx.items(cellIdentifier: MovieCollectionViewCell.id, cellType: MovieCollectionViewCell.self))
        { (row, element, cell) in
            cell.label.text = element
        }.disposed(by: disposeBag)
        
        
        Observable.zip(
            tableView.rx.modelSelected(String.self),
            tableView.rx.itemSelected
        )
//        .debug("버그찾자") // MARK: 옵저버블 스트링 디버깅 (print 대체)
        .map { "검색어는 \($0.0)" }
        .subscribe(with: self) { owner, value in
            recentText.onNext(value)
        }.disposed(by: disposeBag)
        
        
//        tableView.rx.modelSelected(String.self)
//            .subscribe(with: self) { owner, value in
//                print("item", value)
//            }.disposed(by: disposeBag)        
//        
//        tableView.rx.itemSelected
//            .subscribe(with: self) { owner, value in
//                print("item", value)
//            }.disposed(by: disposeBag)
    }
    
    override func configureView() {
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.id)
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(collectionView)
        view.addSubview(searchBar)
        
        navigationItem.titleView = searchBar
        
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.id)
        collectionView.backgroundColor = .lightGray
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(50)
        }
        tableView.rowHeight = 100
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    static func layout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 120, height: 40)
        layout.scrollDirection = .horizontal
        return layout
    }
}

