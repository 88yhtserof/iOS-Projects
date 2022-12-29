//
//  SearchBar.swift
//  SearchDaumBlog
//
//  Created by 임윤휘 on 2022/12/29.
//

import RxSwift
import RxCocoa
import SnapKit

class SearchBar: UISearchBar {
    let disposeBag = DisposeBag()
    
    let searchButton = UIButton()
    
    //SearchBar 버튼 탭 이벤트
    let searchButtonTapped = PublishRelay<Void>() //PublishSubject를 맵핑하고 있지만, 에러를 받지 않거 onNext이벤트만 받는다.
    //UI 옵져버블이므로 에러가 발생하지 않는 PublishRelay 사용

    //SearchBar 외부로 내보낼 이벤트
    var shouldLoadResult = Observable<String>.of("") //처음에는 아무런 검색값이 없으니깐 공백
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        bind()
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        //searchbar search button tapped
        //button tapped -> 키보드에 있는 검색 버튼
        //위 두 옵져버블은 순서 상관없이 일단 발생되면 모두 tapped 이벤트로, 검색 동작이 실행되어야한다.
        //따라서 CombiningOperrator인 merge 연산자를 사용해 이 둘을 합치자.
        
        //검색하기
        Observable
            .merge(
                self.rx.searchButtonClicked.asObservable(), //둘 중 하나라도 이벤트가 발생하면 해당 이벤트가 searchButtonTapped 옵져버블로 바인딩이 돼서 해당 subject(옵져버블)가 이벤트를 가지게 된다.
                searchButton.rx.tap.asObservable()
            )
            .bind(to: searchButtonTapped) //바인더는 옵져버
            .disposed(by: disposeBag)
        
        searchButtonTapped
            .asSignal() //
            .emit(to: self.rx.endEditing) //키보드 내려가게 하기
            .disposed(by: disposeBag)
        
        //검색어 작성 시 결과 내보내기
        self.shouldLoadResult = searchButtonTapped
            .withLatestFrom(self.rx.text) {$1 ?? ""} //검색바의 텍스트 전달
            .filter { !$0.isEmpty } //빈 값 거르기
            .distinctUntilChanged() //중복 거르기
    }
    
    private func attribute() {
        searchButton.setTitle("검색", for: .normal)
        searchButton.setTitleColor(.systemBlue, for: .normal)
    }
    
    private func layout() {
        addSubview(searchButton)
        
        searchTextField.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(12)
            $0.trailing.equalTo(searchButton.snp.leading).offset(-12)
            $0.centerY.equalToSuperview()
        }
        
        searchButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(12)
        }
    }
}

extension Reactive  where Base: SearchBar {//바인더 커스텀
    var endEditing: Binder<Void> {
        return Binder(base) { base, _ in //base는 SearchBar를 의미한다.
            base.endEditing(true)
        }
    }
}
