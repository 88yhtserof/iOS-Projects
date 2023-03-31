//
//  SearchBarViewModel.swift
//  SearchDaumBlog
//
//  Created by 임윤휘 on 2023/03/31.
//

import RxSwift
import RxCocoa

//ViewModel은 View가 관여하지 않아도 되는 로직들을 다룬다.
//ViewModel은 View에 속하기 때문에 View에 대해 몰라도 된다.
struct SearchBarViewModel {
    let queryText = PublishRelay<String?>()
    let searchButtonTapped = PublishRelay<Void>()
    let shouldLoadResult: Observable<String>
    
    init() {
        //검색어 작성 시 결과 내보내기
        self.shouldLoadResult = searchButtonTapped
            .withLatestFrom(queryText) {$1 ?? ""} //검색바의 텍스트 전달
            .filter { !$0.isEmpty } //빈 값 거르기
            .distinctUntilChanged() //중복 거르기
    }
}
