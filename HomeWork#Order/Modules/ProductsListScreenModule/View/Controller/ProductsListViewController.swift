//
//  ProductsListViewController.swift
//  HomeWork#Order
//
//  Created by Vyacheslav Gusev on 30.10.2024.
//

import UIKit

final class ProductsListViewController: UIViewController {
    
    private lazy var productsListView: ProductsListView = {
        let view = ProductsListView(frame: .zero, viewModel: viewModel)
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let viewModel = ProductsListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
        
        viewModel.dataDidChanged = { [weak self] data in
            self?.productsListView.setProductsData(data)
        }
        
        viewModel.getData()
    }
}

extension ProductsListViewController: IProductsListView {
    
    func didCellTapped() {
        let reviewProductViewController = ReviewProductViewController()
        self.navigationController?.pushViewController(reviewProductViewController, animated: true)
    }
}

private extension ProductsListViewController {
    
    func showNextController() {
        let reviewProductViewController = ReviewProductViewController()
        self.navigationController?.pushViewController(reviewProductViewController, animated: true)
    }
    
    func setupController() {
        view.backgroundColor = .white
        title = "Напишите отзыв"
        
        view.addSubview(productsListView)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            productsListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            productsListView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            productsListView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            productsListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
