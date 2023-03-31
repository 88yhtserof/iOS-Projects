//
//  SearchBlogApl.swift
//  SearchDaumBlog
//
//  Created by 임윤휘 on 2022/12/30.
//

import Foundation

struct SearchBlogApl {
    static let scheme = "https"
    static let host = "dapi.kakao.com"
    static let path = "/v2/search/"
    
    func searchBlog(query: String) -> URLComponents {
        var components = URLComponents()
        components.scheme = SearchBlogApl.scheme
        components.host = SearchBlogApl.host
        components.path = SearchBlogApl.path + "blog"
        
        components.queryItems = [
            URLQueryItem(name: "query", value: query)
        ]
        
        return components
    }
}
