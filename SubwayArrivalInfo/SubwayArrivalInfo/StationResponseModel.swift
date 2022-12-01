//
//  StationResponseModel.swift
//  SubwayArrivalInfo
//
//  Created by 임윤휘 on 2022/12/01.
//

import Foundation

struct StationResponseModel: Decodable {
    //StationResponseModel.searchInfo.row[1] 이런식으로 사용해야하는데 너무 길다
    //따라서 바로 사용할 수 있도록 만든 전역 변수 생성
    //return searchInfo.row하는 변수 -> stations[1]
    var stations: [Station] { searchInfo.row }
    
    private let searchInfo: SearchInfoBuSubwayNameServiceModel
    
    enum CodingKeys: String, CodingKey {
        case searchInfo = "SearchInfoBySubwayNameService"
    }
    
    struct SearchInfoBuSubwayNameServiceModel: Decodable {
        var row: [Station] = []
    }
}

struct Station: Decodable {
    let stationName: String
    let lineNumber: String
    
    //API의 key와 다른 값을 사용할 예정이므로 CodingKeys 열거형을 만든다.
    enum CodingKeys: String, CodingKey {
        case stationName = "STATION_NM"
        case lineNumber = "LINE_NUM"
    }
}
