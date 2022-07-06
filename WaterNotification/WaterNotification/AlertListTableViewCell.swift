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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(time: String, meridiem:String, isOn: Bool){
        self.timeLabel.text = time
        self.meridiemLabel.text = meridiem
        self.alertSwitch.isOn = isOn
    }
    

    @IBAction func alertSwitchValueChanged(_ sender: UISwitch) {
    }
}
