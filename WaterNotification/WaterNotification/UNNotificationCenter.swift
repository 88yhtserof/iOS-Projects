//
//  UNNotificationCenter.swift
//  WaterNotification
//
//  Created by 임윤휘 on 2022/07/07.
//

import Foundation
import UserNotifications

// UNUserNotificationCenter의 범용함수
//알림이 추가되는 부분: 1) 알림을 새로 추가할 떄, 2) 기존 알림의 토근이 활성화되는 경우

extension UNUserNotificationCenter {
    //alert 객체를 받아서 요청서을 만들고 최종적으로 NotificationCenter에 추가하는 메서드
    func addNotificationRequest(by alert: AlertModel){
        let content = UNMutableNotificationContent()
        content.title = "물 마실 시간이에요💦"
        content.body = "세계보건기구에서 권장하는 하루 물 섭취량은 1.2~1.5리터 입니다."
        content.sound = .default
        content.badge = 1 //뱃지는 자동으로 사라지지 않기 때문에 개발자가 어느 시점에서 수정해야한다.
    }
}
