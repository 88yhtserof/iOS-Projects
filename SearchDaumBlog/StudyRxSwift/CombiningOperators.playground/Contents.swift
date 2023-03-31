import RxSwift

let disposeBag = DisposeBag()

print("----------startWith----------")
//초기값을 받을지 말지가 옵져버블을 생성할 때 가장 중요한 요소 중 하나
//예 현재 위치, 네트워크 연결과 같이 초기값이 필요한 경우가 있다
//이럴 대 현재 상태와 함께 초기값을 붙일 수 있다 그럴 때 사용하는 startWith

let classYellow = Observable<String>.of("학생1", "학생2", "학생3")

classYellow
    .startWith("선생님") //초기값의 타입은 옵져버블의 타입과 동일해야한다
    .subscribe( onNext: {
        print($0)
    })
    .disposed(by: disposeBag)


classYellow
    .enumerated()// 인덱스와 값을 튜플 형태로 반환
    .map { index, element in
        return element + "어린이 map 사용 예시" + "\(index)"
    }
    .startWith("선생님") //초기값의 타입은 옵져버블의 타입과 동일해야한다. 연산자 사용의 위치는 상관없다.
    .subscribe( onNext: {
        print($0)
    })
    .disposed(by: disposeBag)


print("----------concat1----------")
//옵져버블.concat을 해서 시퀀스나 컬렉션의 형태로 넣을 수 있다.
let classYellowChildren = Observable<String>.of("학생1", "학생2", "학생3")
let teacher = Observable<String>.of("선생님")

let walkInLine = Observable
    .concat([teacher, classYellowChildren])

walkInLine
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("----------concat2----------")
//바로 요소에 다음 요소를 붙이므로 시퀀스를 만들 수도 있다.
teacher
    .concat(classYellowChildren)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)


print("----------concatMap----------")
//flatMap과 밀접한 관계가 있다. : 옵져버블 시퀀스가 구독을 위해 반환이 되고  방출된 옵져버블들은 합쳐지게 된다.
//concatMap 각각의 시퀀스가, 다음 시퀀스가 구독되기 전에  합쳐지는 것을 보증한다.

let dayCareCenter: [String : Observable<String>] = [
    "노랑반" : Observable.of("학생1", "학생2", "학생3"),
    "파랑반" : Observable.of("유아1", "유아2", "유아3")
]

Observable.of("노랑반", "파랑반")
    .concatMap { className in
        dayCareCenter[className] ?? .empty() //className에 해당하는 옵져버블을 검색할 것이고, 이 옵져버블이 구독되어 요소들이 방출될 것 이다.
        //만약 해당하는 값이 없다면 빈 옵져버블 반환
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("----------merge1----------")
//합치기
//from : element로 array 타입만 받는다.
let gangBuk = Observable.from(["강북구", "성북구", "동대문구", "종로구"])
let gangNam = Observable.from(["강남구", "강동구", "영등포구", "양천구"])

//아래 옵져버블의 타입은 Observable<Observable<String>>
Observable.of(gangBuk, gangNam)
    .merge() //두개의 옵져버블을 합쳐서 구독. 하지만 어떤 순서로 출력될지는 보장하지 못한다.
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)


print("----------merge2----------")
Observable.of(gangBuk, gangNam)
    .merge(maxConcurrent: 1) //한 번에 받아낼 옵져버블의 수를 제한한다. 받은 옵져버블이 element를 모두 방출하기 전까지는 다음으로 넘어가지 않음
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)


print("----------combinelatest1----------")
let familyName = PublishSubject<String>()
let name = PublishSubject<String>()

let fullNameInKorea = Observable
    .combineLatest(familyName,name) { familyName, name in //성과 이름의 최종값을 받아 클로저를 실행한다.
        familyName + name
    }

fullNameInKorea
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)


familyName.onNext("김") //성은 있지만 이름은 아직 없으니 이름 next 이벤트가 발생할 때까지 기다린다
name.onNext("철수") //김철수
name.onNext("영수") //김영수 이름의 최신 값이 영수이기 때문에 더 이상 철수는 나오지 않는다.
name.onNext("은영") //김은영 이름의 최신 값이 은영이기 때문에 더 이상 영수는 나오지 않는다.
familyName.onNext("박") //박은영 성의 최신 값이 박이기 때문에 더 이상 김은 나오지 않는다.
familyName.onNext("이") //이은영
familyName.onNext("조") //조은영


print("----------combinelatest2----------")
//of : 하나 이상의 eleement를 넣을 수 있다. 순차적으로 방출
let dateFormatter = Observable<DateFormatter.Style>.of(.short, .long)
let currentDate = Observable<Date>.of(Date())

let showCurrentDate = Observable
    .combineLatest(dateFormatter, currentDate) { formatter, date -> String in
        let dateFomatter = DateFormatter()
        dateFomatter.dateStyle = formatter
        return dateFomatter.string(from: date)
    }

showCurrentDate
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

//combineLatest는 총 8개의 element를 넣을 수 있다. 만약 8개 넘게 넣고 싶다면 combineLatest를 여러 번 사용해 줄 수도 있다


print("----------combinelatest3----------")
let lastName = PublishSubject<String>()
let firstName = PublishSubject<String>()

let fullNameInUS = Observable
    .combineLatest([firstName, lastName]) { name in
        name.joined(separator: " ")
    }

fullNameInUS
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

