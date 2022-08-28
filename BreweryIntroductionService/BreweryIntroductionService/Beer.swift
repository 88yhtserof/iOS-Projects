//
//  Beer.swift
//  BreweryIntroductionService
//
//  Created by 임윤휘 on 2022/08/25.
//

import Foundation

struct Beer: Decodable {
    let id: Int?
    let name, taglineString, description, brewersTips, imageURL: String?
    let foodPairing: [String]?
    
    //taglineString을 해시태그처럼
    var tagLine: String {
        //"tagline": "Post Modern Classic. Spiky. Tropical. Hoppy.",
        //API 응답값을 보면 tagline이 . 으로 구분되어 있다 따라서 일단 구분점을 기준으로 태그를 배열로 만들자
        let tags = taglineString?.components(separatedBy: ". ")
        let hashtags = tags?.map{
            "#" + $0.replacingOccurrences(of: " ", with: "") //띄어쓰기 없애기
                .replacingOccurrences(of: ".", with: "") //혹시 점이 남아있으면 없애줘
                .replacingOccurrences(of: ",", with: " #") //혹시 쉼표가 있으면 없애고 #으로 대체
        }
        return hashtags?.joined(separator: " ") ?? "" //hashtags배열의 각 원소들을 중간에 공백을 붙여 문자열로 만들어 내보내기
        //#Post Modern Classic #Spiky #Tropical #Hoppy
    }
    
    //CodingKey 사용 시 모든 프로퍼티가 포함되어야 한다.
    // All your properties should be included
    enum CodingKeys: String, CodingKey {
        //서로 이름이 다르기 때문에 CodingKey를 사용해 서로 연결해 준다.
        case id, name, description //동일한 키
        case taglineString = "tagline"
        case imageURL = "image_url"
        case brewersTips = "brewers_tips"
        case foodPairing = "food_pairing"
    }
}
