//
//  ContentCollectionViewCell.swift
//  NetflixMovieRecommendation
//
//  Created by 임윤휘 on 2022/08/18.
//

import UIKit
import SnapKit

class ContentCollectionViewCell: UICollectionViewCell {
    let imageView = UIImageView()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //cell의 레이아웃은 contentView라는 기본 객체에 설정해야 화면에 보인다.
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 5
        contentView.clipsToBounds = true
        
        imageView.contentMode = .scaleToFill
        
        contentView.addSubview(imageView) //contentView에 view 추가하기
        
        //오토레이아웃 설정하기
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview() //상하좌우 모든 edge가 슈퍼뷰에 딱 맞게 설정
        }
    }
}
