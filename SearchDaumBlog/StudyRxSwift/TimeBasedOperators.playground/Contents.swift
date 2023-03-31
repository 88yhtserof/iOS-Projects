import RxSwift
import RxCocoa
import UIKit
import PlaygroundSupport

let disposeBag = DisposeBag()


print("----------replay----------")
let greeting = PublishSubject<String>()
let parrot = greeting.replay(1) //버퍼 크기 1

//replay 관련한 연산자를 사용할 때는 connect 연산자를 사용해야한다.
parrot.connect()

greeting.onNext("1. Hello")
greeting.onNext("2. Hi")

parrot
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
//버퍼 크기가 1이기 때문에 구독 전 이벤트 중 가장 최신의 1개를 기억하고 방출한다.

greeting.onNext("3. How you doin") //구독 시점 이후에 발생한 이벤트이기 때문에 버퍼의 크기와 상관없이 무조건 방출된다.


print("----------replayAll----------")
//개수 제한 없이 구독 전에 발생한 이벤트를 모두 방출
let doctorStrange = PublishSubject<String>()
let timeStone = doctorStrange.replayAll()
timeStone.connect()

doctorStrange.onNext("1")
doctorStrange.onNext("2")

timeStone
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)


print("----------buffer----------")
// buffer은 array를 방출한다.
//let source = PublishSubject<String>()
//
//var count = 0
//let timer = DispatchSource.makeTimerSource()
//
//timer.schedule(deadline: .now() + 2, repeating: .seconds(1)) //현재 시간부터 2초를 마감시간으로 해서 1초마다 반복
//timer.setEventHandler {
//    count += 1
//    source.onNext("\(count)")
//}
//timer.resume()
//
//source
//    .buffer(
//        timeSpan: .seconds(2), //2초 동안 기다렸다가 그 동안 받은 이벤트 방출
//        count: 2, //최대 2개까지만.없으면 빈 array 방출
//        scheduler: MainScheduler.instance
//    )
//    .subscribe(onNext: {
//        print($0)
//    })
//    .disposed(by: disposeBag)


print("----------window----------")
//buffer와 유사. 차이점은 buffer은 array를 방출하고 window는 옵져버블을 방출한다.
//
//let maxObservableCount = 1
//let timeSpane = RxTimeInterval.seconds(2)
//
//let window = PublishSubject<String>()
//
//var windowCount = 0
//let windowTimeSource = DispatchSource.makeTimerSource()
//windowTimeSource.schedule(deadline: .now() + 2, repeating: .seconds(1))
//windowTimeSource.setEventHandler {
//    windowCount += 1
//    window.onNext("\(windowCount)")
//}
//windowTimeSource.resume()
//
//window
//    .window(
//        timeSpan: timeSpane,
//        count: maxObservableCount,
//        scheduler: MainScheduler.instance
//
//    )
//    .flatMap { windowObservable -> Observable<(index: Int, element: String)> in //windowsms 옵져버블을 반환하므로 flatMap을 사용
//        return windowObservable.enumerated()
//    }
//    .subscribe(onNext: {
//        print("\($0.index)번째 Observable의 요소 \($0.element)")
//    })
//    .disposed(by: disposeBag)
//

print("----------delaySubscription----------")
//구독 지연
//let delaySource = PublishSubject<String>()
//
//var delayCount = 0
//let delayTimeSource = DispatchSource.makeTimerSource()
//delayTimeSource.schedule(deadline: .now() + 2, repeating: .seconds(1))
//delayTimeSource.setEventHandler {
//    delayCount += 1
//    delaySource.onNext("\(delayCount)")
//}
//delayTimeSource.resume()
//
//delaySource
//    .delaySubscription(
//        .seconds(2), //2초 지연
//        scheduler: MainScheduler.instance
//    )
//    .subscribe(onNext: {
//        print($0)
//    })
//    .disposed(by: disposeBag)


print("----------delay----------")
//전체 시퀀스를 지연
//구독은 하지만 element의 방출을 설정한 시간만큼 지연
//let delaySubject = PublishSubject<Int>()
//
//var delayCount = 0
//let delayTimerSource = DispatchSource.makeTimerSource()
//delayTimerSource.schedule(deadline: .now(), repeating: .seconds(1))
//delayTimerSource.setEventHandler {
//    delayCount += 1
//    delaySubject.onNext(delayCount)
//}
//delayTimerSource.resume()
//
//
//delaySubject
//    .delay(.seconds(3), scheduler: MainScheduler.instance)
//    .subscribe(onNext: {
//        print($0)
//    })
//    .disposed(by: disposeBag)

/*
 통상적으로는 우리가 위에서 사용했던 타이머를 통해 타이머 역할을 하는 작업을 수행했지만 적절한 사용이 어렵다.
 조금 더 최근에는 DispathFramework가 DispathSource를 통해 타이머를 제공했는데, 기존의 NSTimer보다는 나은 방법이지만
 이 API는 이벤트 핸들러라는 맵핑없이는 복잡하다. 그래서 이러한 역할을 할 수 있는 간단한 해결책은
 RxSwift에서 제공하는 Interval, 즉 타이머 관련된 연산자이다.
*/
print("----------interval----------")
//Observable<Int>
//    .interval(.seconds(3), scheduler: MainScheduler.instance)
//    .subscribe(onNext: {
//        print($0)
//    })
//    .disposed(by: disposeBag)


print("----------timer----------")
//Observable<Int>
//    .timer(
//        .seconds(5), //구독 후 첫 번째 값 사이의 간격을 의미
//        period: .seconds(2), //간격
//        scheduler: MainScheduler.instance
//    )
//    .subscribe(onNext: {
//        print($0)
//    })
//    .disposed(by: disposeBag)


print("----------timeout----------")
let pushButton = UIButton(type: .system)
pushButton.setTitle("눌러주세요", for: .normal)
pushButton.sizeToFit()

PlaygroundPage.current.liveView = pushButton

pushButton.rx.tap
    .do(onNext: {
        print("tap")
    })
    .timeout(
        .seconds(5), //설정한 시간을 초과하면 에러를 발생시켜 전체 옵져버블을 종료한다.
        scheduler: MainScheduler.instance
    )
    .subscribe {
        print($0)
    }
    .disposed(by: disposeBag)
