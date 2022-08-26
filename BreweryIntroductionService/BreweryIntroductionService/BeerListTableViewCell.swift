//
//  BeerListTableViewCell.swift
//  BreweryIntroductionService
//
//  Created by 임윤휘 on 2022/08/26.
//

import UIKit
import SnapKit
import Kingfisher

class BeerListTableViewCell: UITableViewCell {
    let beerImageView = UIImageView()
    let nameLabel = UILabel()
    let taglineLabel = UILabel()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //view에 구성 요소 채우기
        [beerImageView, nameLabel, taglineLabel].forEach{
            contentView.addSubview($0)
        }
        
        beerImageView.contentMode = .scaleAspectFit
        
        nameLabel.font = .systemFont(ofSize: 18, weight: .bold)
        nameLabel.numberOfLines = 2 //최대 줄 개수
        
        taglineLabel.font = .systemFont(ofSize: 14, weight: .light)
        taglineLabel.textColor = .systemBlue
        taglineLabel.numberOfLines = 0 //줄 개수 제한 없음
        
        //오토레이아웃 설정
        beerImageView.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.leading.trailing.bottom.equalToSuperview().inset(20)
            $0.width.equalTo(80) //고정값
            $0.height.equalTo(120)
        }
        
        nameLabel.snp.makeConstraints{
            $0.leading.equalTo(beerImageView.snp.trailing).offset(10) //왼쪽을 beerImageView의 오른쪽에 10정도 떨어뜨려 배치
            $0.bottom.equalTo(beerImageView.snp.centerY) //label을 imageView의 가운데로 높이 조정
            $0.trailing.equalToSuperview().inset(20)
        }
        
        taglineLabel.snp.makeConstraints{
            $0.leading.trailing.equalTo(nameLabel) //좌우를 nameLabel에 맞춘다.
            $0.top.equalTo(nameLabel.snp.bottom).offset(5) //위를 nameLabel의 아래에 맞춰 tag가 name의 밑에 위치할 수 있도록 한다.
        }
    }
    
    //데이터 전달받을 메서드
    func configure(with beer: Beer) {
        let imageURL = URL(string: beer.imageURL ?? "")
        beerImageView.kf.setImage(with: imageURL, placeholder: #imageLiteral(resourceName: "beer_icon")) //placeholder는 이미지가 로딩 중이거나 전달되지 않았을 경우 띄워주는 기본 이미지를 의미한다.
        nameLabel.text = beer.name ?? "이름 없는 맥주"
        taglineLabel.text = beer.tagLine
        
        //accessoryType 설정 시 cell의 우측에 이미지가 표시된다.
        accessoryType = .disclosureIndicator // > 이미지
        selectionStyle = .none //cell을 클릭하더라도 회색 음영이 나타나지 않는다.
    }
}
