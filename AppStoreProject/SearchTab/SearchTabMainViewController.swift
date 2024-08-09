//
//  SearchTabMainViewController.swift
//  AppStoreProject
//
//  Created by Joy Kim on 8/8/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Kingfisher

final class SearchTabMainViewController: UIViewController {
    
    let searchBar = UISearchBar()
    let tableView = UITableView()
    
    let viewModel = SearchTabMainViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configHierarchy()
        configLayout()
        configUI()
    }
    
}

extension SearchTabMainViewController {
    
    func configHierarchy() {
        view.addSubview(searchBar)
        view.addSubview(tableView)
        
        
    }
    
    func configLayout() {
        searchBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(10)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
        
    }
    
    func configUI() {
        searchBar.placeholder = "게임, 앱, 스토리 등"
        setupTableView()
        bind()
    }
    
    func setupTableView() {
        tableView.backgroundColor = .red
        tableView.register(SearchTabMainTableViewCell.self, forCellReuseIdentifier: SearchTabMainTableViewCell.identifier)
        tableView.rowHeight = 330
    }
    
    func bind() {
        let searchQuery = BehaviorSubject<String>(value: "")
        
        searchQuery
            .subscribe(with: self) { owner, value in
                if value.isEmpty {
                    owner.navigationController?.navigationBar.prefersLargeTitles = true
                    owner.navigationItem.title = "검색"
                    owner.tableView.isHidden = true
                } else {
                    owner.navigationItem.title = ""
                    owner.navigationController?.navigationBar.prefersLargeTitles = false
                    owner.navigationItem.titleView = owner.searchBar
                    owner.tableView.isHidden = false
                    owner.tableView.snp.makeConstraints { make in
                        make.edges.equalTo(owner.view.safeAreaLayoutGuide)
                    }
                }
            }
            .disposed(by: disposeBag)
        
        searchBar.rx.searchButtonClicked
            .withLatestFrom(searchBar.rx.text.orEmpty)
            .subscribe(with: self) { owner, value in
                searchQuery.onNext(value)
            }
            .disposed(by: disposeBag)
        
        searchBar.rx.cancelButtonClicked
            .subscribe(with: self) { owner, _ in
                searchQuery.onNext("")
                owner.searchBar.text = ""
                owner.searchBar.showsCancelButton = false
            }
            .disposed(by: disposeBag)
        
        searchBar.rx.text.orEmpty
            .subscribe (with: self) { owner, text in
                   if text.isEmpty {
                       searchQuery.onNext("")
                       owner.searchBar.showsCancelButton = false
                   } else {
                       owner.searchBar.showsCancelButton = true
                   }
               }
               .disposed(by: disposeBag)
        
        let input = SearchTabMainViewModel.Input(searchBtnTap: searchBar.rx.searchButtonClicked, searchQuery: searchQuery)
        
        let output = viewModel.transform(input: input)
        
        output.appList.bind(to: tableView.rx.items(cellIdentifier: SearchTabMainTableViewCell.identifier, cellType: SearchTabMainTableViewCell.self)) {
            (row, element, cell) in
            cell.configUI(data: element)
        }
        .disposed(by: disposeBag)
    }
}
