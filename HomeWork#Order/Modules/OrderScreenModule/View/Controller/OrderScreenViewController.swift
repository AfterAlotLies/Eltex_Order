//
//  OrderScreenViewController.swift
//  HomeWork#Order
//
//  Created by Vyacheslav Gusev on 16.10.2024.
//

import UIKit

final class OrderScreenViewController: UIViewController {
    
    private enum Constants {
        static let controllerTitle = "Оформление заказа"
        static let alertOkButtonTitle = "OK"
    }
    
    private lazy var orderScreenView: OrderScreenView = {
        let view = OrderScreenView(frame: .zero, viewModel: orderViewModel)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let orderViewModel = OrderViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
        orderViewModel.delegate = self
        orderViewModel.setData()
    }
    
}

extension OrderScreenViewController: OrderViewModelDelegate {
    
    func setData(_ data: Order) {
        orderScreenView.showOrder(data)
    }
    
    func showErrorAlert(_ titleError: String, _ messageError: String) {
        let alert = UIAlertController(title: titleError,
                                      message: messageError,
                                      preferredStyle: .alert)
        let okButton = UIAlertAction(title: Constants.alertOkButtonTitle,
                                     style: .cancel)
        alert.addAction(okButton)
        if messageError == "Не удалось получить данные" {
            
        }
        self.present(alert, animated: true)
    }
    
    func countOfChoosenPromocodesDidChanged(_ count: Int) {
        if count == 3 {
            orderScreenView.showErrorLabel(for: UIType.tableView)
        }
    }
    
    func isActiveCellDidChanged(_ index: Int) {
        orderScreenView.updateTableViewCellSwitch(for: index)
    }
    
    func didUpdateTotalSum(_ totalSum: Double, totalDiscount: Double) {
        orderScreenView.updateBottomViewUI(totalSum: totalSum, totalDiscount: Int(totalDiscount))
    }
}

private extension OrderScreenViewController {
    
    func setupController() {
        setupNavigationTitle()
        view.addSubview(orderScreenView)
        
        view.backgroundColor = .white
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            orderScreenView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            orderScreenView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            orderScreenView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            orderScreenView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func setupNavigationTitle() {
        let titleLabel = UILabel()
        titleLabel.text = Constants.controllerTitle
        
        let customTitleView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 60))
        titleLabel.frame = CGRect(x: 25, y: 9, width: 200, height: 40)
        customTitleView.addSubview(titleLabel)
        
        navigationItem.titleView = customTitleView
    }
}

