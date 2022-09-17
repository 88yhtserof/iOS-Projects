//
//  SeparatorView.swift
//  AppStoreStyleService
//
//  Created by 임윤휘 on 2022/09/01.
//

import SnapKit
import UIKit

final class SeparatorView: UIView {
    private lazy var separator: UIView = {
       let separatorView = UIView()
        separatorView.backgroundColor = .separator
        
        return separatorView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(separator)
        separator.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.trailing.leading.equalToSuperview().inset(16.0)
            $0.height.equalTo(0.5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
