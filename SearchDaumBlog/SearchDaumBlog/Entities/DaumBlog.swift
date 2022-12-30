//
//  DaumBlog.swift
//  SearchDaumBlog
//
//  Created by 임윤휘 on 2022/12/30.
//

import Foundation

struct DaumBlog: Decodable {
    let documents: [DaumBlogDocument]
}

struct DaumBlogDocument: Decodable {
    let title: String?
    let name: String?
    let thumbnail: String?
    let datetime: Date?
    
    enum CodingKeys: String, CodingKey {
        case title, thumbnail, datetime
        case name = "blogname"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.title = try? values.decode(String.self, forKey: .title)
        self.name = try? values.decode(String.self, forKey: .name)
        self.thumbnail = try? values.decode(String.self, forKey: .thumbnail)
        self.datetime = Date.parse(values, key: .datetime)
    }
}

//JSON에는 Date 타입이 없기 때문에 파싱하는 함수 만들기
extension Date {
    static func parse<K: CodingKey>(_ values: KeyedDecodingContainer<K>, key: K) -> Date? {
        guard let dateString = try? values.decode(String.self, forKey: key),
              let date = from(dateString: dateString) else {
                  return nil
              }
        
        return date
    }
    
    static func from(dateString: String) -> Date? {
        let dateFormat = DateFormatter()
        
        //JSON을 넘어온 date의 형식은 아래와 같다 2022-12-30T08:05:37.000+09:00
        dateFormat.dateFormat = "yyyy=MM=dd'T'HH:mm:ss.SSS.XXXXX"
        dateFormat.locale = Locale(identifier: "ko_kr")
        if let date = dateFormat.date(from: dateString) {
            return date
        }
        
        return nil
    }
}
