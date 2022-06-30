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
    //var ref: DatabaseReference! //Firebase Realtime Database를 가져올 수 있는 레퍼런스. 데이터베이스의 루트를 가리킨다.

    override func viewDidLoad() {
        super.viewDidLoad()

        let nibName = UINib(nibName: "CardListTableViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "CardListTableViewCell")
        
        //ref = Database.database().reference() //Firebase Database와 연결되어 데이터를 주고 받을 수 있다.
        //데이터 읽기
        /*
         실시간 데이터 베이스는 snapshot을 이용해서 데이터를 불러온다. reference를 통해 값을 지켜보고 있다가 snapshot라는 객체로 전달하게 된다.
         우리는 이 객체를 클로저에서 잘 가공해 사용하면 된다.
         snapshot.value는 타입을 지정해주는 것인데. 정확히 타입을 지정해 주지 않으면 nil을 반환한다.
         우리는 디코더를 통해 디코딩하면서 우리가 기존에 만들어 주었던 타입으로 변환해 사용할 수 있다.
         */
//        ref.observe(.value){ [weak self] dataSnapShot in
//            guard let value = dataSnapShot.value as? [String: [String:Any]] else {return} //저장된 데이터베이스에 따라 형변환
//
//            //JSON 디코딩. 디코팅 시 에러가 발생할 수도 있으므로 try-catch구문 사용
//            do{
//                let jsonData = try JSONSerialization.data(withJSONObject: value) //DataSnapshot을 통해 받아온 value를 JSON 데이터로 만들어 반환
//                let cardData = try JSONDecoder().decode([String : CreditCard].self, from: jsonData) //json 데이터를 디코딩
//                let cardList = Array(cardData.values) //딕셔너리 타입이므로 value 값만 받아온다.
//                self?.creditCardList = cardList.sorted{$0.rank < $1.rank} //순위 기준으로 정렬
//
//                //TableView UI 업데이트
//                //UI는 메인스레드에서 설정
//                DispatchQueue.main.async {
//                    self?.tableView.reloadData()
//                }
//            } catch let error {
//                print("ERROR JSON parsing \(error.localizedDescription)")
//            }
//        }
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
        
        //카드 선택 여부 데이터베이스에 저장하기
        //Option1
        //데이터베이스에 경로, 즉 몇 번째 아이템인지 저장되어있으면 할당 쉬움
        //let cardID = creditCardList[indexPath.row].id
        //ref.child("Item\(cardID)/isSelected") //데이터를 할당할 경로(Item\(cardID)아래 isSelected)를 찾고
            //.setValue(true) //그 경로에 값 할당
        
        /*
         데이터 구조에 따라 아이템 객체가 생성될 때마다 임의의 문자열 조합으로 저장하기도 한다.
         서로 다른 데이터가 빠르게 생성될 때 id 중복을 막기 위해 그렇게 구현하기도 하는데,
         문제는 어떤 id로 생성될 지 알 수 없기 때문에 객체가 생성된 다음에야 id를 알 수 있다.
         따라서 우리가 코드를 작성하는 시점에는 id를 알 수 없다.
         이럴 때는 갹채의 특정 컴포넌트를 검색해서 객체의 snapshot을 가져올 수도 있다.
         Item0의 전체 키는 알 수 없지만(Item0이라는 이름이 아닌 임의의 문자열이 키일 수도), 이 객체의 고유한 값 즉 id로 이 객체를 검색해 가져올 수 있다.
         */
        //Option2
//        ref.queryOrdered(byChild: "id") //id라는 키값을 가진 쿼리 불러오기
//            .queryEqual(toValue: cardID) //cardID랑 값이 같은가?
//            .observe(.value) {[weak self] snapshot in //value 타입의 옵져버
//                guard let self = self,
//                      let value = snapshot.value as? [String : [String : Any]],
//                      let key = value.keys.first else {return}
//
//                self.ref.child("\(key)/isSelected").setValue(true)
//            }
    }
    
    //테이블뷰 편집 가능하다고 알려주기
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //편집 스타일 설정
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //데이터 베이스 데이터 삭제하기
            //Option1 경로를 알 경우
            //let cardID = creditCardList[indexPath.row].id
//            ref.child("Item\(cardID)").removeValue()
            
            //Option2 경로를 모를 경우 -> 검색해서 찾기
//            ref.queryOrdered(byChild: "id") //id 키 값을 가진 쿼리
//                .queryEqual(toValue: cardID) //cardId와 같은 경우
//                .observe(.value) {[weak self] snapShot in //수신 대기할 이벤트 타입이 value 타입
//                    guard let self = self,
//                          let value = snapShot.value as? [String : [String:Any]], //snapShot의 valuesms array 값으로 전달된다.
//                          let key = value.keys.first else {return}
//                    //snapShot의 valuesms array 값으로 전달된다.
//                    //하지만 우리는 객체의 고유한 id값으로 검색해 snapshot을 받아왔기 때문에 array더라도 값이 하나뿐이다.
//                    
//                    self.ref.child(key).removeValue()
//                
//                
//            }
            
        }
    }
}
