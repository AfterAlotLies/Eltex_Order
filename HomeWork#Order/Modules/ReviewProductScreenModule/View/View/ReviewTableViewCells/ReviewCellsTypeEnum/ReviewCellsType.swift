//
//  ReviewCellsType.swift
//  HomeWork#Order
//
//  Created by Vyacheslav Gusev on 31.10.2024.
//

import Foundation

enum ReviewCellsType {
    case productInfo(imageName: String, productName: String, productSize: Int)
    case productRating
    case productPhotoUpload
    case productUserReview(textFieldPlaceholder: String)
    case checkBox(title: String)
    case submitButton(buttonTitle: String)
}
