//
//  TabBarController.swift
//  InstagramFeed
//
//  Created by 임윤휘 on 2022/12/05.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let feedViewController = UINavigationController(rootViewController: FeedViewController())
        feedViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: .init(systemName: "house"),
            selectedImage: .init(systemName: "house.fill")
        )
        
        let profileViewController = UINavigationController(rootViewController: ProfileViewController())
        profileViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: .init(systemName: "person"),
            selectedImage: .init(systemName: "person.fill")
        )
        
        viewControllers = [feedViewController, profileViewController]
    }
}
