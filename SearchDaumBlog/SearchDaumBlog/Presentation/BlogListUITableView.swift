//
//  BlogListUITableView.swift
//  SearchDaumBlog
//
//  Created by 임윤휘 on 2022/12/29.
//

import RxSwift
import RxCocoa

class BlogListUITableView: UITableView {
    let disposeBag = DisposeBag()
    
    let headerView = FilterTableHeaderView(
        frame: CGRect(
            origin: .zero,
            size: CGSize(width: UIScreen.main.bounds.width, height: 50)
        )
    )
    
    //MainViewController에서 네트워크 연결을 통해 데이터를 받아와 BlogListView에 뿌려주기
    let cellData = PublishSubject<[BlogListCellData]>()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        bind()
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        cellData
            .asDriver(onErrorJustReturn: []) //만약 에러가 나면 빈 array 반환
            .drive(self.rx.items) { tableView, row, data in //items은 테이블 뷰 각각의 row에 element의 시퀀스를 바인딩한다.
                let index = IndexPath(row: row, section: 0)
                let cell = tableView.dequeueReusableCell(withIdentifier: "BlogListTableViewCell", for: index) as! BlogListTableViewCell
                
                cell.setData(data)
                return cell
            }
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        self.backgroundColor = .white
        self.register(BlogListTableViewCell.self, forCellReuseIdentifier: "BlogListTableViewCell")
        self.separatorStyle = .singleLine
        self.rowHeight = 100
        self.tableHeaderView = headerView
    }
    
    private func layout() {
        
    }
}
