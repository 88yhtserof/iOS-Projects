//
//  MainViewController.swift
//  DaangnMarketplace
//
//  Created by 임윤휘 on 2023/03/31.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class MainViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    let tableView = UITableView()
    let submitButton = UIBarButtonItem()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel: MainViewModel) {
        
    }
    
    private func attribute() {
        title = "중고거래 글쓰기"
        view.backgroundColor = .white
        
        submitButton.title = "제출"
        submitButton.style = .done
        
        navigationItem.setRightBarButton(submitButton, animated: true)
        
        tableView.backgroundColor = .white
        tableView.separatorStyle = .singleLine
        tableView.tableFooterView = UIView() //tableView 하단에 cell이 없으면 footerView가 보여 구분선이 보이지 않도록
        
        tableView.register(TitleTextFiledCell.self, forCellReuseIdentifier: "TitleTextFiledCell") //index row 0
        tableView.register(TitleTextFiledCell.self, forCellReuseIdentifier: "CategorySelectCell") //index row 1
        tableView.register(TitleTextFiledCell.self, forCellReuseIdentifier: "PriceTextFieldCell") //index row 2
        tableView.register(TitleTextFiledCell.self, forCellReuseIdentifier: "DetailWriteFormCell") //index row 3
    }
    
    func layout() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

//MARK: - Alert
typealias Alert = (title: String, message: String?)
extension Reactive where Base: MainViewController {
    var setAlert: Binder<Alert> {
        return Binder(base) { base, data in
            let alertController = UIAlertController(title: data.title, message: data.message, preferredStyle: .alert)
            let action = UIAlertAction(title: "확인", style: .cancel)
            alertController.addAction(action)
            base.present(alertController, animated: true)
            
        }
    }
}
