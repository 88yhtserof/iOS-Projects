//
//  ViewController.swift
//  GitHubRepository
//
//  Created by 임윤휘 on 2022/12/17.
//

import UIKit
import RxSwift
import RxCocoa

class RepositoryListViewController: UITableViewController {
    
    private let organization = "Apple"
    //private let repositories = [Repository] RxSwift를 사용하지 않는다면 이런 식으로 구현 Swift의 시퀀스
    //Subject란 옵져버블이자 옵져버
    //BehaviorSubject 초기값을 가지는 subject
    private let repositories = BehaviorSubject<[Repository]>(value: [])
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        title = organization + "Repositories"
        
        self.refreshControl = UIRefreshControl()
        let refreshControl = self.refreshControl!
        refreshControl.backgroundColor = .white
        refreshControl.tintColor = .darkGray
        refreshControl.attributedTitle = NSAttributedString(string: "당겨서 새로고침")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        tableView.register(RepositoryListTableViewCell.self, forCellReuseIdentifier: "RepositoryListTableViewCell")
        tableView.rowHeight = 140
    }
    
    @objc func refresh() {
        //네트워크 통식 연결
    }
    
    func fetchRepositories(of organization: String) {
        //from : array만 받을 수 있는 연산자
        Observable.from([organization])
            .map { organization -> URL in //string을 URL로 변환
                return URL(string: "https://api.github.com/orgs/\(organization)/repos" )!
            }
            .map { url -> URLRequest in
                var request = URLRequest(url: url)
                request.httpMethod = "GET"
                return request
            }
            .flatMap { request -> Observable<(response: HTTPURLResponse, data: Data)> in //옵져버블 속성을 가진 옵져버블의 값 꺼내기 튜플의 형태를 반환하는 flatMap
                //rx를 통해 파운데이션이나 UIKit 등 swift에서 제공하는 여러 인자들을 RxSwift로 변환해줄 수 있다.
                return URLSession.shared.rx.response(request: request)
            }
            .filter { responds, _ in
                return 200 ..< 300 ~= responds.statusCode //응답의 상태코드가 200번대일 때만, 즉 성공했을 떄만 반환
            }
            .map { _, data -> [[String: Any]] in //데이터 변환
                guard let json = try? JSONSerialization.jsonObject(with: data, options: []),
                      let result = json as? [[String: Any]] else {
                    return []
                }
                return result
            }
            .filter { result in
                return result.count > 0 //데이터 변환에 실패한 경우 거르기
            }
            .map { objects in //데이터 변환에 성공한 경우
                return objects.compactMap { dic -> Repository? in //nil값을 제외하고 변환된 값을 반환하는 변환기
                    guard let id = dic["id"] as? Int,
                          let name = dic["name"] as? String,
                          let description = dic["description"] as? String,
                          let stargazersCount = dic["stargazers_count"] as? Int,
                          let language = dic["language"] as? String else {
                        return nil
                    }
                    
                    return Repository(id: id, name: name, description: description, stargazersCount: stargazersCount, launguage: language)
                }
            }
            .subscribe( onNext: { [weak self] newRepositories in
                self? .repositories.onNext(newRepositories)
                
                DispatchQueue.main.async {
                    self? .tableView.reloadData()
                    self?.refreshControl?.endRefreshing()
                }
            })
            .disposed(by: disposeBag)
    }
}

//UITableView DataSource Delegate
extension RepositoryListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RepositoryListTableViewCell"), for: indexPath) as? RepositoryListTableViewCell else  { return UITableViewCell() }
        
        return cell
    }
}
