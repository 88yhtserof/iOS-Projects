//
//  MainViewModel.swift
//  SearchDaumBlog
//
//  Created by 임윤휘 on 2023/03/31.
//

import RxSwift
import RxCocoa

//MainView가 listView와 SearchBar를 가지고 있는 것처럼
//MainViewModel도 똑같이 listViewModel과 SearchBarViewModel를 소유
//순수한 비지니스 로직은 모델로 구분할 수 있으므로 복잡한 MainViewModel를 모델로 구분할 수 있다.
//큰 흐름은 파악할 수 있되 구체적인 비지니스 로직은 모델을 통해 알 수 있도록 하여 가독성과 직관성을 높힌다
struct MainViewModel {
    let disposeBag = DisposeBag()
    
    let blogListViewModel = BlogListViewModel()
    let searchBarViewModel = SearchBarViewModel()
    
    //이벤트 스트림
    let alertActionTapped = PublishRelay<MainViewController.AlertAction>()
    let shouldPresentAlert: Signal<MainViewController.Alert>
    
    init(model: MainModel = MainModel()) {
        //네트워크 로직은 View가 알 필요없다.
        //네트워크 연결하기
        let blogResult = searchBarViewModel.shouldLoadResult
            .flatMapLatest(model.searchBlog)
            .share() //스트림을 여러 개 만드는 것이 아니라 공유할 것이기 때문에 share 연산자 사용
        
        //Result 타입은 성공과 실패 두 가지로 나뉜다. 따라서 map 연산자를 사용해 성공만 남도록 연산
        let blogValue = blogResult
            .compactMap(model.getBlogValue)
        
        //에러 받기
        let blogError = blogResult
            .compactMap(model.getBlogError)
        
        //네트워크를 통해 가져온 값을 cellData로 변환
        let blogCellData = blogValue
            .map(model.getBlogListCellData)
        
        //FilterView의 AlertSheet에서 선택된 타입
        let sortedType = alertActionTapped
            .filter {//제목순, 날짜순만 남기고 확인 취소 이벤트 버리기
                switch $0 {
                case .title, .dateTime:
                    return true
                default:
                    return false
                }
            }
            .startWith(.title) //기본 설정으로 제목 순 설정
        
        //데이터들은 타입에 맞게 정렬하여 내보내기
        Observable
            .combineLatest( //가장 최근에 선택된 타입으로 정렬
                sortedType,
                blogCellData,
                resultSelector: (model.sort) //두 가지 소스를 받아 다음과 같은 형태로 정렬해라
            )
            .bind(to: blogListViewModel.blogCellData)
            .disposed(by: disposeBag)
        
        //에러 발생 시 사용자에게 알려주기
        let alertForErrorMessage = blogError
            .map { message -> MainViewController.Alert in
                return (
                    title: "!",
                    message: "예상치 못한 오류가 발생했습니다. \n \(message)",
                    actions: [.confirm],
                    style: .alert
                )
            }
        
        //Alert가 present되는 동작은 동일하고 어떤 Alert인지만 다르다
        //그러면 merge 연산자를 사용해 요소 중 어떤 것이든 이벤트가 발생하면 present되게 묶어주자
        
        //필터 버튼이 눌리면 alert가 present되도록 만들자
        let alertSheetForSorting = blogListViewModel.filterViewModel.sortButtonTapped
            .map { _ -> MainViewController.Alert in //처음에는 void지만 우리가 만든 Alert로 변환
                return (title: nil, message: nil, actions: [.title, .dateTime, .cancel], style: .actionSheet)
            }
        
        
        self.shouldPresentAlert = Observable
            .merge(
                alertForErrorMessage,
                alertSheetForSorting
            )
            .asSignal(onErrorSignalWith: .empty())
    }
}
