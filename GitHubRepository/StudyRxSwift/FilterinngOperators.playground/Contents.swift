import RxSwift

/*
 필터링 연산자
 next 이벤트를 통해 받아오는 값을 선택적으로 취할 수 있게 하는 연산자
 */

let disposeBag = DisposeBag()

print("------ignoreElements------")
//next 이벤트를 무시한다.

let sleepMode = PublishSubject<String>()

sleepMode
    .ignoreElements()
    .subscribe {
        print($0)
    }
    .disposed(by: disposeBag)

sleepMode.onNext("!")
sleepMode.onCompleted()


print("------elementAt------")
//n번 째 해당하는 인텍스만 방출
let wakeUpRing = PublishSubject<String>()

wakeUpRing
    .element(at: 2) //인덱스 2의 이벤트만 방출
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

wakeUpRing.onNext("!") //index 0
wakeUpRing.onNext("!") //index 1
wakeUpRing.onNext("Wake") //index 2
wakeUpRing.onNext("!") //index 3


print("------filter------")
Observable.of(1, 2, 3, 4, 5, 6, 7, 8) //[1, 2, 3, 4, 5, 6, 7, 8]
    .filter { $0 % 2 == 0 } //짝수만 반환
    .subscribe( onNext: {
        print($0)
    })
    .disposed(by: disposeBag)


print("------Skip------")
//첫 번째 요소부터 n번째 요소까지 무시한다. 매개변수 개수만큼 무시
Observable.of(1, 2, 3, 4, 5, 6)
    .skip(5)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("------SkipWhile------")
//skip 로직을 구성하고 해당 조건이 false가 되면 그때부터 방출
Observable.of(1, 2, 3, 4, 5, 6)
    .skip(while: {//4를 기준으로 4포함 이후 요소 출력
        $0 != 4
    })
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("------SkipUntile------")
//다른 옵져버블에 기반한 필터링
//다른 옵져버블에 next 이벤트가 발생한 후부터 현재 옵져버블 이벤트 방출 시작
let guest = PublishSubject<String>()
let open = PublishSubject<String>()

guest
    .skip(until: open)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

guest.onNext("1")
guest.onNext("2")

open.onNext("개점")
guest.onNext("3")


print("------take------")
//skip과 반대
//설정한 개수만큼 요소 출력
Observable.of(1, 2, 3, 4, 5)
    .take(3)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)


print("------takeWhile------")
//skipWhile과 반대
//조건이 true일 때까지만 방출
Observable.of(1, 2, 3, 4, 5)
    .take(while: {
        $0 != 3
    })
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)


print("------enumerated------")
//인덱스를 같이 표시해준다. (index: 1, element: 2)
//방출된 요소의 인덱스를 참고하고 싶을 때 사용할 수 있다.
Observable.of(1, 2, 3, 4, 5)
    .enumerated()
    .take(while: {
        $0.index < 3
    })
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)


print("------takeUntil------")
//다른 옵져버블에 기반한 필터링
//다른 옵져버블의 next 이벤트가 방출되기 전까지만 현재 옵져버블 이벤트 방출
let registerCourse = PublishSubject<String>()
let closed = PublishSubject<String>()

registerCourse
    .take(until: closed)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

registerCourse.onNext("신청 1")
registerCourse.onNext("신청 2")

closed.onNext("마감!")
registerCourse.onNext("신청 3")


print("------distinctUntilChanged------")
//연달아 같은 값이 반복될 때, 중복된 값을 막아주는 역할을 한다.
Observable.of("저는", "저는", "저는", "앵무새", "입니다.", "입니다.", "저는", "저는", "앵무새","앵무새",  "입니다.")
    .distinctUntilChanged()
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
