//
//  ProfileViewController.swift
//  InstagramFeed
//
//  Created by 임윤휘 on 2022/12/07.
//

import UIKit

class ProfileViewController: UIViewController {
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 40.0
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "UserName"
        label.font = .systemFont(ofSize: 14.0, weight: .semibold)
        
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "방갑습니다!"
        label.font = .systemFont(ofSize: 14.0, weight: .medium)
        label.numberOfLines = 0
        
        return label
    }()
    
    private lazy var followButton: UIButton = {
        let button = UIButton()
        button.setTitle("팔로우", for: .normal)
        button.setTitleColor( UIColor.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14.0, weight: .semibold)
        button.backgroundColor = .systemBlue
        
        button.layer.cornerRadius = 3.0
        
        return button
    }()
    
    private lazy var messageButton: UIButton = {
        let button = UIButton()
        button.setTitle("메세지", for: .normal)
        button.setTitleColor( UIColor.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14.0, weight: .semibold)
        button.backgroundColor = .white
        
        button.layer.cornerRadius = 3.0
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 0.5
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureView()
    }
}

private extension ProfileViewController {
    func configureNavigationBar() {
        navigationItem.title = "UserName"
        
        let rightBarButton = UIBarButtonItem(
            image: UIImage(systemName: "ellipsis"),
            style: .plain,
            target: self,
            action: nil
        )
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    func configureView() {
        let buttonStackView = UIStackView(arrangedSubviews: [followButton, messageButton])
        buttonStackView.spacing = 4.0
        buttonStackView.distribution = .fillEqually
        
        [
            profileImageView,
            nameLabel,
            descriptionLabel,
            buttonStackView
        ].forEach{ view.addSubview($0) }
        
        let inset: CGFloat = 16.0
        
        profileImageView.snp.makeConstraints{ make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(inset)
            make.leading.equalToSuperview().inset(inset)
            make.width.equalTo(80.0)
            make.height.equalTo(profileImageView.snp.width)
        }
        
        nameLabel.snp.makeConstraints{ make in
            make.top.equalTo(profileImageView.snp.bottom).offset(12.0)
            make.leading.equalTo(profileImageView.snp.leading)
            make.trailing.equalToSuperview().inset(inset)
        }
        
        descriptionLabel.snp.makeConstraints{ make in
            make.top.equalTo(nameLabel.snp.bottom).offset(6.0)
            make.leading.equalTo(nameLabel.snp.leading)
            make.trailing.equalTo(nameLabel.snp.trailing)
        }
        
        buttonStackView.snp.makeConstraints{ make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(12.0)
            make.leading.equalTo(nameLabel.snp.leading)
            make.trailing.equalTo(nameLabel.snp.trailing)

        }
    }
}
