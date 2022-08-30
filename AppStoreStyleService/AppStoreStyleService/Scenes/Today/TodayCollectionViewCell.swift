//
//  TodayCollectionViewCell.swift
//  AppStoreStyleService
//
//  Created by 임윤휘 on 2022/08/30.
//

import SnapKit
import UIKit

final class TodayCollectionViewCell: UICollectionViewCell {
    
    //MARK: - View
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24.0, weight: .bold)
        label.textColor = .white
        
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0, weight: .bold)
        label.textColor = .white
        
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0, weight: .bold)
        label.textColor = .white
        
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds =  true //subview의 경계를 view에 맞춘다.
        imageView.layer.cornerRadius = 12.0
        imageView.backgroundColor = .systemMint
        
        return imageView
    }()
    
    func setUp() {
        setUpSubView()
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.cornerRadius = 10
        
        subtitleLabel.text = "서브타이틀"
        descriptionLabel.text = "설명입니다."
        titleLabel.text = "앱의 이름입니다."
    }
}

private extension TodayCollectionViewCell {
    func setUpSubView() {
        [imageView, titleLabel, subtitleLabel, descriptionLabel].forEach{
            //self.content.addSubView($0)와 차이점이 뭘까
            self.addSubview($0)
        }
        
        //Constraint 설정
        subtitleLabel.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview().inset(24.0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.trailing.equalTo(subtitleLabel)
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(4.0)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview().inset(24.0)
        }
        
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