lastName.onNext("Kim")
firstName.onNext("Paul")
firstName.onNext("Stella")
firstName.onNext("Lily")


print("----------zip----------")
//순서를 보장하면서 element들이 하나씩 합쳐진다
//두 옵져버블은 하나씩 element들을 방출하기를 기다리다가 둘 중 한 옵져버블이라도 완료되면 zip 전체가 완료된다.
//merge 같은 경우는 하나가 완료되더라도 옵져버블의 모든 element가 방출된다.
enum Fight {
    case victory
    case defeat
}

let match = Observable<Fight>.of(.victory, .victory, .defeat, .victory, .defeat) //5
let fighter = Observable<String>.of("한국", "일본",  "독일",  "영국", "스위스", "미국") //6

let outcome = Observable
    .zip(match, fighter) { outcome, representative in
        return representative + "선수" + " \(outcome)"
    }

outcome
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)



print("----------withLatestFrom1----------")
//withLatestFrom의 첫 번째 옵져버블이 방아쇠 역할을 하고 두 번째 옵져버블이 이 다음 역할을 한다.
//반드시 첫 번째 옵져버블이 이벤트를 발생해야만 두 번째 옵져버블의 이벤트가 나타날 수 있다.
//두 번째 옵져버블의 이벤트 중에서도 가장 최신의 이벤트만 나타난다.
let triger = PublishSubject<Void>()
let runner = PublishSubject<String>()

triger
    .withLatestFrom(runner)
//    .distinctUntilChanged() //이것을 사용하면 아래의 sample 연산자와 동일하게 사용할 수 있다.
//연달아 같은 값이 반복될 때, 중복된 값을 막아주는 역할을 한다.
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

runner.onNext("🏃‍♀️")
runner.onNext("🏃‍♀️ 🏃‍♀️")
runner.onNext("🏃‍♀️ 🏃‍♀️ 🏃‍♀️")

triger.onNext(Void()) //runner옵져버블이 아닌 triger 옵져버블의 이벤트 발생으로 작동
triger.onNext(Void())


print("----------sample----------")
//start 옵져버블에 3 번 이벤트를 발생시켜도 가장 최신의 이벤트만 한 번 방출된다.
//sample은 withLatestFrom과 유사하지만 단 한 번만 이벤트를 방출한다는 점이 다르다.
let start = PublishSubject<Void>()
let racer1 = PublishSubject<String>()

racer1
    .sample(start)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

racer1.onNext("🏎")
racer1.onNext("🏎  🚗")
racer1.onNext("🏎  🚗  🚙")
start.onNext(Void())
start.onNext(Void())
start.onNext(Void())


print("----------amb----------") //ambiguous 모호한
//두 가지 시퀀스를 받을 때 어떤 시퀀스를 구독할 지 모호한 경우 사용할 수 있다.
//두 가지 옵져버블을 모두 구독하긴 한다. 하지만 element를 먼저 방출하는 옵져버블이 있다면 나머지 옵져버블에 대해서 더이상 구독하지 않는다.
let bus1 = PublishSubject<String>()
let bus2 = PublishSubject<String>()

let busStop = bus1.amb(bus2) //어떤 순서이든 두 옵져버블 모두를 지켜보다 먼저 이벤트를 발생하는 옵져버블만 구독을 유지한다.

busStop
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

//버스2에 대해서만 이벤트 방출
bus2.onNext("버스2-승객0")
bus1.onNext("버스1-승객0")
bus1.onNext("버스1-승객1")
bus2.onNext("버스2-승객1")
bus1.onNext("버스1-승객2")
bus2.onNext("버스2-승객2")


print("----------switchLatest----------")
//raiseHand 옵져버블로 들어온 마지막 시퀀스의 아이템만 구독하는 것
let student1 = PublishSubject<String>()
let student2 = PublishSubject<String>()
let student3 = PublishSubject<String>()

let raiseHand = PublishSubject<Observable<String>>()

let classRoom = raiseHand.switchLatest()

classRoom
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

raiseHand.onNext(student1) //1번 학생의 이벤트만 방출
student1.onNext("학생 1 - 1")
student2.onNext("학생 2 - 1")

raiseHand.onNext(student2) //2번 학생의 이벤트만 방출
student2.onNext("학생 2 - 2")
student1.onNext("학생 1 - 2")

raiseHand.onNext(student3) //3번 학생의 이벤트만 방출
student2.onNext("학생 2 - 3")
student1.onNext("학생 1 - 3")
student3.onNext("학생 3 - 1")

raiseHand.onNext(student1) //1번 학생의 이벤트만 방출
student1.onNext("학생 1 - 5")
student2.onNext("학생 2 - 4")
student3.onNext("학생 3 - 2")
student1.onNext("학생 1 - 6")


print("----------reduce----------")
//시퀀스 내 요소들 간의 결합
//Swift의 reduce와 동일한 기능
//reduce: 주어진 시퀀스의 각 요소들을 계산하여 총 결과를 마지막에 반환한다.
Observable.from((1 ... 10))
    .reduce(0) { summary, newValue in
        return summary + newValue
    }
//    .reduce(0, accumulator: +) //위 reduce 연산과 동일
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)


print("----------scan----------")
//reduce와 동일하게 시퀀스의 각 요소들을 계산하여 방출한다.
//차이점은 scan의 경우 매 계산의 결과를 반환한다. 반환 타입은 Observable이다.
Observable.from((1 ... 10))
    .scan(0, accumulator: +)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
