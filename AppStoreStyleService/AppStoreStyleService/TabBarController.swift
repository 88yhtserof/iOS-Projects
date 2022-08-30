//
//  TabBarController.swift
//  AppStoreStyleService
//
//  Created by 임윤휘 on 2022/08/30.
//

import UIKit

class TabBarController: UITabBarController {
    
    //탭 바 컨트롤러에 넣을 탭바 아이템
    //lazy 키워드를 사용하면 해당 변수가 처음 호출되었을 때 사용자가 지정한 함수를 사용해 생성되기 때문에 메모리 절약에 도움이 된다.
    private lazy var todayViewController: UIViewController = {
        let viewController = UIViewController()
        let tabBarItem = UITabBarItem(
            title: "투데이",
            image: UIImage(systemName: "mail"),
            tag: 0
        )
        
        viewController.tabBarItem = tabBarItem
        
        return viewController
    }()
    
    private lazy var appViewController: UIViewController = {
        let viewController = UIViewController()
        let tabBarItem = UITabBarItem(
            title: "앱",
            image: UIImage(systemName: "square.stack.3d.up"),
            tag: 1
        )
        
        viewController.tabBarItem = tabBarItem
        
        return viewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //탭 바 아이템 추가하기
        viewControllers = [todayViewController, appViewController]
    }
}
