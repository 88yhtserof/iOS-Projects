//
//  ProfileViewController.swift
//  InstagramFeed
//
//  Created by 임윤휘 on 2022/12/07.
//

import UIKit

class ProfileViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
    }
}

private extension ProfileViewController {
    func configureNavigationBar() {
        navigationItem.title = "UserName"
        
        let rightBarButton = UIBarButtonItem(
            image: UIImage(systemName: "ellipsis"),
            style: .plain,
            target: self,
            action: nil
        )
        navigationItem.rightBarButtonItem = rightBarButton
    }
}
