//
//  AppViewController.swift
//  AppStoreStyleService
//
//  Created by 임윤휘 on 2022/08/30.
//

import SnapKit
import UIKit

final class AppViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavigationController()
    }
}

private extension AppViewController {
    func setUpNavigationController() {
        navigationItem.title = "앱"
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}
