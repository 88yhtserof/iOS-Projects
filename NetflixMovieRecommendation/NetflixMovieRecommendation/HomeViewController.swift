//
//  HomeViewController.swift
//  NetflixMovieRecommendation
//
//  Created by 임윤휘 on 2022/08/18.
//

import UIKit
import SwiftUI

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
        
        //CollectionView Rank Cell 설정
        collectionView.register(ContentRankCollectionViewCell.self, forCellWithReuseIdentifier: "ContentRankCollectionViewCell")
        
        //헤더 설정
        collectionView.register(ContentCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ContentCollectionViewHeader") //cell이 아니라 Header 속성임을 알려주기 위한 코드
        
        //CollectiomViewLayout 설정
        //우리가 초기에 임시로 SceneDelegate에서 UICollectionViewFlowLayout()를 설정했지만
        //실제로 뷰가 켜지면 레이아웃을 새로 구성한다.
        collectionView.collectionViewLayout = self.layout()
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
        if contents[section].sectionType == .basic
            || contents[section].sectionType == .large
            || contents[section].sectionType == .rank {
            switch section {
            case 0:
                return 1
            case 1:
                return contents[section].contentItem.count
            default:
                return contents[section].contentItem.count
            }
        }
        return 0
    }
    
    //컬렉션 뷰 셀 지정
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch contents[indexPath.section].sectionType {
        case .basic, .large:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContentCollectionViewCell", for: indexPath) as? ContentCollectionViewCell else { return UICollectionViewCell() }
            
            cell.imageView.image = contents[indexPath.section].contentItem[indexPath.row].image
            return cell
        case .rank:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContentRankCollectionViewCell", for: indexPath) as? ContentRankCollectionViewCell else {return UICollectionViewCell()}
            cell.imageView.image = contents[indexPath.section].contentItem[indexPath.row].image
            cell.rankLabel.text = String(describing: indexPath.row + 1)
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
    
    //각각의 섹션 타입에 대한 UICollectionViewLayout 생성
    private func layout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [weak self] sectionNumber, enviroment -> NSCollectionLayoutSection? in
            guard let self = self else { return nil }
            
            //contents마다 가지는 섹션 타입 별로 구분해 작업하기
            switch self.contents[sectionNumber].sectionType {
            case .basic:
                return self.createBasicTypeSection()
            case .large:
                return self.createLargeTypeSection()
            case .rank:
                return self.createRankTypeSection()
            default:
                return nil
            }
        }
    }
    
    //Compositional Layout을 사용해 넷플릭스 배너 UI 구성하기
    //Basic 타입 섹션 레이아웃
    private func createBasicTypeSection() -> NSCollectionLayoutSection {
        //item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3), heightDimension: .fractionalHeight(0.75))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 10, leading: 5, bottom: 0, trailing: 5) //아이템이 상하좌우 간격을 가지도록 설정
        //group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .estimated(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)//group에서 스크롤 방향을 정해줄 수 있다.
        //section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous //섹션의 스크롤 행동 설정
        section.contentInsets = .init(top: 0, leading: 5, bottom: 0, trailing: 5)
        
        //헤더 설정하기
        let sectionHeader = self.createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
    
    //Large 타입 섹션 레이아웃
    private func createLargeTypeSection() -> NSCollectionLayoutSection {
        //item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3), heightDimension: .fractionalHeight(0.75))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 10, leading: 5, bottom: 0, trailing: 5)
        //Large 섹션에서 아이템이 Basic보다 큰데 왜 item의 크기를 Basic과 동일하게 설정할까?
        //group의 크기를 크게 설정해줄 예정!
        //item은 group에 속하기 때문에 group 크기의 영향을 받는다.
        //group의 크기에 따라 item은 설정해둔 비율로 크기가 조정된다.(.fractional옵션을 사용했기 떄문)
        
        //group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .estimated(400))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        //count는 한 화면에 보이는 그룹의 개수(cell..?)를 의미한다.
        
        //section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        
        //헤더 설정하기
        let sectionHeader = self.createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        section.contentInsets = .init(top: 0, leading: 5, bottom: 0, trailing: 5)
        
        return section
    }
    
    //Rank 타입 섹션 레이아웃
    private func createRankTypeSection() -> NSCollectionLayoutSection {
        //item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3), heightDimension: .fractionalHeight(0.9))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 10, leading: 5, bottom: 0, trailing: 5)
        
        //group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .estimated(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        
        //section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        
        //헤더 설정
        let sectionHeader = self.createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        section.contentInsets = .init(top: 0, leading: 5, bottom: 0, trailing: 5)
        
        return section
    }
    
    //SectionHeader 레이아웃 설정
    private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        //SectionHeader 사이즈
        let layoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(30))
        
        //SectionHeader Layout
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutSectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        return sectionHeader
    }
}

//SwiftUI를 활용한 미리보기
struct HomeViewController_Previews: PreviewProvider {
    static var previews: some View {
        Container().edgesIgnoringSafeArea(.all)
    }
    
    struct Container: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> UIViewController {
            let layout = UICollectionViewLayout()
            let homViewController = HomeViewController(collectionViewLayout: layout)
            
            return UINavigationController(rootViewController: homViewController)
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        }
        
        typealias UIViewControllerType = UIViewController
    }
}

