//
//  AlertListTableViewCell.swift
//  WaterNotification
//
//  Created by 임윤휘 on 2022/07/06.
//

import UIKit

class AlertListTableViewCell: UITableViewCell {
    @IBOutlet weak var meridiemLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var alertSwitch: UISwitch!
    
    let userNotificationCenter = UNUserNotificationCenter.current()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(time: String, meridiem:String, isOn: Bool, row: Int){
        self.timeLabel.text = time
        self.meridiemLabel.text = meridiem
        self.alertSwitch.isOn = isOn
        self.alertSwitch.tag = row //tag : 뷰 객체를 구분하는데 사용할 수 있는 정수 값
    }
    

    @IBAction func alertSwitchValueChanged(_ sender: UISwitch) {
        //UserDefaults에서 데이터리스트 가져오기
        guard let data = UserDefaults.standard.value(forKey: "alerts") as? Data, //alerts 키에 해당하는 데이터 가져오기
              var alerts = try? PropertyListDecoder().decode([AlertModel].self, from: data) else {return}
        
        //해당 알람의 isOn 상태 할당
        alerts[sender.tag].isOn = sender.isOn
        //변경된 alerts를 UserDefaults에 재할당
        UserDefaults.standard.set(try? PropertyListEncoder().encode(alerts), forKey: "alerts")
        
        if sender.isOn {
            userNotificationCenter.addNotificationRequest(by: alerts[sender.tag])
        } else{
            //알람이 비활성화되면 NotifiationCenter에 있는 요청서 삭제
            //대기중인(pending) 알림 요청서 중 ID에 해당하는 요청서 삭제
            userNotificationCenter.removePendingNotificationRequests(withIdentifiers: [alerts[sender.tag].id])
        }
    }
}
