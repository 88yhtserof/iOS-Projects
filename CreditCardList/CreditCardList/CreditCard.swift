//
//  CreditCard.swift
//  CreditCardList
//
//  Created by 임윤휘 on 2022/06/24.
//

import Foundation

struct CreditCard: Codable {
    let id: Int
    let rank: Int
    let name: String
    let cardImageURL: String
    let promotionDetail: promotionDetail
    //let isSelected: Bool
}

struct promotionDetail: Codable {
    let companyName: String
    let amount: Int
    let period: String
    let condition: String
    let benefitCondition: String
    let benefitDetail: String
    let benefitDate: String
}
