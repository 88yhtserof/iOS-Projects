//
//  BeerListTableViewController.swift
//  BreweryIntroductionService
//
//  Created by 임윤휘 on 2022/08/25.
//

import UIKit

class BeerListTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Configure
    private func configureNavigationBar() {
        title = "브루어리"
        navigationController?.navigationBar.prefersLargeTitles = true //네비게이션바의 제목을 큰 스타일로 보여주기
        
    }
}
