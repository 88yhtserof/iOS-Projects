import RxSwift

print("------just------")
Observable<Int>.just(1)
//1이라는 하나의 엘레멘트만 방출하는 단순한 옵져버블 시퀀스를 생성하는 오퍼레이터 just

print("------of1------")
Observable<Int>.of(1, 2, 3, 4, 5)
//다양한 형태의 하나 이상의 이벤트들을 넣을 수 있는 오페레이터
//엘레멘트를 순서대로 방출한다.

print("------of2------")
Observable.of( [1, 2, 3, 4, 5] )
//옵져버블은 타입 추론을 통해서 이 옵져버블 시퀀스를 생성하는데,  따라서 어떤 array를 of 연산자 안에 넣으면 이렇게 하나의 어레이를 방출하는 옵져버블이 생성된다. 이렇게 하면 사실살 just 연산자를 사용한 것과 동일하다.


print("------from------")
Observable.from([1, 2, 3, 4, 5])
//from 오퍼레이터는 array만 받는다. array를 넣게 되면 순서에 맞게 방출한다.

//옵져버블은 실제로는 시퀀스 정의일 뿐이다. 즉, 옵져버블은 subscribe되기 전에는 아무런 이벤트도 내보내지 않는다. 그저 정의일 뿐이다.

print("------subscribe1------")
Observable<Int>.of(1, 2, 3)
    .subscribe( onNext: {
        print($0)
    })


print("------subscribe2------")
Observable<Int>.of(1, 2, 3)
    .subscribe {
        if let element = $0.element {
            print(element)
        }
    }


print("------subscribe3------")
Observable.of( 1, 2, 3 )
    .subscribe( onNext: {
        print($0)
    })

print("------empty------")
Observable.empty()
    .subscribe{
        print($0)
    }

//요소를 하나도 가지지않는 옵져버블은 만들 때 사용하는 오퍼레이터 empty
Observable<Void>.empty()
    .subscribe{
        print($0)
    }

//empty 오퍼레이터 사용 시 타입을 Void로 명시해주면 completed라고 확인해준다.


//위는 아래와 동일한 코드이다.
Observable<Void>.empty()
    .subscribe(onNext: {
        
    },
               onCompleted: {
        print("Completed")
    })

//empty 오퍼레이터의 목적: 즉시 종료할 수 있는 옵져버블을 리턴하고 싶을 때. 아니면 의도적으로 0개의 값을 가지는 옵져버블을 리턴하고 싶을 때 사용

print("------never------")
Observable<Void>.never()
    .subscribe(
        onNext: {
            print($0)
        },
        onCompleted: {
            print("Completed")
        })

//이렇게 하면 completed도 출력되지 않는다.

//naver가 작동되는지 확인하기

Observable<Void>.never()
    .debug("never")
    .subscribe(
        onNext: {
            print($0)
        },
        onCompleted: {
            print("Completed")
        })

//시간 never -> subscribed

//Range 어떤 범위에 있는 어레이를 스타트부터 카운트까지의 값을 갖도록 만들어 주는 것


print("------range------")
Observable.range(start: 1, count: 9)
    .subscribe(onNext: {
        print("2*\($0)=\(2*$0)")
    })

//2*1 =2


print("------dispose------")
//구독(subscribe)을 해지하는 방법 dispose

Observable.of(1, 2, 3)
    .subscribe (onNext: {
        print($0)
    })
    .dispose() //구독취소 -> 이 이후로 이벤트 방출이 되지 않는다.


print("------disposeBag------")
//이렇게 보아서는 .dispose 오퍼레이트가 없는 것과 다를 바 없다. 하지만 시퀀스가 무한하다면 dispose 오퍼레이터를 호출해야지만 completed 이벤트가 발생한다.

//Disposed 시키는 또다른 방법
let disposeBag = DisposeBag()

Observable.of(1, 2, 3)
    .subscribe {
        print($0)
    }
    .disposed(by: disposeBag) //1

