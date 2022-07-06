//
//  AlertListTableViewController.swift
//  WaterNotification
//
//  Created by 임윤휘 on 2022/07/06.
//

import UIKit

class AlertListTableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "AlertListTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "AlertListTableViewCell")
    }
    
    @IBAction func addAlertButton(_ sender: UIBarButtonItem) {
    }
}
