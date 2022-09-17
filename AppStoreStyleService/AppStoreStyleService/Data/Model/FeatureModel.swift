//
//  FeatureModel.swift
//  AppStoreStyleService
//
//  Created by 임윤휘 on 2022/09/17.
//

import Foundation

struct FeatureModel: Decodable {
    let type: String
    let appName: String
    let description: String
    let imageURL: String
}
