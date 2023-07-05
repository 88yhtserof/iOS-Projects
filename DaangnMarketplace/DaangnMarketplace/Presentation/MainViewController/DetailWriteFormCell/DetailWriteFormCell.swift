//
//  DetailWriteFormCell.swift
//  DaangnMarketplace
//
//  Created by 임윤휘 on 2023/03/31.
//

import UIKit
import RxSwift
import RxCocoa

class DetailWriteFormCell: UITableViewCell {
    let disposeBag = DisposeBag()
    let contentInputView = UITextView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel: DetailWriteFormCellViewModel) {
        //contentInputView에 text가 입력되면 viewModel에 넘겨주기
        contentInputView.rx.text
            .bind(to: viewModel.contentValue)
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        contentInputView.font = .systemFont(ofSize: 17)
    }
    
    private func layout() {
        contentView.addSubview(contentInputView)
        
        contentInputView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(300)
        }
        
    }
}
