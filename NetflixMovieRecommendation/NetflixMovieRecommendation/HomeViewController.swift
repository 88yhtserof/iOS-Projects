//
//  HomeViewController.swift
//  NetflixMovieRecommendation
//
//  Created by 임윤휘 on 2022/08/18.
//

import UIKit

class HomeViewController: UICollectionViewController {
    var contents: [Content] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //네비게이션 설정
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage() //그림자를 설정해 아래 화면과 구분
        navigationController?.hidesBarsOnSwipe = true //스크롤을 통해 스와이프 액션이 발생하는 경우 네비게이션 바 숨기기
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "netflix_icon"), style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.crop.circle"), style: .plain, target: nil, action: nil)
        
        //Data 설정 및 가져오기
        contents = getContents()
    }
    
    //컨텐츠 배열이 Content.plist에 있는 값을 가지고 오는 메서드
    func getContents() -> [Content] {
        //Content.plist의 경로 알아내기
        guard let path = Bundle.main.path(forResource: "Content", ofType: "plist"), //Conetent 이름을 가지고 파일 타입은 plist이다
              let data = FileManager.default.contents(atPath: path), //FileManager를 통해서 path 경로에 있는 데이터 가져오기
              let list = try? PropertyListDecoder().decode([Content].self, from: data) else { return []}
        //data로부터 [Content]타입의 프로퍼티리스트 디코드하기
        
        return list
    }
}
