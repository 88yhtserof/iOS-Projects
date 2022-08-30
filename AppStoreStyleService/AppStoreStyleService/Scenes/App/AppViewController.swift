//
//  AppViewController.swift
//  AppStoreStyleService
//
//  Created by 임윤휘 on 2022/08/30.
//

import SnapKit
import UIKit

final class AppViewController: UIViewController {
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 0.0
        
        //임시 View
        let featureSectionView = UIView()
        let rankingFeatureSectionView = UIView()
        let exchangeCodeButtonView = UIView()
        
        featureSectionView.backgroundColor = .systemPurple
        rankingFeatureSectionView.backgroundColor = .systemTeal
        exchangeCodeButtonView.backgroundColor = .systemYellow
        
        [featureSectionView, rankingFeatureSectionView, exchangeCodeButtonView].forEach {
            stackView.addArrangedSubview($0)
            $0.snp.makeConstraints {
                $0.height.equalTo(500.0)
            }
        }
        
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavigationController()
        setUpLayout()
    }
}

private extension AppViewController {
    func setUpNavigationController() {
        navigationItem.title = "앱"
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setUpLayout() {
        self.view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview() //가로만 고정되어 있으므로 세로 스크롤
        }
        
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            //height은 stackView의 subView에 따라 달라져야하므로 지정해서는 안 된다.
        }
    }
}
