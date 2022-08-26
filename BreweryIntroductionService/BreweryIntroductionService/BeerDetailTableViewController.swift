//
//  BeerDetailTableViewController.swift
//  BreweryIntroductionService
//
//  Created by 임윤휘 on 2022/08/26.
//

import UIKit

class BeerDetailTableViewController: UITableViewController {
    var beer: Beer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = beer?.name ?? "이름 없는 맥주"
        
        tableView = UITableView(frame: tableView.frame, style: .insetGrouped) //fram은 기존 frame을 따르되 스타일은 그룹으로 묶이는 방법
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "BeerDetailListCell") //기본 cell 사용
        tableView.rowHeight = UITableView.automaticDimension //테이블뷰가 알아서 높이를 설정하도록 자동화 설정
        
        //헤더뷰 설정
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 300)
        let headerView = UIImageView(frame: frame)
        let imageURL = URL(string: beer?.imageURL ?? "")
        
        headerView.contentMode = .scaleAspectFit
        headerView.kf.setImage(with: imageURL, placeholder: UIImage(named: "beer_icon"))
        
        tableView.tableHeaderView = headerView
    }
}

//UITableView DataSource, Delegate
extension BeerDetailTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 3: //food paring
            return beer?.foodParing?.count ?? 0
        default:
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "ID"
        case 1:
            return "Description"
        case 2:
            return "Brewers Tips"
        case 3:
            let isFoodParingEmpty = beer?.foodParing?.isEmpty ?? true
            return isFoodParingEmpty ? nil : "Food Paring"
        default:
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "BeerDetailListCell") //기본 cell 형식 사용
        
        cell.selectionStyle = .none //cell 선택 시 회색 음영 삭제
        
        //cell.textLabel은 미래에 더이상 사용되지 않으므로 UIListContentConfiguration를 사용하자
        var content = cell.defaultContentConfiguration()
        content.textProperties.numberOfLines = 0
        
        switch indexPath.section {
        case 0:
            content.text = String(describing: beer?.id ?? 0)
            break
        case 1:
            content.text = beer?.description ?? "설명 없는 맥주"
            break
        case 2:
            content.text = beer?.brewersTips ?? "Tip 없는 맥주"
            break
        case 3:
            content.text = beer?.foodParing?[indexPath.row] ?? ""
            break
        default:
            break
        }
     
        cell.contentConfiguration = content
        return cell
    }
}
