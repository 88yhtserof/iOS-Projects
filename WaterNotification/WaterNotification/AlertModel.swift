//
//  AlertModel.swift
//  WaterNotification
//
//  Created by 임윤휘 on 2022/07/06.
//

import Foundation

struct AlertModel: Codable {
    var id: String = UUID().uuidString //고유한 값이므로 UUID 사용. UniversallyUniqueIdentifier 보편적 고유 식별자
    let date: Date
    var isOn: Bool
    
    //바로 Label에 시간문자열을 할당할 수 있도록
    var time: String{
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "hh:mm"
        return timeFormatter.string(from: date)
    }
    
    //바로 Label에 오전오후 문자열을 할당
    var meridiem: String {
        let meridiemFormatter = DateFormatter()
        meridiemFormatter.dateFormat = "a" //오전오후 표시
        meridiemFormatter.locale = Locale(identifier: "ko") //한국 시간대
        return meridiemFormatter.string(from: date)
    }
}
