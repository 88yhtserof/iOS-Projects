//
//  AlertActionConvertible.swift
//  SearchDaumBlog
//
//  Created by 임윤휘 on 2022/12/29.
//

import UIKit

protocol AlertActionConvertible {
    var title: String { get }
    var style: UIAlertAction.Style { get }
}
