//
//  ContentRankCollectionViewCell.swift
//  NetflixMovieRecommendation
//
//  Created by 임윤휘 on 2022/08/20.
//

import UIKit

class ContentRankCollectionViewCell: UICollectionViewCell {
    let imageView = UIImageView()
    let rankLabel = UILabel()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //contentView
        contentView.layer.cornerRadius = 5
        contentView.clipsToBounds = true
        
        //imageView
        imageView.contentMode = .scaleToFill
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints{
            $0.top.trailing.bottom.equalToSuperview() //상하우를 슈퍼뷰에 붙이기
            $0.width.equalToSuperview().multipliedBy(0.8) // 너비를 슈퍼뷰에 맞추는데, 조금 작게 줄인다. 슈퍼뷰 너비의 0.8배정도
        }
        
        //rankLabel
        rankLabel.font = .systemFont(ofSize: 100, weight: .black)
        rankLabel.textColor = .white
        contentView.addSubview(rankLabel)
        rankLabel.snp.makeConstraints{
            $0.leading.equalToSuperview() //왼쪽을 슈퍼뷰에 붙이기
            $0.bottom.equalToSuperview().offset(25) //아래를 바닥에서 25정도 떨어뜨린다.
        }
    }
}
