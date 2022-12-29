//
//  ViewController.swift
//  SearchDaumBlog
//
//  Created by 임윤휘 on 2022/12/26.
//

import RxSwift
import RxCocoa

class MainViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    let searchBar = SearchBar()
    let listView = BlogListUITableView()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        bind()
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
    }
    
    private func attribute() {
        title = "다음 블로그 검색"
        view.backgroundColor = .white
    }
    
    private func layout() {
        [ searchBar, listView ]
            .forEach { view.addSubview($0) }
        
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        listView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

