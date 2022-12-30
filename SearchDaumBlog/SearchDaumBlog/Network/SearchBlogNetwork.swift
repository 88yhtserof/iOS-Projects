//
//  SearchBlogNetwork.swift
//  SearchDaumBlog
//
//  Created by 임윤휘 on 2022/12/30.
//

import Foundation
import RxSwift

enum SearchNetworkError: Error {
    case invalidURL
    case invalidJSON
    case networkError
    case apiKeyError
}

class SearchBlogNetwork {
    private let session: URLSession
    let api = SearchBlogApl()
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    //Single은 성공 또는 에러를 단 한 번만 방출하는 옵져버블이다.
    //Result는 성공 또는 실패만 있는 Swift의 열거형이다. 경우에 따라 값을 전달할 수 있다.
    func searchBlog(query: String) -> Single<Result<DaumBlog, SearchNetworkError>>{
        guard let url = api.searchBlog(query: query).url else {
            return .just(.failure(.invalidURL))
        }
        guard let infoDictionary = Bundle.main.infoDictionary else {
            return .just(.failure(.apiKeyError))
        }
        guard let apiKey = infoDictionary["API_KEY"] as? String else {
            return .just(.failure(.apiKeyError))
        }
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("KakaoAK " + apiKey, forHTTPHeaderField: "Authorization")
        
        //session을 사용해 네트워크 요청을 한건데, Rx화해서 사용하기
        return session.rx.data(request: request as URLRequest) //아래는 요청 후 응답 값을 받아 처리하는 과정
            .map { data in
                do {
                    let blogData = try JSONDecoder().decode(DaumBlog.self, from: data)
                    return .success(blogData)
                }
                catch { //디코드 실패 시
                    return .failure(.invalidJSON)
                }
            }
            .catch({ _ in //네트워크 요청 실패 시
                    .just(.failure(.networkError))
            })
            .asSingle()
    }
}
