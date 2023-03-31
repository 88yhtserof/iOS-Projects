//
//  CategoryViewModel.swift
//  DaangnMarketplace
//
//  Created by 임윤휘 on 2023/03/31.
//

import RxSwift
import RxCocoa

struct CategoryViewModel {
    let disposeBag = DisposeBag()
    
    //ViewModel -> View
    let cellData: Driver<[Category]>
    let pop: Signal<Void>
    
    //View -> ViewModel
    let itemSelected = PublishRelay<Int>()
    
    //ViewModel -> ParentsViewModel
    let selectedCategory = PublishSubject<Category>() //이 프로퍼티를 통해 최종적으로 선택한 최신의 카테고리가 무엇인지 알 수 있다.
    
    init() {
        let categories = [
            Category(id: 1, name: "디지털/가전"),
            Category(id: 2, name: "게임"),
            Category(id: 3, name: "스포츠/레저"),
            Category(id: 4, name: "유아/아동용품"),
            Category(id: 5, name: "여성패션/잡화")
        ]
        
        self.cellData = Driver.just(categories)
        
        self.itemSelected //맵핑을 하여전달된 row(index)에 해당하는 카테고리가 무엇인지 변화
            .map { categories[$0] }
            .bind(to: selectedCategory) //그리고 bind해서 내보내야하는 selectedCategory에 묶어주자
            .disposed(by: disposeBag)
        
        self.pop = itemSelected //아이템 선택 시 화면 pop
            .map { _ in Void() }
            .asSignal(onErrorSignalWith: .empty())
    }
}
