//
//  TitleTextFieldCell.swift
//  DaangnMarketplace
//
//  Created by 임윤휘 on 2023/03/31.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class TitleTextFiledCell: UITableViewCell {
    let disposeBag = DisposeBag()
    
    let titleInputField = UITextField()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel: TitleTextFieldCellViewModel) {
        //titleField가 입력된 text를 내뱉으면 ViewModel에 bind해주기
        titleInputField.rx.text
            .bind(to: viewModel.titleText)
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        titleInputField.font = .systemFont(ofSize: 17)
    }
    
    private func layout() {
        contentView.addSubview(titleInputField)
        
        titleInputField.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
    }
}
