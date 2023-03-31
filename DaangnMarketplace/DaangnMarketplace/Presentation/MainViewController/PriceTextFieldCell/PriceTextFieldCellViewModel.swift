//
//  PriceTextFieldCellViewModel.swift
//  DaangnMarketplace
//
//  Created by 임윤휘 on 2023/03/31.
//

import RxSwift
import RxCocoa

struct PriceTextFieldCellViewModel {
    //ViewModel -> View
    let showFreeShareButton: Signal<Bool>
    let resetPrice: Signal<Void>
    
    //View -> ViewModel
    let priceValue = PublishRelay<String?>() //UI
    let freeShareButtonTapped = PublishRelay<Void>() //무료나눔 버튼이 띄워졌을 때 그 버튼이 눌러졌는가 이벤트 전달
    
    init() {
        self.showFreeShareButton = Observable //언제 무료나눔 버튼을 보여줄 것인가
            .merge(
                priceValue.map { $0 ?? "" == "0" }, //가격이 적혀있지 않거나 0원일 때
                freeShareButtonTapped.map { _ in false } //무료나눔 버튼이 눌려졌으면 숨겨라
            )
            .asSignal(onErrorJustReturn: false) //에러가 나면 그냥 숨기기
        
        self.resetPrice = freeShareButtonTapped //무료나눔 버튼이 눌렸으면
            .asSignal(onErrorSignalWith: .empty()) //가격 초기화하기
    }
}
