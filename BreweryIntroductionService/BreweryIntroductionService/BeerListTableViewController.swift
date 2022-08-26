//
//  BeerListTableViewController.swift
//  BreweryIntroductionService
//
//  Created by 임윤휘 on 2022/08/25.
//

import UIKit

class BeerListTableViewController: UITableViewController {
    var beerList = [Beer]() //서버에서 받은 데이터를 저장할 배열
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        
        //UITableView 설정
        tableView.register(BeerListTableViewCell.self, forCellReuseIdentifier: "BeerListTableViewCell")
        tableView.rowHeight = 150 //Delegate를 사용할 수도 있지만 이렇게 간단한 설정도 가능 고정 값
    }
    
    //MARK: - Configure
    private func configureNavigationBar() {
        title = "브루어리"
        navigationController?.navigationBar.prefersLargeTitles = true //네비게이션바의 제목을 큰 스타일로 보여주기
        
    }
}

//UITableView DataSource, Delegate
extension BeerListTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beerList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BeerListTableViewCell", for: indexPath) as? BeerListTableViewCell else {return UITableViewCell()}
        
        let beer = beerList[indexPath.row]
        cell.configure(with: beer)
        
        return cell
    }
}
