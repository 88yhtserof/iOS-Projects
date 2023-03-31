//
//  PriceTextFieldCell.swift
//  DaangnMarketplace
//
//  Created by 임윤휘 on 2023/03/31.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PriceTextFieldCell: UITableViewCell {
    let disposeBag = DisposeBag()
    let priceInputField = UITextField()
    let freeShareButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel: PriceTextFieldCellViewModel) {
        
        //ViewModel -> View
        //버튼의 숨김처리 제어
        viewModel.showFreeShareButton
            .map { !$0 }
            .emit(to: freeShareButton.rx.isHidden) //해당 Signal의 Bool값을 isHidden에 묶어둔다.
            .disposed(by: disposeBag)
        
        viewModel.resetPrice//어떤 값이 적혀 있었던 reset시 공백처리
            .map { _ in ""}
            .emit(to: priceInputField.rx.text)
            .disposed(by: disposeBag)
        
        //View -> ViewModel
        priceInputField.rx.text
            .bind(to: viewModel.priceValue)
            .disposed(by: disposeBag)
        
        freeShareButton.rx.tap
            .bind(to: viewModel.freeShareButtonTapped)
            .disposed(by: disposeBag)
    }
    
    func attribute() {
        freeShareButton.setTitle("무료나눔", for: .normal)
        freeShareButton.setTitleColor(.orange, for: .normal)
        freeShareButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        freeShareButton.titleLabel?.font = .systemFont(ofSize: 18)
        freeShareButton.tintColor = .orange
        freeShareButton.backgroundColor = .white
        freeShareButton.layer.borderColor = UIColor.orange.cgColor
        freeShareButton.layer.borderWidth = 1.0
        freeShareButton.layer.cornerRadius = 10.0
        freeShareButton.clipsToBounds = true
        freeShareButton.isHidden = true
        freeShareButton.semanticContentAttribute = .forceRightToLeft
        
        priceInputField.keyboardType = .numberPad
        priceInputField.font = .systemFont(ofSize: 17)
    }
    
    func layout() {
        [ priceInputField, freeShareButton ].forEach {
            contentView.addSubview($0)
        }
        
        priceInputField.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
        
        freeShareButton.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview().inset(15)
            make.width.equalTo(100)
        }
        
    }
}
