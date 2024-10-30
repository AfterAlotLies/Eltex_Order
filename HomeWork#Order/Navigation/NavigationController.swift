//
//  NavigationController.swift
//  HomeWork#Order
//
//  Created by Vyacheslav Gusev on 16.10.2024.
//

import Foundation
import UIKit

final class NavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProductsListNavigation()
//        setupNavigation()
    }
}

private extension NavigationController {
    
    func setupProductsListNavigation() {
        let productsListController = ProductsListViewController()
        viewControllers = [productsListController]
    }
    
    func setupNavigation() {
        let orderViewModel = OrderViewModel()
        let ordersScreenViewController = OrderScreenViewController(orderViewModel: orderViewModel)
        viewControllers = [ordersScreenViewController]
    }
}