//각각의 구독에 대해서 일일이 dispose로 관리하는 것은 효율적이지 않다. 따라서 RxSwift에서 제공하는 DisposeBag을 이용할 수 있는데, 이것에는 disposables를 가지고 있다. 그래서 disposeBag이 할당해제 하하려 때마다 dispose 호출하게 된다.

//1코드는 방출된 리턴값을 disposeBag에 추가하는 코드이다. 옵져버블에 대해 구독을 하고 있을 때, 이것을 즉시 disposeBag에 추가하는 것이다. 이렇게 하면 disposeBag은 이것을 잘 가지고 있다가  자신이 할당해제할 때 모든 구족에 대해서 dispose날리는 것이다.
//구독할 때마다 disposeBag에 넣는 것이 귀찮아 보이기도 하지만, 만약 disposeBag을 subscribe에 추가하거나 수동적으로 dispose를 호출하는 것을 빼먹는다면, 옵져버블이 끝나지 않아 메모리 누수가 발생할 것이다.



print("------create1------")
Observable.create { observer -> Disposable in
    observer.onNext(1)    // == observer.on(.next(1))과 같은 의미
    observer.onCompleted()    // == observer.on(.completed1))과 같은 의미
    observer.onNext(2)    //방출되지 않는다.
    return Disposables.create()
}
.subscribe {
    print($0)
}
.disposed(by: disposeBag)
/*
 Create 오퍼레이터는 AnyObserver<_>라는 escaping 클로저이다.  Disposable을 리턴한다.
 여기서 AnyObserver는 그냥 제너릭 타입이다. 옵져버블 시퀀스에 값을 쉽게 추가할 수 있게 하는 것이다.
 observer.onNext(1)
 observer.completed()
 observer.onNext(2)
 return Dispoables.create()
 이렇게 추가한 값은 subscribe를 했을 때 방출되게 될 것이다.
 두 번째 onNext 이벤트는 방출되지 않는다. 왜일까?
 Completed 이벤트를 통해 이미 옵져버블이 종료되었기 때문이다.
 */


print("------create2------")
enum MyError: Error {
    case anError
}


Observable<Int>.create { observer -> Disposable in
    observer.onNext(1)    // == observer.on(.next(1))과 같은 의미
    observer.onError(MyError.anError)
    observer.onCompleted()    // == observer.on(.completed1))과 같은 의미
    observer.onNext(2)    //방출되지 않는다.
    return Disposables.create()
}
.subscribe {
    print($0)
}
.disposed(by: disposeBag)

//Error와 함게 종료된 후 dispose된다. 에러는 에러 후 옵져버즐을 종료시키기 때문에 error 후에는 어떤 이벤트도 방출되지 않는다.


//종료도 하지 않고 dispose도 하지 않으면 어떻게 될까?
Observable<Int>.create { observer -> Disposable in
    observer.onNext(1)    // == observer.on(.next(1))과 같은 의미
    observer.onNext(2)    //방출되지 않는다.
    return Disposables.create()
}
.subscribe {
    print($0)
}

//이렇게 되면 1과 2 이벤트가 잘 방출되지만 종료되고 dispose되지 않았기 때문에 메모리 낭비이다.



print("------defered1------")
/*
 defered
 subscribe를 기다리는 옵져버블을 만드는 대신에 각 subscribe에게 새롭게 옵져버블 항목을 제공하는 옵져버블 팩토리를 만드는 방식이다.
 옵져버블을 감싸는 옵져버블
 */
Observable.deferred {
    Observable.of(1, 2, 3)
}
.subscribe {
    print($0)
}
.disposed(by: disposeBag)



print("------defered1------")
//factory가 구독될 때마다 flip 값이 변경될 것이다.
var flip: Bool = false

let factory: Observable<String> = Observable.deferred {
    flip = !flip
    
    if flip {
        return Observable.of("1")
    } else {
        return Observable.of("2")
    }
}

for _ in 0 ... 3 {
    factory.subscribe(onNext: {
        print($0)
              })
        .disposed(by: disposeBag)
    }
