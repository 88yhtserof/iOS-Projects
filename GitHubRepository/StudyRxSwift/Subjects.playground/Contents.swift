import RxSwift

let disposeBag = DisposeBag()

print("------PublishSubject------")
//옵져버블이자 옵져버
let publishSubject = PublishSubject<String>()

//옵져버의 특징은 이벤트를 설정할 수 있다는 것이다
//Subject는 옵져버블이자 옵져버이므로 위와 같은 특징을 가지고 있다.
publishSubject.onNext("이벤트 1")

//옵져버블의 특징은 subscribe를 해야만 이벤트가 방출된다는 것이다.
let subscriber1 = publishSubject
    .subscribe(onNext: {
        print("구독자 1: \($0)")
    })

publishSubject.onNext("이벤트 2")
publishSubject.on(.next("이벤트 3")) //위로 동일한 코드

subscriber1.dispose() //dispose는 구독해제를 의미

let subscriber2 = publishSubject
    .subscribe(onNext: {
        print("구독자 2: \($0)")
    })

publishSubject.onNext("이벤트 4")
publishSubject.onCompleted() //subject 종료

publishSubject.onNext("이벤트 5")

subscriber2.dispose() //dispose는 구독해제를 의미

publishSubject
    .subscribe{
        print("구독자 3: \($0)")
    }
    .disposed(by: disposeBag)

publishSubject.onNext("이벤트 6")
/*
 구독자1은 이벤트1 발생 이후에 옵져버블을 구독했고 이벤트 4 전에 구독해제했기 때문에 이벤트 2, 3이 방출
 구독자2는 이벤트3 발생 이후에 옵져버블을 구독했고 이벤트 5 전에 옵져버블이 종료됐기 때문에 4 방출
 구독자3은 옵져버블 종료 이후에 구독 시도를 했기 때문에 구독이 받아들여지지 않는다.
 */


print("------BehaviorSubject------")
enum SubjectError: Error {
    case error1
}

//behaviorSubject는 초기값을 가진다
let behaviorSubject = BehaviorSubject<String>(value: "초기값")

behaviorSubject.onNext("이벤트 1")

behaviorSubject.subscribe{
    print("구독자 1:", $0.element ?? $0)//만약 element가 없다면 어떤 이벤트를 받았는지 표현하라
}
.disposed(by: disposeBag)//지금 당장 dispose 하는게 아니라 일단 dispose 목록에 기록

behaviorSubject.onError(SubjectError.error1)

behaviorSubject.subscribe{
    print("구독자 2:", $0.element ?? $0)//만약 element가 없다면 어떤 이벤트를 받았는지 표현하라
}
.disposed(by: disposeBag)//지금 당장 dispose 하는게 아니라 일단 dispose 목록에 기록

/*
 구독자 1은 behaviorSubject이기 때문에 직전 이벤트인 "이벤트 1"를 받는다. 하지만 "초기값"은 직전이 아니므로 받지 못한다.
 또 구독자 1은 구독 이후 옵져버블에 error 이벤트가 발생했기 때문에 이 이벤트를 받아 방출한다.
 구독지 2는 옵져버에 에러가 발생한 뒤 구독을 했지만, 구독 바로 직전 이벤트가 바로 에러 이벤트가 해당 이벤트를 받고 방출한다.
 */

let value = try? behaviorSubject.value()
print(value)
//만약 앞서 Error가 발생하지 않았다면 가장 최신의 next 이벤트인 "이벤트 1"이 출력됐을 것이다.
//하지만 Error가 발생해 옵져버블이 종료되었기 때문에 nil이 출력된다.


print("------ReplaySubject------")
let replaySubject = ReplaySubject<String>.create(bufferSize: 2)

replaySubject.onNext("이벤트 1")
replaySubject.onNext("이벤트 2")
replaySubject.onNext("이벤트 3")

replaySubject.subscribe{
    print("구독자 1:", $0.element ?? $0)
}
.disposed(by: disposeBag) //지금 당장 dispose 하는게 아니라 일단 dispose 목록에 기록

replaySubject.subscribe{
    print("구독자 2:", $0.element ?? $0)
}
.disposed(by: disposeBag) //지금 당장 dispose 하는게 아니라 일단 dispose 목록에 기록

replaySubject.onNext("이벤트 4")
replaySubject.onError(SubjectError.error1)
replaySubject.dispose() //replaySubject 옵져버블을 구독하고 disposeBag에 등록한 구독자 모두 구독 해제

replaySubject.subscribe{
    print("구독자 3:", $0.element ?? $0)
}
.disposed(by: disposeBag) //지금 당장 dispose 하는게 아니라 일단 dispose 목록에 기록

/*
 버퍼 크기가 2이므로 구독자 1은 버퍼에 저장된 이벤트 2, 3을 받아 방출한다. 그리고 후에 이벤트 4와 에러 이벤트를 받아 방출하고 구독해제된다.
 구독자 2 또한 버퍼 크기가 2이므로 이벤트 2, 3을 받아 방출한다. 그리고 후에 이벤트 4와 에러 이벤트를 받아 방출하고
 구독자 3은 이미 dispose했는데 구독을 하니깐 RxSwift에서 에러를 내어 그것을 방출한다.
 */
