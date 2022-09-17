//
//  RankingFeatureSectionView.swift
//  AppStoreStyleService
//
//  Created by 임윤휘 on 2022/09/01.
//

import SnapKit
import UIKit

final class RankingFeatureSectionView: UIView {
    private var rankingFeatureList: [RankingFeatureModel] = []
    
    //private let cellHeight: CGFloat = 30.0
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18.0, weight: .black)
        label.text = "iPhone이 처음이라면"
        
        return label
    }()
    
    private lazy var showAllAppaButton: UIButton = {
        let button = UIButton()
        button.setTitle("모두 보기", for: .normal)
        button.setTitleColor( UIColor.systemBlue , for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14.0, weight: .semibold)
        
        return button
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 32.0
        layout.minimumInteritemSpacing = 0.0
        layout.sectionInset = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = .systemBackground
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(RankingSectionCollectionViewCell.self, forCellWithReuseIdentifier: "RankingFeatureSectionCollectionViewCell")
        
        return collectionView
    }()
    
    private let separator = SeparatorView(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpViews()
        self.fetchData()
        collectionView.reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RankingFeatureSectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width - 32.0, height: RankingSectionCollectionViewCell.height)
    }
}

extension RankingFeatureSectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rankingFeatureList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RankingFeatureSectionCollectionViewCell", for: indexPath) as? RankingSectionCollectionViewCell else { return UICollectionViewCell() }
        
        let rankingFeature = rankingFeatureList[indexPath.item]
        cell.setUp(rankingFeature: rankingFeature)
        
        return cell
    }
}

private extension RankingFeatureSectionView {
    func setUpViews() {
        [
            titleLabel,
            showAllAppaButton,
            collectionView,
            separator
        ].forEach { self.addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.leading.top.equalToSuperview().inset(16.0)
            $0.trailing.equalTo(showAllAppaButton.snp.leading).offset(8.0)
        }
        
        showAllAppaButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16.0)
            $0.bottom.equalTo(titleLabel.snp.bottom)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16.0)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(RankingSectionCollectionViewCell.height * 3)
        }
        
        separator.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom).offset(16.0)
            $0.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    func fetchData() {
        guard let url = Bundle.main.url(forResource: "RankingFeature", withExtension: "plist") else { return }
        
        do {
            let data = try Data(contentsOf: url)
            let result = try PropertyListDecoder().decode([RankingFeatureModel].self, from: data)
            rankingFeatureList = result
        } catch {}
    }
}
