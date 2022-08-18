//
//  ContentCollectionViewHeader.swift
//  NetflixMovieRecommendation
//
//  Created by 임윤휘 on 2022/08/18.
//

import UIKit

//컬렉션 뷰의 헤더
class ContentCollectionViewHeader: UICollectionReusableView {
    let sectionNameLabel = UILabel()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        sectionNameLabel.font = .systemFont(ofSize: 17, weight: .bold)
        sectionNameLabel.textColor = .white
        sectionNameLabel.sizeToFit()
        
        self.addSubview(sectionNameLabel)
        
        //오토레이아웃 설정
        sectionNameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.top.bottom.leading.equalToSuperview().offset(10) //상하 리딩이 10씩 떨어져 있게 오토레이아웃 설정
        }
    }
}
