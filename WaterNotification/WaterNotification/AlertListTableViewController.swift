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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        alerts = self.alertList()
    }
    
    @IBAction func addAlertButton(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "AddAlert", bundle: nil)
        guard let addAlertViewController = storyboard.instantiateViewController(withIdentifier: "AddAlertViewController") as? AddAlertViewController else {return}
        
        //데이터를 전달해주는 클로저, 데이터 전달받기
        addAlertViewController.pickedDate = {[weak self] date in
            //weak self 순환 참조 방지
            guard let self = self else {return}

            //유저디폴트에서 기존에 있던 알림들 받아오기
            var alertList = self.alertList()
            
            //전달받은 데이터로 알림 생성
            let newAlert = AlertModel(date: date, isOne: true)
            //수시로 알림이 추가되고 시간 순서대로 정렬되고 상태 변경이 셀 별로 있을 것이다.등등 역동적으로 상태가 변경돠는 상황에서
            //어떻게 각 셀들의 상태를 확인할 수 있을까? UserDefaults와 태그 기능 사용
            
            alertList.append(newAlert)
            alertList.sort{$0.date < $1.date} //시간 순으로 정렬
            
            self.alerts = alertList
            UserDefaults.standard.set(try? PropertyListEncoder().encode(self.alerts), forKey: "alerts")
            self.tableView.reloadData()
        }
        
        self.present(addAlertViewController, animated: true)
    }
    
    //UserDefaults에서 알림 목록을 반환해주는 함수
    func alertList() -> [AlertModel] {
        guard let data = UserDefaults.standard.value(forKey: "alerts") as? Data,
              let alerts = try? PropertyListDecoder().decode([AlertModel].self, from: data) else {return []}
                //유저디폴트는 프로퍼티리스트로 데이터를 전달하는데,
              //우리가 임의로 만든 구조체를 이해하지 못하기 때문에 JSON처럼 인코딩 디코딩해서 우리가 만든 객체처럼 구조화할 수 있다.
        return alerts
    }
}

//UITableView Datasource
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
