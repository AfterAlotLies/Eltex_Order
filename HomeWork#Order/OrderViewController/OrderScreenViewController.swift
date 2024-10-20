//
//  OrderScreenViewController.swift
//  HomeWork#Order
//
//  Created by Vyacheslav Gusev on 16.10.2024.
//

import UIKit

final class OrderScreenViewController: UIViewController {
    
    private lazy var orderScreenView: OrderScreenView = {
        let view = OrderScreenView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
        setData()
    }
    
    func setData() {
        orderScreenView.showOrder(Order(screenTitle: "Промокоды",
                                        promocodes: [Order.Promocode.init(title: "HELLO",
                                                                          percent: 5,
                                                                          endDate: Date(),
                                                                          info: "Промокод действует на первый заказ в приложении",
                                                                          active: false),
                                                     Order.Promocode.init(title: "VESNA23",
                                                                          percent: 5,
                                                                          endDate: Date(),
                                                                          info: "Промокод действует для заказов от 30 000 ₽",
                                                                          active: false),
                                                     Order.Promocode.init(title: "4300162112534",
                                                                          percent: 5,
                                                                          endDate: Date(),
                                                                          info: nil,
                                                                          active: false),
                                                     Order.Promocode.init(title: "4300162112534",
                                                                          percent: 5,
                                                                          endDate: Date(),
                                                                          info: nil,
                                                                          active: false),
                                                     Order.Promocode.init(title: "4300162112534",
                                                                          percent: 5,
                                                                          endDate: Date(),
                                                                          info: nil,
                                                                          active: false)],
                                        products: [Order.Product.init(price: 30000.0, title: "Продукты")],
                                        paymentDiscount: 0.0,
                                        baseDiscount: 10.0))
    }

}

extension OrderScreenViewController: IOrderScreenView {
    
    func showErrorMessage(errorTitle: String, errorMessage: String) {
        let alert = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "ok", style: .cancel)
        alert.addAction(okButton)
        self.present(alert, animated: true)
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
        titleLabel.text = "Оформление заказа"

        let customTitleView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 60))
        titleLabel.frame = CGRect(x: 25, y: 9, width: 200, height: 40)
        customTitleView.addSubview(titleLabel)

        navigationItem.titleView = customTitleView
    }
}

