//
//  StationArrivalDataResponseModel.swift
//  SubwayArrivalInfo
//
//  Created by 임윤휘 on 2022/12/01.
//

import Foundation

struct StationArrivalDataResponseModel: Decodable {
    var realtimeArrivalList: [RealTimeArrivalList] = []
    
    struct RealTimeArrivalList: Decodable {
        let line: String //행선
        let remainTime: String //남은 시간 또는 전역 출발
        let currentStation: String //현재 위치
        
        enum CodingKeys: String, CodingKey {
            case line = "trainLineNm"
            case remainTime = "arvlMsg2"
            case currentStation = "arvlMsg3"
        }
    }
}
