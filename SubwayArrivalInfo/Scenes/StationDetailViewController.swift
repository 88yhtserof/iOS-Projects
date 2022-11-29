//
//  StationDetailViewController.swift
//  SubwayArrivalInfo
//
//  Created by 임윤휘 on 2022/11/29.
//

import UIKit

class StationDetailViewController: UIViewController {
    private lazy var collectionView: UICollectionView = {
        let layout = createBasicListLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        //UITableView와는 다르게, collectionView cell은 여기서 register
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "StationDetailCollectionViewCell")
        collectionView.dataSource = self
        
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    //https://developer.apple.com/documentation/uikit/uicollectionviewcompositionallayout
    private func createBasicListLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.3))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 20, leading: 20, bottom: 20, trailing: 20)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(100))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func configureView() {
        navigationItem.title = "왕십리"
        
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}


extension StationDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StationDetailCollectionViewCell", for: indexPath)
        
        var content = UIListContentConfiguration.cell()
        content.text = "\(indexPath.row)"
        content.secondaryText = "\(indexPath.row)번 collectionViewCell"
        content.image = .init(systemName: "bus")
        content.imageProperties.tintColor = .systemBlue
        
        cell.contentConfiguration = content
        
        return cell
    }
    
    
}
