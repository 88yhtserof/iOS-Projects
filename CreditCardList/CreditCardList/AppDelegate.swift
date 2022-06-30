//
//  AppDelegate.swift
//  CreditCardList
//
//  Created by 임윤휘 on 2022/06/24.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        //FirebaseFirestore 사용하기
        let db = Firestore.firestore()
        //데이터 읽기
        //데이터베이스가 비어있을 때만 데이터를 넣기 위해 먼저 데이터베이스를 읽어 데이터 유무를 확인한다.
        db.collection("creditCardList") //데이터베이스의 해당 경로에 참조된 CollectionReference 받아오기
            .getDocuments{snapshot, _ in //실시간데이터베이스처럼 DataSnapshot을 전달하고, 추가로 error를 전달한다.
                guard let snapshot = snapshot, snapshot.isEmpty else {return} //비어있지 않으면 나가기
                let batch = db.batch()//데이터를 작성하기 위한 batch 생성
                //batch 안에 객체를 넣기위한 파일경로 생성
                let card0Ref = db.collection("creditCardList").document("card0")//creditCardList컬렉션의 card0라는 도큐먼트 경로(생성)
                let card1Ref = db.collection("creditCardList").document("card1")
                let card2Ref = db.collection("creditCardList").document("card2")
                let card3Ref = db.collection("creditCardList").document("card3")
                let card4Ref = db.collection("creditCardList").document("card4")
                let card5Ref = db.collection("creditCardList").document("card5")
                let card6Ref = db.collection("creditCardList").document("card6")
                let card7Ref = db.collection("creditCardList").document("card7")
                let card8Ref = db.collection("creditCardList").document("card8")
                let card9Ref = db.collection("creditCardList").document("card9")
                
                //위 생성한 경로에 갈 수 있도록 batch에 setData메서드를 사용해 데이터를 넣는다.
                //하지만 setDat는 throw를 던지는 throw문으로, do-catch 구문을 사용해야한다.
                do {
                    //FirebaseFirestoreSwift를 import해야 setData(from: , forDocument: )사용할 수 있다.
                    //from 매개변수는 커스텀한 객체를 넣을 때 사용한다. 이외에는 Dictionary 타입으로 넣어야한다.
                    try batch.setData(from: CreditCardDummy.card0, forDocument: card0Ref)
                    try batch.setData(from: CreditCardDummy.card1, forDocument: card1Ref)
                    try batch.setData(from: CreditCardDummy.card2, forDocument: card2Ref)
                    try batch.setData(from: CreditCardDummy.card3, forDocument: card3Ref)
                    try batch.setData(from: CreditCardDummy.card4, forDocument: card4Ref)
                    try batch.setData(from: CreditCardDummy.card5, forDocument: card5Ref)
                    try batch.setData(from: CreditCardDummy.card6, forDocument: card6Ref)
                    try batch.setData(from: CreditCardDummy.card7, forDocument: card7Ref)
                    try batch.setData(from: CreditCardDummy.card8, forDocument: card8Ref)
                    try batch.setData(from: CreditCardDummy.card9, forDocument: card9Ref)
                } catch let error {
                    print("Error writing card toFirestore \(error.localizedDescription)")
                }
                batch.commit() //경로에 할당한 데이터 커밋하기
            }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

