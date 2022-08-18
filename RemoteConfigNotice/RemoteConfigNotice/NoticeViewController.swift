//
//  NoticeViewController.swift
//  RemoteConfigNotice
//
//  Created by 임윤휘 on 2022/08/11.
//

import UIKit

class NoticeViewController: UIViewController {
    //부모 뷰컨트롤러에서 데이터를 받아올 튜플 선언
    var noticeContent: (title: String, detail: String, date: String)? //데이터가 없을 수도 있으므로 옵셔널
    
    @IBOutlet weak var noticeView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //공지사항 뷰 둥글게 처리
        noticeView.layer.cornerRadius = 6
        //팝업창처럼 보이도록 배경 색상 처리
        //검정색에 알파값을 주어 이전 화면이 보이도록 처리한다.
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        //받아온 데이터 UI에 연결하기
        guard let noticeContent = noticeContent else { return }
        titleLabel.text = noticeContent.title
        detailLabel.text = noticeContent.detail
        dateLabel.text = noticeContent.date
    }
    
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}
