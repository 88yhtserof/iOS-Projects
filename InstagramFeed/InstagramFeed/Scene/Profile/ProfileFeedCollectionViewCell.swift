//
//  ProfileFeedCollectionViewCell.swift
//  InstagramFeed
//
//  Created by 임윤휘 on 2022/12/08.
//

import UIKit

class ProfileFeedCollectionViewCell: UICollectionViewCell {
    private let imageView = UIImageView()
    
    func configureCell(with image: UIImage){
        addSubview(imageView)
        imageView.snp.makeConstraints{ make in
            make.edges.equalToSuperview()
        }
        
        imageView.backgroundColor = .tertiaryLabel
    }
}
