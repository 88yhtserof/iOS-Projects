//
//  ViewController.swift
//  GitHubRepository
//
//  Created by 임윤휘 on 2022/12/17.
//

import UIKit

class RepositoryListViewController: UITableViewController {

    private let organization = "Apple"
    
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
}

//UITableView DataSource Delegate
extension RepositoryListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RepositoryListTableViewCell"), for: IndexPath) as? RepositoryListTableViewCell else  { return UITableViewCell() }
        
        return cell
    }
}
