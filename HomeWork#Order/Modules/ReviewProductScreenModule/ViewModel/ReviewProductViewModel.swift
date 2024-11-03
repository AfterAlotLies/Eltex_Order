//
//  ReviewProductViewModel.swift
//  HomeWork#Order
//
//  Created by Vyacheslav Gusev on 31.10.2024.
//

import Foundation

final class ReviewProductViewModel {
    
    private let imageNames = ["ruka1", "ruka2", "ruka3", "ruka4", "ruka5", "ruka6", "ruka7"]
    private var currentImageIndex = 0
    private var currentRating: Int = 0
    private var productData: Product
    
    var hasErrorCell = false
    var tableViewCells: [ReviewCellsType] = []
    var uploadedNamesPhotos: [String] = []
    
    var onUploadPhoto: (() -> Void)?
    var onPhotoDelete: ((Int) -> Void)?
    var onConfirmButtomTap: ((Int) -> Void)?
    var onRatingChanged: ((Int) -> Void)?
    var onPhotosUpdate: (() -> Void)?
        
    init(productData: Product) {
        self.productData = productData
        setupTableViewCellsType()
    }
    
    func uploadNewPhoto() {
        let imageName = imageNames[currentImageIndex]
        uploadedNamesPhotos.append(imageName)
        
        currentImageIndex = (currentImageIndex + 1) % imageNames.count
        
        onPhotosUpdate?()
    }
    
    func deletePhoto(indexImage: Int) {
        guard indexImage < uploadedNamesPhotos.count else { return }
        uploadedNamesPhotos.remove(at: indexImage)
        onPhotosUpdate?()
    }
    
    func toggleErrorCell(index: Int) {
        if currentRating == 0 && !hasErrorCell {
            tableViewCells.insert(.errorCell, at: index)
            hasErrorCell = true
            onConfirmButtomTap?(index)
        } else if currentRating > 0 && hasErrorCell {
            tableViewCells.removeAll { $0 == .errorCell }
            hasErrorCell = false
            onRatingChanged?(index)
        }
    }
    
    func updateRating(_ rating: Int) {
        currentRating = rating
        toggleErrorCell(index: 2)
    }
}

private extension ReviewProductViewModel {
    
    func setupTableViewCellsType() {
        tableViewCells = [
            .productInfo(imageName: productData.imageName,
                         productName: productData.productName,
                         productSize: productData.productSize),
            .productRating,
            .clickToAddPhoto,
            .productUserReview(textFieldPlaceholder: "Достоинства"),
            .productUserReview(textFieldPlaceholder: "Недостатки"),
            .productUserReview(textFieldPlaceholder: "Комментарий"),
            .checkBox(title: "Оставить отзыв анонимно"),
            .submitButton(buttonTitle: "Отправить")
            ]
    }
}
