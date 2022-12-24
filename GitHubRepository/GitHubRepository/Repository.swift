//
//  Repository.swift
//  GitHubRepository
//
//  Created by 임윤휘 on 2022/12/24.
//

import Foundation

struct Repository: Decodable {
    let id: Int
    let name: String
    let description: String
    let stargazersCount: Int
    let launguage: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, launguage
        case stargazersCount = "stargazers_count"
    }
}
