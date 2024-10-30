//
//  ProductsListView.swift
//  HomeWork#Order
//
//  Created by Vyacheslav Gusev on 30.10.2024.
//

import UIKit

protocol IProductsListView: AnyObject {
    func didCellTapped()
}

final class ProductsListView: UIView {
    
    private lazy var productsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ProductsListTableViewCell.self, forCellReuseIdentifier: ProductsListTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.separatorInset = .init(top: 10, left: 0, bottom: 10, right: 0)
        return tableView
    }()
    
    private var viewModel: ProductsListViewModel
    private var productsModel: [Product]?
    
    weak var delegate: IProductsListView?
    
    init(frame: CGRect, viewModel: ProductsListViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        
        self.viewModel.onNavigate = { [weak self] in
            self?.delegate?.didCellTapped()
        }
        
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setProductsData(_ data: [Product]) {
        productsModel = data
    }
}

extension ProductsListView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let productsData = productsModel else { return 0 }
        return productsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductsListTableViewCell.identifier, for: indexPath) as? ProductsListTableViewCell,
        let productsData = productsModel else {
            return UITableViewCell()
        }
        
        let productData = productsData[indexPath.row]
        cell.configurateCell(with: productData)
        
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
}

extension ProductsListView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.showNextScreen()
    }
}

private extension ProductsListView {
    
    func setupView() {
        backgroundColor = .clear
        addSubview(productsTableView)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            productsTableView.topAnchor.constraint(equalTo: self.topAnchor),
            productsTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            productsTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            productsTableView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
