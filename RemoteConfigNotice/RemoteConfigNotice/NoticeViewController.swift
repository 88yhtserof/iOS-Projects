//
//  NoticeViewController.swift
//  RemoteConfigNotice
//
//  Created by 임윤휘 on 2022/08/11.
//

import UIKit

class NoticeViewController: UIViewController {
    @IBOutlet weak var noticeView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //공지사항 뷰 둥글게 처리
        noticeView.layer.cornerRadius = 6
        //팝업창처럼 보이도록 배경 색상 처리
        //검정색에 알파값을 주어 이전 화면이 보이도록 처리한다.
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
}
