//
//  AppDelegate.swift
//  EmergencyAnnouncement
//
//  Created by 임윤휘 on 2022/07/09.
//

import UIKit
import Firebase
import UserNotifications
import FirebaseMessaging

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    //didFinishLaunchingWithOptions에 해도 되지만 구분을 위해 그냥 여기에 한다
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        return true
    }


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        //FCM의 현재 토큰이나 갱신되는 시점을 알고 적절한 액션을 취할 수 있다.
        Messaging.messaging().delegate = self
        
        //FCM 현재 등록 토큰 확인하기
        Messaging.messaging().token{ token, error in
            if let error = error {
                print("EEEOR FSM 토큰 가져오기 : \(error.localizedDescription)")
            }else if let token = token {
                print("FCM 등록 토큰 \(token)")
            }
        }
        
        //사용자 기기에서 권한 부여받기
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) {_, error in
            print("ERROR, Request Notifications Authorization: \(String(describing: error))")
        }
        application.registerForRemoteNotifications()
        
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
    //알림 종류 설정
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.list, .badge, .sound])
    }
}

/*
 기본적으로 FCM SDK는 앱을 시작할 때 클라이언트 앱 인스턴트 용 등록 토큰을 생성한다.
 앞서서 APNs도 보안을 위해 디바이스 토큰을 생성한다고 했던 것처럼,
 FCM 도 마찬가지로 자체 토큰을 사용해 타겟팅한 알림을 앱을 모든 특정 인스턴스로 전송할 수 있다.
 iOS가 일반적으로 앱을 시작할 때, APNs 디바이스토큰을 전달하는 것과 마찬가지로 FCM은 FIR 메세징 델리게이트 메서드를 사용해 등록 토큰을 제공한다.
 FCM SDK는 최초로 앱을 시작할 때, 토큰이 업데이트되거나 무효화될 때 신규, 기존 토큰을 검색해서 가지게 된다.
 따라서 FCM이 등록 토큰 기반으로 access 할 수 있도록 코드 작업을 하자.
 */
extension AppDelegate: MessagingDelegate {
    //FCM의 현재 토큰이나 갱신되는 시점을 알고 적절한 액션을 취할 수 있다.
    
    //갱신되는 시점알기
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        //다시 토큰을 받았는지 확인할 수 있다.
        //만약 토큰을 받았다면 옵셔널이 아닐 것이다.
        guard let fcmToken = fcmToken else {return}
        print("FCM 등록 갱신: \(fcmToken)")
    }
}
