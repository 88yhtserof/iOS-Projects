//
//  ContentMainCollectionViewCell.swift
//  NetflixStyleCollectionViewSampleApp
//
//  Created by 임윤휘 on 2022/08/21.
//

import UIKit

class ContentMainCollectionViewCell: UICollectionViewCell {
    let baseStackView = UIStackView()
    let menuStackView = UIStackView()
    
    //menuStackView 구성요소
    let tvButton = UIButton()
    let movieButton = UIButton()
    let categoryButton = UIButton()
    
    //baseSatckView 구성요소
    let imageView = UIImageView()
    let descriptionLabel = UILabel()
    let contentStackView = UIStackView()
    
    //contentStackView 구성요소
    let plusButton = UIButton()
    let playButton = UIButton()
    let infoButton = UIButton()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        [baseStackView, menuStackView].forEach{
            contentView.addSubview($0)
        }
        
        //baseStackView
        baseStackView.axis = .vertical //축은 세로방향
        baseStackView.alignment = .center //중앙 정렬
        baseStackView.distribution = .fillProportionally
        baseStackView.spacing = 5
        
        [imageView, descriptionLabel, contentStackView].forEach{
            baseStackView.addArrangedSubview($0)
        }
        
        //imageView
        imageView.contentMode = .scaleAspectFit
        imageView.snp.makeConstraints{
            $0.width.top.leading.trailing.equalToSuperview() //너비, 상, 좌우 슈퍼뷰에 맞추기
            $0.height.equalTo(imageView.snp.width) //자신의 너비에 높이를 맞춰 1:1 비율
        }
        
        //descritionLabel
        descriptionLabel.font = .systemFont(ofSize: 13)
        descriptionLabel.textColor = .white
        descriptionLabel.sizeToFit() //텍스트에 맞춰 뷰 사이즈 조정
        
        descriptionLabel.snp.makeConstraints{
            $0.height.equalTo(13)
        }
        
        //contentStactView
        contentStackView.axis = .horizontal
        contentStackView.alignment = .center
        contentStackView.distribution = .equalSpacing
        contentStackView.spacing = 20
        
        [plusButton, infoButton].forEach{
            $0.titleLabel?.font = .systemFont(ofSize: 13)
            $0.setTitleColor(.white, for: .normal)
            $0.imageView?.tintColor = .white
            //$0.adjustVerticalLayout(5)
        }
        
        plusButton.setTitle("내가 찜한 컨텐츠", for: .normal)
        plusButton.setImage(UIImage(systemName: "plus"), for: .normal)
        plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        
        infoButton.setTitle("정보", for: .normal)
        infoButton.setImage(UIImage(systemName: "info_circle"), for: .normal)
        infoButton.addTarget(self, action: #selector(infoButtonTapped ), for: .touchUpInside)
        
        playButton.setTitle("▶︎ 재생", for: .normal)
        playButton.titleLabel?.font = .systemFont(ofSize: 13)
        playButton.setTitleColor(.black, for: .normal)
        playButton.backgroundColor = .white
        playButton.layer.cornerRadius = 3
        playButton.snp.makeConstraints{
            $0.width.equalTo(90) //고정적인 값 할당
            $0.height.equalTo(30)
        }
        playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        
        [plusButton, playButton, infoButton].forEach{
            contentStackView.addArrangedSubview($0)
        }
        
        contentStackView.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(60)
        }
        
        baseStackView.snp.makeConstraints{
            $0.edges.equalToSuperview() //모든 모서리를 슈퍼뷰에 맞추기
        }
        
        //menuStackView
        menuStackView.axis = .horizontal
        menuStackView.alignment = .center
        menuStackView.distribution = .equalSpacing
        menuStackView.spacing = 20
        
        [tvButton, movieButton, categoryButton].forEach{
            menuStackView.addArrangedSubview($0) //스택뷰에 view을 추가할 때 이 메서드를 사용하면 array로 view를 쌓아준다.
            $0.setTitleColor(.white, for: .normal)
            //그림자 설정
            $0.layer.shadowColor = UIColor.black.cgColor
            $0.layer.shadowOpacity = 1 //그림자 불투명도
            $0.layer.shadowRadius = 3 //그림자 모서리 흐림 정도
        }
        
        tvButton.setTitle("TV 프로그램", for: .normal)
        movieButton.setTitle("영화", for: .normal)
        categoryButton.setTitle("카테고리 ▾", for: .normal) //특수문자 ctl+command+space
        
        tvButton.addTarget(self, action: #selector(tvButtonTapped), for: .touchUpInside)
        movieButton.addTarget(self, action: #selector(movieButtonTapped), for: .touchUpInside)
        categoryButton.addTarget(self, action: #selector(categoryButtonTapped), for: .touchUpInside)
        
        menuStackView.snp.makeConstraints{
            $0.top.equalTo(baseStackView) //상단 모서리를 baseStackView와 동일하게. baseStackView.snp.top과 같은 의미
            $0.leading.trailing.equalToSuperview().inset(30) //좌우를 슈퍼뷰에 30만큼 떨어지도록 설정
        }
    }
    
    //MARK: - Object Selector
    @objc func tvButtonTapped(sender: UIButton!) {
        print("TEST: TV Button Tapped")
    }
    
    @objc func movieButtonTapped(sender: UIButton!) {
        print("TEST: Movie Button Tapped")
    }
    
    @objc func categoryButtonTapped(sender: UIButton!) {
        print("TEST: Category Button Tapped")
    }
    
    @objc func plusButtonTapped(sender: UIButton!) {
        print("TEST: Plus Button Tapped")
    }
    
    @objc func infoButtonTapped(sender: UIButton!) {
        print("TEST: Info Button Tapped")
    }
    
    @objc func playButtonTapped(sender: UIButton!) {
        print("TEST: Play Button Tapped")
    }
}
