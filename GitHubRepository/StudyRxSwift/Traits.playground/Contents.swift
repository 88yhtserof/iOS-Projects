/*
 Traits - Single, Maybe, Completable
 
 보통 네트워크 환경에서 이 세 가지를 자주 사용하게 된다.
 기본적인 옵져버블를 사용해도 되지만, 조금 더 직관적이고 명시적인 코드 작성을 위해
 제한적인 역할을 하는 Traits를 사용하는 것이 좋다.
 코드 작성 시 Single, Maybe, Completable 중 어떤 것을 사용하는 것이 좋을 지 고민해보자
 */
import RxSwift

let disposeBag = DisposeBag()

enum TraitsError: Error {
    case single
    case maybe
    case completable
}

print("------Single1------")
Single<String>.just("smile😀")
    .subscribe(
        onSuccess: {
            print($0)
        },
        onFailure: {
            print("error: \($0)")
        },
        onDisposed: {
            print("disposed")
        }
    )
    .disposed(by: disposeBag)

//옵져버블과 비슷하지만 상대적으로 제한된 방식으로 표현하는 Single
//Observable<String>.just("smile")
//    .subscribe(
//        onNext: {},
//        onError: {},
//        onCompleted: {},
//        onDisposed: {}
//    )

print("------Single2------")
Observable<String>.just("smile😀")
    .asSingle()
    .subscribe(
        onSuccess: {
            print($0)
        },
        onFailure: {
            print("error: \($0.localizedDescription)")
        },
        onDisposed: {
            print("disposed")
        }
    )
    .disposed(by: disposeBag)

//에러 발생시키기
Observable<String>
    .create { observer -> Disposable in
        observer.onError(TraitsError.single)
        return Disposables.create()
    }
    .asSingle()
    .subscribe(
        onSuccess: {
            print($0)
        },
        onFailure: {
            print("error: \($0.localizedDescription)")
        },
        onDisposed: {
            print("disposed")
        }
    )
    .disposed(by: disposeBag)

print("------Single3------")
struct SomeJSON : Decodable {
    let name: String
}

enum JSONError: Error {
    case decodingError
}

let json1 = """
    {"name":"park"}
    """

let json2 = """
    {"my_name":"young"}
    """

func decode(json: String) -> Single<SomeJSON> {
    Single<SomeJSON>.create { observer -> Disposable in
        guard let data = json.data(using: .utf8),
              let json = try? JSONDecoder().decode(SomeJSON.self, from: data)
        else {
            observer(.failure(JSONError.decodingError))
            return Disposables.create()
        }
        
        observer(.success(json))
        return Disposables.create()
    }
}

//테스트
//decode 함수는 그저 Single 옵져버을 반환하는 함수이다.
//옵져버는 subscribe하지 않으면 어떠한 실행도 되지 않는다.
decode(json: json1)
    .subscribe{
        switch $0 {
        case .success(let json): //성공 시 디코드한 데이터 꺼내기
            print(json.name)
        case .failure(let error):
            print(error)
        }
    }
    .disposed(by: disposeBag)

decode(json: json2)
    .subscribe{
        switch $0 {
        case .success(let json): //성공 시 디코드한 데이터 꺼내기
            print(json.name)
        case .failure(let error):
            print(error)
        }
    }
    .disposed(by: disposeBag)

print("------Maybe1------")
Maybe<String>.just("sad🥲")
    .subscribe(
        onSuccess: {
            print($0)
        },
        onError: {
            print($0)
        },
        onCompleted: {
            print("compelted")
        },
        onDisposed: {
            print("disposed")
        }
    )
    .disposed(by: disposeBag)

print("------Maybe2------")
//에러 발생시키기
Observable<String>.create { observer -> Disposable in
    observer.onError(TraitsError.maybe)
    return Disposables.create()
}
.asMaybe()
.subscribe(
    onSuccess: {
        print("success: \($0)")
    },
    onError: {
        print("error: \($0)")
    },
    onCompleted: {
        print("completed")
    },
    onDisposed: {
        print("disposed")
    }
)
.disposed(by: disposeBag)

print("------Completable1------")
Completable.create { observer -> Disposable in
    observer(.error(TraitsError.completable))
    return Disposables.create()
}
.subscribe(
    onCompleted: {
        print("completed")
    },
    onError: {
        print("error: \($0)")
    },
    onDisposed: {
        print("disposed")
    }
)
.disposed(by: disposeBag)


print("------Completable2------")
Completable.create { observer -> Disposable in
    observer(.completed)
    return Disposables.create()
}
.subscribe {
    print($0)
}
.disposed(by: disposeBag)
