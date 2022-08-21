//
//  UIButton.swift
//  NetflixMovieRecommendation
//
//  Created by 임윤휘 on 2022/08/21.
//

import UIKit

//버전 업에 따른 코드 수정 진행 중
extension UIButton {
    func adjustVerticalLayout(_ spacing: CGFloat = 0) {
        let imageSize = self.imageView?.frame.size ?? .zero
        let titleLabelSize = self.titleLabel?.frame.size ?? .zero
        
        //iOS 15.0 부터 titleEdgeInsets는 deprecated 되었다 더이상 사용되지 않는다.
        var configuration = UIButton.Configuration.plain()
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: -imageSize.width, bottom: -(imageSize.height + spacing), trailing: 0)
    }
}
