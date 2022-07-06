//
//  AddAlertViewController.swift
//  WaterNotification
//
//  Created by 임윤휘 on 2022/07/07.
//

import UIKit

class AddAlertViewController: UIViewController {
    @IBOutlet weak var datePicker: UIDatePicker!
    
    //클로저를 사용해 알림 추가 완료 버튼 기능 구현
    var pickedDate: ((_ date: Date) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func dismissButtonTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        //클로저 방식으로 데이터 전달하기
        pickedDate?(datePicker.date)
        self.dismiss(animated: true)
    }
}
