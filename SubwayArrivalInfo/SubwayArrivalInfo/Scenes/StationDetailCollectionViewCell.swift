//
//  StationDetailCollectionViewCell.swift
//  SubwayArrivalInfo
//
//  Created by 임윤휘 on 2022/11/29.
//

import UIKit

class StationDetailCollectionViewCell: UICollectionViewCell {
    
    private lazy var lineLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15.0, weight: .bold)
        
        return label
    }()
    
    private lazy var remainTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15.0, weight: .medium)
        
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configureView()
    }
    
    private func configureView() {
        backgroundColor = .systemBackground
        
        layer.cornerRadius = 12.0
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 5
        
        [lineLabel, remainTimeLabel].forEach{ addSubview($0) }
        
        lineLabel.snp.makeConstraints{ make in
            make.leading.top.equalToSuperview().inset(16)
        }
        
        remainTimeLabel.snp.makeConstraints { make in
            make.leading.equalTo(lineLabel)
            make.top.equalTo(lineLabel.snp.bottom).offset(16.0)
            make.bottom.equalToSuperview().inset(16.0)
        }
    }
    
    func configureCell(with realTimeArrival: StationArrivalDataResponseModel.RealTimeArrivalList){
        lineLabel.text = realTimeArrival.line
        remainTimeLabel.text = realTimeArrival.remainTime
    }
}
