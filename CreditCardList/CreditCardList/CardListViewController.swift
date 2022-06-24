//
//  CardListViewController.swift
//  CreditCardList
//
//  Created by 임윤휘 on 2022/06/24.
//

import UIKit
import Kingfisher

class CardListViewController: UITableViewController {
    /*
     UITableViewController는 Datasource와 Delegate가 연결된 상태를 제공한다.
     그리고 RootView로 UITableView를 가지게 된다.
     */
    
    var creditCardList: [CreditCard] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        let nibName = UINib(nibName: "CardListCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "CardListCell")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return creditCardList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CardListCrll", for: indexPath) as? CardListTableViewCell else {return UITableViewCell()}
        
        cell.rankLabel.text = "\(creditCardList[indexPath.row].rank)위"
        cell.promotionLabel.text = "\(creditCardList[indexPath.row].promotionDetail.amount)만원 증정"
        cell.cardNameLabel.text = "\(creditCardList[indexPath.row].name)"
        
        //Kinkfisher를 사용해 URL 이미지 받아오기
        let imageURL = URL(string: creditCardList[indexPath.row].cardImageURL)
        cell.cardImageView.kf.setImage(with: imageURL)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //cell 선택 시 해당 카드의 상세 화면으로 전환
        guard let cardDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "CardDetailViewController") as? CardDetailViewController else {return}
        
        cardDetailViewController.promotionDetail = creditCardList[indexPath.row].promotionDetail
        self.present(cardDetailViewController, animated: true)
    }
}
