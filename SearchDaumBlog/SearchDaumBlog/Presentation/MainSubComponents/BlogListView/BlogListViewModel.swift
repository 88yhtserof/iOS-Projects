//
//  BlogListViewModel.swift
//  SearchDaumBlog
//
//  Created by 임윤휘 on 2023/03/31.
//

import RxSwift
import RxCocoa

struct BlogListViewModel {
    //BlogList가 Header로 Filter를 가지고 있으므로 ViewModel 프로퍼티 사용
    let filterViewModel = FilterViewModel()
    
    //MainViewController -> BlogListView
    let blogCellData = PublishSubject<[BlogListCellData]>()
    let cellData: Driver<[BlogListCellData]>
    
    init() {
        self.cellData = blogCellData
            .asDriver(onErrorJustReturn: [])
    }
}
