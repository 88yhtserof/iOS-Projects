//
//  StationSearchViewController.swift
//  SubwayArrivalInfo
//
//  Created by 임윤휘 on 2022/11/29.
//

import Alamofire
import SnapKit
import UIKit

class StationSearchViewController: UIViewController {
    private var numberOfStation = 0
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isHidden = true
        
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigation()
        configureView()
        
        requestStationName()
    }
    
    private func configureNavigation() {
        navigationController?.navigationBar.prefersLargeTitles = true //큰 제목 사용
        navigationItem.title = "지하철 도착 정보"
        
        let searchController = UISearchController()
        searchController.searchBar.placeholder = "지하철 역을 입력해주세요."
        searchController.obscuresBackgroundDuringPresentation = false //검색하는 동안 화면을 어둡게 할지 말지 설정
        searchController.searchBar.delegate = self
        
        navigationItem.searchController = searchController
    }
    
    private func configureView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints{ make in
            make.edges.equalToSuperview()
        }
    }
    
    private func requestStationName() {
        let urlString = "http://openapi.seoul.go.kr:8088/sample/json/SearchInfoBySubwayNameService/1/5/종로3가"
        
        //종로3가 한글이 인코딩이 되면 글자가 깨짐. 따라서 따로 인코딩처리를 해주어야한다.
        AF
            .request(urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
            .responseDecodable(of: StationResponseModel.self) { response in
                //response.result로 성공 실패 모두 들어오기 때문에 guard case문으로 구분
                //let result: Result<StationResponseModel, AFError>
                //즉 성공이면 통과, 실패면 리턴
                guard case .success(let data) = response.result else { return }
                
                print(data.stations)
            }
    }
}

extension StationSearchViewController: UISearchBarDelegate {
    //사용자가 편집을 시작했을 때 호출
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        numberOfStation = 10
        tableView.isHidden = false
        tableView.reloadData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        numberOfStation = 0
        tableView.isHidden = true
        tableView.reloadData()
    }
}

extension StationSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let stationDetailViewController = StationDetailViewController()
        
        self.navigationController?.pushViewController(stationDetailViewController, animated: true)
    }
}

extension StationSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfStation
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        
        content.text = "\(indexPath.row + 1)"
        content.secondaryText = "\(indexPath.row + 1)번 cell"
        content.image = .init(systemName: "person.fill")
        content.imageProperties.tintColor = .darkGray
        
        cell.contentConfiguration = content
        
        return cell
    }
    
    
}

