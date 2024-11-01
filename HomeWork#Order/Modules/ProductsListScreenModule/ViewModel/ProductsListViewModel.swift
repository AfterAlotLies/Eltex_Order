//
//  ProductsListViewModel.swift
//  HomeWork#Order
//
//  Created by Vyacheslav Gusev on 30.10.2024.
//

import Foundation

final class ProductsListViewModel {
    
    private var productsData: [Product]? {
        didSet {
            if let productsData = productsData {
                dataDidChanged?(productsData)
            }
        }
    }
    
    var dataDidChanged: (([Product]) -> Void)?
    var onNavigate: ((Product) -> Void)?
    
    func getData() {
        productsData = [
            Product(imageName: "firstRing",
                    productName: "Золотое плоское обручальное кольцо 4 мм",
                    productSize: 17),
            Product(imageName: "secondRing",
                    productName: "Золотое плоское\nобручальное 4 мм",
                    productSize: 17),
            Product(imageName: "thirdRing",
                    productName: "Золотое плоское\nобручальное 4 мм",
                    productSize: 17),
            Product(imageName: "fourthRing",
                    productName: "Золотое плоское\nобручальное 4 мм",
                    productSize: 17)
        ]
    }
    
    func showNextScreen(selectedCell: Product) {
        onNavigate?(selectedCell)
    }
}
