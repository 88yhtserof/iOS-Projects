//
//  TodayViewController.swift
//  AppStoreStyleService
//
//  Created by 임윤휘 on 2022/08/30.
//

import SnapKit
import UIKit

//TodayViewController를 계승할 class가 없을 예정이니 final로 명시해준다.
final class TodayViewController: UIViewController {
    private var todayList: [TodayModel] = []
    
    private lazy var collectionView: UICollectionView = {
        //collectionView는 layout을 반드시 가지고 있는다.
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.backgroundColor = .systemBackground
        collectionView.register(TodayCollectionViewCell.self, forCellWithReuseIdentifier: "todayCell")
        collectionView.register(TodayCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "TodayCollectionHeaderView")
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        //서버에서 데이터를 받아온다면 view 업데이트가 계속 필요해 viewWillAppear에서 호출해야하지만,
        //로컬 데이터기 때문에 ViewDidLoad에서 호출
        self.fetchData()
    }
}

extension TodayViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("\(todayList.count)")
        return todayList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "todayCell", for: indexPath) as? TodayCollectionViewCell else { return UICollectionViewCell()}
        
        let today = todayList[indexPath.item]
        cell.setUp(today: today)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let header =  collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "TodayCollectionHeaderView", for: indexPath) as? TodayCollectionHeaderView else { return UICollectionReusableView() }
        
        header.setUp()
        
        return header
    }
}

extension TodayViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width - 32.0
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: collectionView.frame.width - 32.0, height: 100.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let value: CGFloat = 16.0
        
        return UIEdgeInsets(top: value, left: value, bottom: value, right: value)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let appDetailViewController = AppDetailViewController()
        
        self.present(appDetailViewController, animated: true)
    }
}

private extension TodayViewController {
    func fetchData() {
        guard let url = Bundle.main.url(forResource: "Today", withExtension: "plist") else { return }
        //데이터를 가져와 디코딩 해주기
        do {
            let data = try Data(contentsOf: url)
            let result = try PropertyListDecoder().decode([TodayModel].self, from: data) //data에서 데이터를 [TodayModel] 타입으로 디코딩 추출
            todayList = result
        } catch {
        }
    }
}
