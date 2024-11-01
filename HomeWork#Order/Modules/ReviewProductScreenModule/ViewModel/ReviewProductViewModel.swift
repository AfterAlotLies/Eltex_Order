//
//  ReviewProductViewModel.swift
//  HomeWork#Order
//
//  Created by Vyacheslav Gusev on 31.10.2024.
//

import Foundation

final class ReviewProductViewModel {
    
    var tableViewCells: [ReviewCellsType] = []
    
    private var productData: Product
    
    init(productData: Product) {
        self.productData = productData
        setupTableViewCellsType()
    }
    
}

private extension ReviewProductViewModel {
    
    func setupTableViewCellsType() {
        tableViewCells = [
            .productInfo(imageName: productData.imageName,
                         productName: productData.productName,
                         productSize: productData.productSize),
            .productRating,
            .productPhotoUpload,
            .productUserReview(textFieldPlaceholder: "Достоинства"),
            .productUserReview(textFieldPlaceholder: "Недостатки"),
            .productUserReview(textFieldPlaceholder: "Комментарий"),
            .checkBox(title: "Оставить отзыв анонимно"),
            .submitButton(buttonTitle: "Отправить")
            ]
    }
}
