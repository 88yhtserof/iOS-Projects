//
//  MainViewModel.swift
//  DaangnMarketplace
//
//  Created by 임윤휘 on 2023/03/31.
//

import Foundation
import RxSwift
import RxCocoa

struct MainViewModel {
    let titleTextFieldCellViewModel = TitleTextFieldCellViewModel()
    let priceTextFieldCellViewModel = PriceTextFieldCellViewModel()
    let detailWriteFormCellViewModel = DetailWriteFormCellViewModel()
    
    //ViewModel -> View
    let cellData: Driver<[String]> //MainView가 가지고 있는 cellData
    let presentAlert: Signal<Alert> //alert를 띄워야 한다는 시그널
    let push: Driver<CategoryViewModel> //카테고리를 누르면 카테고리상세를 보여주는 뷰컨틀로러로 푸시하라는 그런 드라이브
    
    //View -> ViewModel
    let itemSelected = PublishRelay<Int>() // 아이템이 선택되었을 때
    let submitButtonTapped = PublishRelay<Void>() //제출 버튼 선택되었을때
    
    init(model: MainModel = MainModel()) {
        let title = Observable.just("글 제목")
        let categoryViewModel = CategoryViewModel()
        let category = categoryViewModel
            .selectedCategory
            .map { $0.name }
            .startWith("카테고리 선택") //시작 시 해당 값으로 설정
        
        let price = Observable.just("₩ 가격 (선택사항)")
        let detail = Observable.just("내용을 입력하세요")
        
        self.cellData = Observable //데이터 묶어서 넘겨주기
            .combineLatest(
                title,
                category,
                price,
                detail
            ) { [$0, $1, $2, $3] }
            .asDriver(onErrorJustReturn: []) //오류가 나면 빈 배열 전달
        
        let titleMessage = titleTextFieldCellViewModel
            .titleText
            .map { $0?.isEmpty ?? true } //제목란 공백 여부 확인
            .startWith(true) //초깃값 true
            .map{$0 ? ["- 글 제목을 입력해주세요."] : [] } //만약 true라면
        
        let catergoryMessage = categoryViewModel
            .selectedCategory
            .map { _ in false  } //선택된 카테고리가 있다면 아무 말도 보여주지 않을 것이므로 false
            .startWith(true) //초깃값 true - 아무것도 선택되어있지 않아 선택하라는 말을 보여줘야한다.
            .map{$0 ? ["카테고리를 선택해주세요."] : [] }
        
        let detailMessage = detailWriteFormCellViewModel
            .contentValue
            .map { $0?.isEmpty ?? true }
            .startWith(true)
            .map{$0 ? ["- 내용을 입력해주세요."] : [] } //만약 true라면
        
        let errorMessage = Observable //아래 메세지 각각의 가장 최근의 값을 받아 조합
            .combineLatest(
                titleMessage,
                catergoryMessage,
                detailMessage
            ) { $0 + $1 + $2 } //조합하기
        
        self.presentAlert = submitButtonTapped //제출 버튼이 tap되었을 때만
            .withLatestFrom(errorMessage)
            .map (model.setAlert)
            .asSignal(onErrorSignalWith: .empty())
        
        self.push = itemSelected //여러 가지 cell이 선택될 텐데 2번 인덱스 셀이 선택되었을 때만 카데고리상세 push되도록
            .compactMap{ row -> CategoryViewModel? in
                guard case 1 = row else {
                    return nil
                }
                return categoryViewModel
            }
            .asDriver(onErrorDriveWith: .empty())
        
    }
}
