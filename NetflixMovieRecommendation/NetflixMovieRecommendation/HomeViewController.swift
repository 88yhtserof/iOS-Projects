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
        
        //collectionView 아이템(Cell) 설정
        collectionView.register(ContentCollectionViewCell.self, forCellWithReuseIdentifier: "ContentCollectionViewCell")
        //헤더 설정
        collectionView.register(ContentCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ContentCollectionViewHeader") //cell이 아니라 Header 속성임을 알려주기 위한 코드
        collectionView.register(ContentCollectionViewHeader.self, forCellWithReuseIdentifier: "ContentCollectionViewHeader")
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

//UICollectionView Datasource, Delegate
extension HomeViewController {
    //섹션 당 보여질 셀의 개수
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return contents[section].contentItem.count
        default:
            return contents[section].contentItem.count
        }
    }
    
    //컬렉션 뷰 셀 지정
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch contents[indexPath.section].sectiontype {
        case .basic, .large:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContentCollectionViewCell", for: indexPath) as? ContentCollectionViewCell else { return UICollectionViewCell() }
            
            cell.imageView.image = contents[indexPath.section].contentItem[indexPath.row].image
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    //헤더 뷰 설정
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader { //속성이 헤더라면
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ContentCollectionViewHeader", for: indexPath) as? ContentCollectionViewHeader else { fatalError("Could not dequeue Header") }
            
            headerView.sectionNameLabel.text = contents[indexPath.section].sectionName
            
            return headerView
        }else {
            return UICollectionReusableView()
        }
    }
    
    //섹션 개수 설정
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return contents.count
    }
    
    //셀 선택
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sectionName = contents[indexPath.section].sectionName
        print("TEST: \(sectionName)섹션의 \(indexPath.row+1)번째 컨텐츠")
    }
}
