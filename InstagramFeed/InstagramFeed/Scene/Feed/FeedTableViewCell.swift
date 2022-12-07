//
//  FeedTableViewCell.swift
//  InstagramFeed
//
//  Created by 임윤휘 on 2022/12/05.
//

import SnapKit
import UIKit

class FeedTableViewCell: UITableViewCell {
    private lazy var feedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .tertiaryLabel
        
        return imageView
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton()
        //button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.setImage(systemName: "heart")
        
        return button
    }()
    
    private lazy var commentButton: UIButton = {
        let button = UIButton()
        //button.setImage(UIImage(systemName: "message"), for: .normal)
        button.setImage(systemName: "message")
        
        return button
    }()
    
    private lazy var directMessageButton: UIButton = {
        let button = UIButton()
        //button.setImage(UIImage(systemName: "paperplane"), for: .normal)
        button.setImage(systemName: "paperplane")
        
        return button
    }()
    
    private lazy var bookmarkButton: UIButton = {
        let button = UIButton()
        //button.setImage(UIImage(systemName: "bookmark"), for: .normal)
        button.setImage(systemName: "bookmark")
        
        return button
    }()
    
    private lazy var currentLikedCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 13.0, weight: .semibold)
        label.text = "홍길동님 외 32명이 좋아합니다."
        
        return label
    }()
    
    private lazy var contentsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 13.0, weight: .medium)
        label.numberOfLines = 5 //글자가 일정 수를 벗어나면 ...이 되도록
        label.text = "일년 중 눈이 가장 많이 내린다는 절기인 대설은 시기적으로는 음력 11월, 양력으로는 12월 7일이나 8일 무렵에 해당하며 태양의 황경은 255도에 도달한 때이다. 우리나라를 비롯한 동양에서는 음력 10월에 드는 입동(立冬)과 소설, 음력 11월에 드는 대설과 동지 그리고 12월의 소한(小寒), 대한(大寒)까지를 겨울이라 여기지만, 서양에서는 추분(秋分) 이후 대설까지를 가을이라 여긴다."
        
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 11.0, weight: .medium)
        label.text = "1일 전"
        
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func configureView() {
        [
            feedImageView,
            likeButton,
            commentButton,
            directMessageButton,
            bookmarkButton,
            currentLikedCountLabel,
            contentsLabel,
            dateLabel
        ]
            .forEach{ addSubview($0) }
        
        feedImageView.snp.makeConstraints { make in
            make.horizontalEdges.top.equalToSuperview()
            make.height.equalTo(feedImageView.snp.width)
        }
        
        let buttonWidth: CGFloat = 24.0
        let buttonInset: CGFloat = 16.0
        
        likeButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(buttonInset)
            make.top.equalTo(feedImageView.snp.bottom).offset(buttonInset)
            make.size.equalTo(buttonWidth)
        }
        
        commentButton.snp.makeConstraints { make in
            make.leading.equalTo(likeButton.snp.trailing).offset(12.0)
            make.top.equalTo(likeButton.snp.top)
            make.size.equalTo(buttonWidth)
        }
        
        directMessageButton.snp.makeConstraints { make in
            make.leading.equalTo(commentButton.snp.trailing).offset(12.0)
            make.top.equalTo(likeButton.snp.top)
            make.size.equalTo(buttonWidth)
        }
        
        bookmarkButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(buttonInset)
            make.top.equalTo(likeButton.snp.top)
            make.size.equalTo(buttonWidth)
        }
        
        currentLikedCountLabel.snp.makeConstraints{ make in
            make.leading.equalTo(likeButton.snp.leading)
            make.trailing.equalTo(bookmarkButton.snp.trailing)
            make.top.equalTo(likeButton.snp.bottom).offset(14.0)
        }
        
        contentsLabel.snp.makeConstraints{ make in
            make.leading.equalTo(likeButton.snp.leading)
            make.trailing.equalTo(bookmarkButton.snp.trailing)
            make.top.equalTo(currentLikedCountLabel.snp.bottom).offset(8.0)
        }
        
        dateLabel.snp.makeConstraints{ make in
            make.leading.equalTo(likeButton.snp.leading)
            make.trailing.equalTo(bookmarkButton.snp.trailing)
            make.top.equalTo(contentsLabel.snp.bottom).offset(8.0)
            make.bottom.equalToSuperview().inset(16.0)
        }
    }
}
