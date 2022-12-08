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
    
    private let photoDataView = ProfileDataView(title: "게시글", count: 120)
    private let followerDataView = ProfileDataView(title: "팔로워", count: 2_000)
    private let followingDataView = ProfileDataView(title: "팔로잉", count: 23)
    
    private lazy var collectionView: UICollectionView = {
        let layout = createFeedCollectionLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.dataSource = self
        
        return collectionView
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
        
        let dataStackView = UIStackView(arrangedSubviews: [photoDataView, followerDataView, followingDataView])
        dataStackView.spacing = 4.0
        dataStackView.distribution = .fillEqually
        
        [
            profileImageView,
            dataStackView,
            nameLabel,
            descriptionLabel,
            buttonStackView,
            collectionView
        ].forEach{ view.addSubview($0) }
        
        let inset: CGFloat = 16.0
        
        profileImageView.snp.makeConstraints{ make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(inset)
            make.leading.equalToSuperview().inset(inset)
            make.width.equalTo(80.0)
            make.height.equalTo(profileImageView.snp.width)
        }
        
        dataStackView.snp.makeConstraints{ make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(inset)
            make.trailing.equalToSuperview().inset(inset)
            make.centerY.equalTo(profileImageView.snp.centerY) //프로필 이미지에 Y축 중앙이 맞도록 설정
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
        
        collectionView.snp.makeConstraints{ make in
            make.top.equalTo(buttonStackView.snp.bottom).offset(inset)
            make.horizontalEdges.equalToSuperview().inset(inset)
            make.bottom.equalToSuperview()
        }
    }
    
    func createFeedCollectionLayout() ->  UICollectionViewCompositionalLayout {
        let inset = 0.5
        
        //아래에 count 3을 이용해 horizontal 기분 이미 한 그룹에 열 3개씩 보여준다고 했지만, item을 정사각형으로 만들어주기 위해 groupHeight에 item.layoutSize.widthDimension 할당해 줄 것이기 때문에 .fractionalWidth(0.3)을 설정해준다.
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
        
        //섹션 내 그룹 사이즈!
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: item.layoutSize.widthDimension)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
        
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
}

extension ProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        cell.backgroundColor = .lightGray
        
        return cell
    }
}
