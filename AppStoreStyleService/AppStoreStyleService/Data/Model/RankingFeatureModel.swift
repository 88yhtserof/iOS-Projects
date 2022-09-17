//
//  RankingFeatureModel.swift
//  AppStoreStyleService
//
//  Created by 임윤휘 on 2022/09/17.
//

import Foundation

struct RankingFeatureModel: Decodable {
    let title: String
    let description: String
    let isInPurchaseApp: Bool
}
