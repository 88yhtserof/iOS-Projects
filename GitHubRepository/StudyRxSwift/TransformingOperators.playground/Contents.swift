import RxSwift

let disposeBag = DisposeBag()

print("------toArray------")
//toArray를 사용하면 Single로 변환해주고 array로 반환한다
Observable.of("A", "B", "C")
    .toArray()
    .subscribe(
        onSuccess: {
            print($0)
        })
    .disposed(by: disposeBag)

//하나씩 넣어줬던 element들이 array로 방출
//>>>["A", "B", "C"]

print("------map------")
//swift에서 사용하는 map과 동일하다.
Observable.of(Date())
    .map { date -> String in
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter.string(from: date)
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)



print("------flatMap------")
//옵져버블 속성을 가진 옵져버블의 값 꺼내기
protocol Athlete {
    var score: BehaviorSubject<Int> { get }
}

struct SoccerPlayer: Athlete {
    var score: BehaviorSubject<Int>
}

let korea = SoccerPlayer(score: BehaviorSubject<Int>(value: 10))
let america = SoccerPlayer(score: BehaviorSubject<Int>(value: 8))

let olympic = PublishSubject<Athlete>()

olympic
    .flatMap{ player in
        player.score
    }
    .subscribe(onNext: {
        print("", $0)
    })
    .disposed(by: disposeBag)

olympic.onNext(korea) //한국 선수 출전
korea.score.onNext(10) //한국 선수 득점

olympic.on(.next(america)) //미국 선수 출전
korea.score.onNext(10) //한국 선수 득점
america.score.on(.next(9))


print("------flatMapLatest------")
//map과 switchLatest을 합친 것과 같다
//switchLatest는 가장 최근에 옵져버블에서 값을 생성하고 그 이전에 발생한 옵져버블을 구독해지한다.
struct HighJumper: Athlete {
    var score: BehaviorSubject<Int>
}

let seoul = HighJumper(score: BehaviorSubject<Int>(value: 7))
let jeju = HighJumper(score: BehaviorSubject<Int>(value: 6))

let nationalSportsFestival = PublishSubject<Athlete>()

nationalSportsFestival
    .flatMapLatest { athlete in
        athlete.score
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

nationalSportsFestival.onNext(seoul)
seoul.score.onNext(9)

nationalSportsFestival.onNext(jeju) //여기서 seoul의 옵져버블 구독해지. 더이상 seoul의 값 방출 안 됨.
seoul.score.onNext(10)
jeju.score.onNext(8)

//사전에서 단어를 찾는 것을 생각해보자 swift
//s를 입력한 후 w를 입력하면 s에 대한 결과값이 더 이상 남아있지 않다
//즉 최신의 결과값만을 보여주고 있다. 여기서 flatMapLatest를 사용할 수 있다.


print("------meterialize and dematerialize------")
//옵져버블을 옵져버블 이벤트로 변환해야 할 때가 있다
enum Foul: Error {
case falseStart
}

struct Runner: Athlete {
    var score: BehaviorSubject<Int>
}

let kim = Runner(score: BehaviorSubject<Int>(value: 0))
let moon = Runner(score: BehaviorSubject<Int>(value: 1))

let run100m = BehaviorSubject<Athlete>(value: kim) //kim 출전

run100m
    .flatMapLatest { athlete in
        athlete.score
            .materialize() //이벤트 종류 함께 방출
    }
    .filter {
        //materialize를 사용해야 요소에 error 프로퍼티 존재
        guard let error = $0.error else { //에러가 발생하지 않으면 통과
            return true
        }
        print(error) //에러가 발생하면 error를 출력하고
        return false //에러 이벤트 방출 차단
    }
    .dematerialize() //원래의 형태로 되돌려준다
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

kim.score.onNext(1)
kim.score.onError(Foul.falseStart) //에러 이벤트 발생으로 경기 종료
kim.score.onNext(2) //이벤트 방출 x

run100m.onNext(moon) //moon 출전



print("------전화번호 11자리------")
let input = PublishSubject<Int?>()

let list: [Int] = [1]

input
    .flatMap {
        $0 == nil
        ? Observable.empty()
        :Observable.just($0)
    }
    .map { $0! }
    .skip(while:  {
        $0 != 0
    })
    .take(11) //01012344567 11개를 받아야 다음 작업 진행
    .toArray()
    .asObservable()
    .map {
        $0.map { "\($0)" } //문자열로 변환
    }
    .map { numbers in
        var numberList = numbers
        numberList.insert("-", at: 3) //010-12344567
        numberList.insert("-", at: 8) //010-1234-4567
        
        let number = numberList.reduce(" ", +)
        return number
    }
    .subscribe (onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

input.on(.next(10))
input.on(.next(0))
input.on(.next(nil))
input.on(.next(1))
input.on(.next(0))
input.on(.next(1))
input.on(.next(2))
input.on(.next(3))
input.on(.next(nil))
input.on(.next(4))
input.on(.next(5))
input.on(.next(6))
input.on(.next(7))
input.on(.next(8))
