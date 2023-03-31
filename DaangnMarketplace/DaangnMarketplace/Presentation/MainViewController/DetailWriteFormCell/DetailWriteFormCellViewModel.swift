//
//  DetailWriteFormCellViewModel.swift
//  DaangnMarketplace
//
//  Created by 임윤휘 on 2023/03/31.
//

import RxSwift
import RxCocoa

//ViewModel 먼저 만드는 것을 습관화하자
//전체적으로 View가 어떤 액션을 취할 것인지 먼저 생각하는 것이 좋다
//이벤트 흐름을 어떻게 할 것인지 간결하게 정할 수 있어 좋다
struct DetailWriteFormCellViewModel {
    //View -> ViewModel
    let contentValue = PublishRelay<String?>()
}
