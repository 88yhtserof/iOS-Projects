//
//  Content.swift
//  NetflixMovieRecommendation
//
//  Created by 임윤휘 on 2022/08/18.
//

import UIKit

struct Content: Decodable {
    //Key 명이 다르면 데이터를 디코드할 수 없으니 주의하자!
    let sectionType: SectionType //몇 가지 타입 형태가 고정되어 있기 때문에 string말고 열거형을 사용하자
    let sectionName: String
    let contentItem: [Item]
    
    enum SectionType: String, Decodable {
        case basic
        case main
        case large
        case rank
    }
}

struct Item: Decodable {
    let description: String
    let imageName: String
    
    //포스트명이 받아오는 포스터 key값과 동일하기 때문에 바로 UIImage로 변환하여 내보낼 수 있다.
    var image: UIImage {
        return UIImage(named: imageName) ?? UIImage()
    }
}
