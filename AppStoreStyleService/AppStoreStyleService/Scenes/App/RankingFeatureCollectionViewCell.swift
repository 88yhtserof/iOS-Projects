//
//  RankingFeatureCollectionViewCell.swift
//  AppStoreStyleService
//
//  Created by 임윤휘 on 2022/09/01.
//

import SnapKit
import UIKit

final class RankingSectionCollectionViewCell: UICollectionViewCell {
    static var height: CGFloat { 70.0 }
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .tertiarySystemBackground
        imageView.layer.borderColor = UIColor.tertiaryLabel.cgColor
        imageView.layer.borderWidth = 0.5
        imageView.layer.cornerRadius = 7.0
        
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16.0, weight: .bold)
        label.textColor = .label
        label.numberOfLines = 2
        
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13.0, weight: .semibold)
        label.textColor = .secondaryLabel
        
        return label
    }()
    
    private lazy var downloadButton: UIButton = {
        let button = UIButton()
        button.setTitle("받기", for: .normal)
        button.setTitleColor( UIColor.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13.0, weight: .bold)
        button.backgroundColor = .secondarySystemBackground
        button.layer.cornerRadius = 12.0
        
        return button
    }()
    
    private var inApllPurchaseInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "앱 내 구입"
        label.font = .systemFont(ofSize: 10.0, weight: .semibold)
        label.textColor = .secondaryLabel
        
        return label
    }()
    
    func setUp(rankingFeature: RankingFeatureModel) {
        setupLayout()
        
        //임시 값 설정
        titleLabel.text = rankingFeature.title
        descriptionLabel.text = rankingFeature.description
        //inApllPurchaseInfoLabel.isHidden = [true, false].randomElement() ?? true
        inApllPurchaseInfoLabel.isHidden = !rankingFeature.isInPurchaseApp
    }
}

private extension RankingSectionCollectionViewCell {
    func setupLayout() {
        [
            imageView,
            titleLabel,
            descriptionLabel,
            downloadButton,
            inApllPurchaseInfoLabel
        ].forEach { self.addSubview($0) }
        
        imageView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.bottom.equalToSuperview().inset(4.0)
            $0.width.equalTo(imageView.snp.height)
        }
        
        downloadButton.snp.makeConstraints {
            $0.centerY.trailing.equalToSuperview()
            $0.height.equalTo(24.0)
            $0.width.equalTo(50.0)
        }
        
        inApllPurchaseInfoLabel.snp.makeConstraints {
            $0.centerX.equalTo(downloadButton.snp.centerX)
            $0.top.equalTo(downloadButton.snp.bottom).offset(4.0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(imageView.snp.trailing).offset(8.0)
            $0.trailing.equalTo(downloadButton.snp.leading)
            $0.top.equalTo(imageView.snp.top).inset(8.0)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.trailing.equalTo(titleLabel.snp.trailing)
            $0.top.equalTo(titleLabel.snp.bottom).offset(4.0)
        }
    }
}
