//
//  TodayModel.swift
//  AppStoreStyleService
//
//  Created by 임윤휘 on 2022/09/17.
//

import Foundation

//plist도 Decodalbe을 사용하면 편리
struct TodayModel: Decodable {
    let title: String
    let subTitle: String
    let description: String
    let imageURL: String
}
