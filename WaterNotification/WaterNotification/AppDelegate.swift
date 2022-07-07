//
//  AppDelegate.swift
//  WaterNotification
//
//  Created by 임윤휘 on 2022/07/06.
//

import UIKit
//알림 전달을 위한 임폴트
import NotificationCenter
//사용자 권한 설정을 위한 임폴트
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var userNotificationCenter = UNUserNotificationCenter.current()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //앱이 실행 중일 때도 알림을 받기 위해서 AppDelegate에서 처리하기
        UNUserNotificationCenter.current().delegate = self
        
        //사용자 권한 받기
        //알림, 뱃지, 소리에 대해 권한 설정받기
        let authorizationOptons = UNAuthorizationOptions(arrayLiteral: [.alert ,.badge, .sound])
        //인증 요청하기
        userNotificationCenter.requestAuthorization(options: authorizationOptons){ _, error in
            if let error = error {
                print("ERROR : Notification Authorization \(error.localizedDescription)")
            }
        }
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

extension AppDelegate: UNUserNotificationCenterDelegate {
    //알림을 보내기 전에 호출되는 메서드
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        //핸들링
        completionHandler([.banner,.list, .badge, .sound]) //알림을 배너, 뱃지, 리스트, 소리로 전달한다.
    }
    
    //보낸 후 호출되는 메서드
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}
