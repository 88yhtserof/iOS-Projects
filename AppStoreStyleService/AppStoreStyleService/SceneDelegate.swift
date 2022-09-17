//
//  SceneDelegate.swift
//  AppStoreStyleService
//
//  Created by 임윤휘 on 2022/08/30.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        //코드베이스를 위해 특정 window에 scene 연결하기
        guard let scene = (scene as? UIWindowScene) else { return }
        
        self.window = UIWindow(windowScene: scene)
        self.window?.backgroundColor = .systemBackground
        self.window?.rootViewController = TabBarController()
        self.window?.makeKeyAndVisible()
    }
    
//사용하지 않는 메서드 삭제
}

