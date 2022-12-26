//
//  UIButton+.swift
//  InstagramFeed
//
//  Created by 임윤휘 on 2022/12/05.
//

import UIKit

extension UIButton {
    func setImage(systemName: String) {
        contentHorizontalAlignment = .fill //좌우 꽉 채우기
        contentVerticalAlignment = .fill //상하 꽉 채우기

        imageView?.contentMode = .scaleAspectFit //view의 크기에 딱 맞게 image 크기 조정

        setImage(UIImage(systemName: systemName), for: .normal)
    }
}
