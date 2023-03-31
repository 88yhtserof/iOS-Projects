//
//  FilterViewModel.swift
//  SearchDaumBlog
//
//  Created by 임윤휘 on 2023/03/31.
//

import RxSwift
import RxCocoa

struct FilterViewModel {
    let sortButtonTapped = PublishRelay<Void>()
}
