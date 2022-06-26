//
//  CardListViewController.swift
//  CreditCardList
//
//  Created by 임윤휘 on 2022/06/24.
//

import UIKit
import Kingfisher
import FirebaseDatabase

class CardListViewController: UITableViewController {
    /*
     UITableViewController는 Datasource와 Delegate가 연결된 상태를 제공한다.
     그리고 RootView로 UITableView를 가지게 된다.
     */
    
    var creditCardList: [CreditCard] = []
    var ref: DatabaseReference! //Firebase Realtime Database를 가져올 수 있는 레퍼런스. 데이터베이스의 루트를 가리킨다.

    override func viewDidLoad() {
        super.viewDidLoad()

        let nibName = UINib(nibName: "CardListTableViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "CardListTableViewCell")
        
        ref = Database.database().reference() //Firebase Database와 연결되어 데이터를 주고 받을 수 있다.
        //데이터 읽기
        /*
         실시간 데이터 베이스는 snapshot을 이용해서 데이터를 불러온다. reference를 통해 값을 지켜보고 있다가 snapshot라는 객체로 전달하게 된다.
         우리는 이 객체를 클로저에서 잘 가공해 사용하면 된다.
         snapshot.value는 타입을 지정해주는 것인데. 정확히 타입을 지정해 주지 않으면 nil을 반환한다.
         우리는 디코더를 통해 디코딩하면서 우리가 기존에 만들어 주었던 타입으로 변환해 사용할 수 있다.
         */
        ref.observe(.value){ [weak self] dataSnapShot in
            guard let value = dataSnapShot.value as? [String: [String:Any]] else {return} //저장된 데이터베이스에 따라 형변환
            
            //JSON 디코딩. 디코팅 시 에러가 발생할 수도 있으므로 try-catch구문 사용
            do{
                let jsonData = try JSONSerialization.data(withJSONObject: value) //DataSnapshot을 통해 받아온 value를 JSON 데이터로 만들어 반환
                let cardData = try JSONDecoder().decode([String : CreditCard].self, from: jsonData) //json 데이터를 디코딩
                let cardList = Array(cardData.values) //딕셔너리 타입이므로 value 값만 받아온다.
                self?.creditCardList = cardList.sorted{$0.rank < $1.rank} //순위 기준으로 정렬
                
                //TableView UI 업데이트
                //UI는 메인스레드에서 설정
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            } catch let error {
                print("ERROR JSON parsing \(error.localizedDescription)")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return creditCardList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CardListTableViewCell", for: indexPath) as? CardListTableViewCell else {return UITableViewCell()}
        
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
