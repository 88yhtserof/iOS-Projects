//
//  AlertListTableViewController.swift
//  WaterNotification
//
//  Created by 임윤휘 on 2022/07/06.
//

import UIKit

class AlertListTableViewController: UITableViewController {
    
    var alerts: [AlertModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "AlertListTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "AlertListTableViewCell")
    }
    
    @IBAction func addAlertButton(_ sender: UIBarButtonItem) {
    }
}

//UITableView Datasource, Delegate
extension AlertListTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alerts.count
    }
    
    //헤더 제목 설정
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "물 마실 시간"
        default :
            return nil
        }
    }
    
    //cell 데이터 연결
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AlertListTableViewCell", for: indexPath) as? AlertListTableViewCell else {return UITableViewCell()}
        
        cell.configureCell(
            time: alerts[indexPath.row].time,
            meridiem: alerts[indexPath.row].meridiem,
            isOn: alerts[indexPath.row].isOne
        )
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
