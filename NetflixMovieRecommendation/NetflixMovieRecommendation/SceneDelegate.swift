//
//  SceneDelegate.swift
//  NetflixMovieRecommendation
//
//  Created by 임윤휘 on 2022/08/18.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    //특정 뷰 컨트롤러를 이니셜 뷰 컨트롤러로 인지하고 화면에 띄울 수 있도록 설정
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        //window를 관리할 scene을 생성
        guard let windowScene = scene as? UIWindowScene else { return } //하나 이상의 window(창)를 관리하는 scene
        self.window = UIWindow(windowScene: windowScene) //기존 window 객체에 Scene을 연결해준다.
        
        let layout = UICollectionViewFlowLayout() //collectionView는 FlowLayout이 있어야 layout을 만들 수 있다..?
        let homeViewController = HomeViewController(collectionViewLayout: layout)
        //네비게이션 컨트롤러의 rootViewController 설정
        let rootNavigationController = UINavigationController(rootViewController: homeViewController)
        
        self.window?.rootViewController = rootNavigationController
        //makeKeyAndVisible() 메서드를 사용해야 앞에서 window에 설정한 값들이 화면에 보여진다.
        self.window?.makeKeyAndVisible() //window를 보여주고 그 window를 key window로 만든다.
        //window를 보여주고 이 window의 단계 이하의 window들 중 맨 앞에 위치시킨다.
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

